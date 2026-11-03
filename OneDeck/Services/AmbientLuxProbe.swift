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
    private var videoDevice: AVCaptureDevice?
    private let sessionQueue = DispatchQueue(label: "com.onedeck.lux.sessionQueue")
    private let sampleQueue = DispatchQueue(label: "com.onedeck.lux.sampleQueue")
    private var isSampling: Bool = false
    private var lastUpdateTimestamp: CFAbsoluteTime = 0

    private var onUpdate: ((_ lux: Double, _ fc: Double, _ ev: Double, _ env: String) -> Void)?

    private override init() {
        super.init()
    }

    public func startLuxSampling(onUpdate: @escaping (_ lux: Double, _ fc: Double, _ ev: Double, _ env: String) -> Void) {
        guard !isSampling else { return }
        self.onUpdate = onUpdate
        self.isSampling = true
        self.lastUpdateTimestamp = 0

        #if targetEnvironment(simulator)
        startSimulatorLuxLoop()
        #else
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        if auth == .authorized {
            sessionQueue.async { [weak self] in
                self?.configureSession()
            }
        } else if auth == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.sessionQueue.async {
                        self?.configureSession()
                    }
                }
            }
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
            self.videoDevice = nil
        }
        #endif
    }

    private func configureSession() {
        let session = AVCaptureSession()
        session.sessionPreset = .low

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) ?? AVCaptureDevice.default(for: .video) else {
            return
        }
        self.videoDevice = device

        do {
            try device.lockForConfiguration()
            if device.isExposureModeSupported(.continuousAutoExposure) {
                device.exposureMode = .continuousAutoExposure
            }
            device.unlockForConfiguration()

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

        // Rate limit UI updates to 10Hz (every 100ms) for high responsiveness without frame drops
        let now = CFAbsoluteTimeGetCurrent()
        guard lastUpdateTimestamp == 0 || (now - lastUpdateTimestamp >= 0.10) else { return }
        lastUpdateTimestamp = now

        var fNumber: Double = 1.8
        var exposureTime: Double = 1.0 / 60.0
        var iso: Double = 100.0

        // Primary source: Direct real-time hardware telemetry from camera sensor
        if let device = self.videoDevice {
            let devIso = Double(device.iso)
            let devSeconds = CMTimeGetSeconds(device.exposureDuration)
            let devAperture = Double(device.lensAperture)

            if devIso > 0 && devIso.isFinite {
                iso = devIso
            }
            if devSeconds > 0 && devSeconds.isFinite {
                exposureTime = devSeconds
            }
            if devAperture > 0 && devAperture.isFinite {
                fNumber = devAperture
            }
        }

        // Secondary refinement: Frame EXIF metadata attachment (safely coerced via NSNumber)
        if let exif = CMGetAttachment(sampleBuffer, key: "{Exif}" as CFString, attachmentModeOut: nil) as? [String: Any] {
            if let fn = (exif[kCGImagePropertyExifFNumber as String] as? NSNumber)?.doubleValue, fn > 0 {
                fNumber = fn
            }
            if let et = (exif[kCGImagePropertyExifExposureTime as String] as? NSNumber)?.doubleValue, et > 0 {
                exposureTime = et
            }
            if let isoArr = exif[kCGImagePropertyExifISOSpeedRatings as String] as? [NSNumber], let first = isoArr.first?.doubleValue, first > 0 {
                iso = first
            } else if let isoArr = exif[kCGImagePropertyExifISOSpeedRatings as String] as? NSArray, let first = (isoArr.firstObject as? NSNumber)?.doubleValue, first > 0 {
                iso = first
            }
        }

        guard fNumber > 0, exposureTime > 0, iso > 0 else { return }

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
        if lux < 50.0 {
            return L10n.Tools.nightHallway
        } else if lux < 300.0 {
            return L10n.Tools.indoorLiving
        } else if lux < 750.0 {
            return L10n.Tools.officeReading
        } else if lux < 1500.0 {
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
