//
//  AmbientLuxProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Optical Photometric Illuminance & Ambient Lux Hardware Meter Probe.
//

import Foundation
import AVFoundation

public final class AmbientLuxProbe: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, @unchecked Sendable {
    public static let shared = AmbientLuxProbe()

    private var captureSession: AVCaptureSession?
    private let sessionQueue = DispatchQueue(label: "com.onedeck.lux.sessionQueue")
    private let sampleQueue = DispatchQueue(label: "com.onedeck.lux.sampleQueue")
    private var isSampling: Bool = false

    private var onUpdate: ((_ lux: Double, _ fc: Double, _ ev: Double, _ env: String) -> Void)?

    private override init() {
        super.init()
    }

    public func startLuxSampling(onUpdate: @escaping (_ lux: Double, _ fc: Double, _ ev: Double, _ env: String) -> Void) {
        guard !isSampling else { return }
        self.onUpdate = onUpdate
        self.isSampling = true

        #if targetEnvironment(simulator)
        startSimulatorLuxLoop()
        #else
        sessionQueue.async { [weak self] in
            self?.configureSession()
        }
        #endif
    }

    public func stopLuxSampling() {
        guard isSampling else { return }
        isSampling = false
        onUpdate = nil

        #if targetEnvironment(simulator)
        simTimer?.cancel()
        simTimer = nil
        #else
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.captureSession?.stopRunning()
            self.captureSession = nil
        }
        #endif
    }

    private func configureSession() {
        let session = AVCaptureSession()
        session.sessionPreset = .low

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) { session.addInput(input) }

            let output = AVCaptureVideoDataOutput()
            output.alwaysDiscardsLateVideoFrames = true
            output.setSampleBufferDelegate(self, queue: sampleQueue)
            if session.canAddOutput(output) { session.addOutput(output) }

            session.startRunning()
            self.captureSession = session
        } catch {
            return
        }
    }

    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isSampling else { return }

        // Extract optical metadata from attachments
        guard let metadata = CMGetAttachment(sampleBuffer, key: "{Exif}" as CFString, attachmentModeOut: nil) as? [String: Any],
              let fNumber = metadata[kCGImagePropertyExifFNumber as String] as? Double,
              let exposureTime = metadata[kCGImagePropertyExifExposureTime as String] as? Double,
              let isoArray = metadata[kCGImagePropertyExifISOSpeedRatings as String] as? [Double],
              let iso = isoArray.first, iso > 0, exposureTime > 0, fNumber > 0 else {
            return
        }

        // Standard Photometric Equation:
        // EV = log2(N² / t) - log2(ISO / 100)
        let ev = log2((fNumber * fNumber) / exposureTime) - log2(iso / 100.0)

        // Lux = 2.5 * 2^EV (Incident light calibration constant C ≈ 250 / 100)
        let lux = max(0.1, 2.5 * pow(2.0, ev))
        let footCandles = lux / 10.764

        let envDescription = describeLux(lux)

        Task { @MainActor [weak self] in
            guard let self = self, self.isSampling else { return }
            self.onUpdate?(lux, footCandles, ev, envDescription)
        }
    }

    public func describeLux(_ lux: Double) -> String {
        if lux < 10.0 {
            return L10n.Tools.nightHallway
        } else if lux < 100.0 {
            return L10n.Tools.nightHallway
        } else if lux < 400.0 {
            return L10n.Tools.indoorLiving
        } else if lux < 1000.0 {
            return L10n.Tools.officeReading
        } else if lux < 5000.0 {
            return L10n.Tools.precisionInspect
        } else {
            return L10n.Tools.daylightSunny
        }
    }

    #if targetEnvironment(simulator)
    private var simTimer: DispatchSourceTimer?

    private func startSimulatorLuxLoop() {
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .userInteractive))
        timer.schedule(deadline: .now(), repeating: .milliseconds(200)) // 5Hz

        timer.setEventHandler { [weak self] in
            guard let self = self, self.isSampling else { return }
            let lux = 480.0 + Double(arc4random_uniform(40))
            let fc = lux / 10.764
            let ev = 7.6

            let envText = self.describeLux(lux)
            Task { @MainActor [weak self] in
                guard let self = self, self.isSampling else { return }
                self.onUpdate?(lux, fc, ev, envText)
            }
        }
        timer.resume()
        self.simTimer = timer
    }
    #endif
}

