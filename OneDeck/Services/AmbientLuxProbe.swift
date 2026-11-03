//
//  AmbientLuxProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Optical illuminance and ambient lux hardware probe.
//

import AVFoundation
import CoreMedia
import CoreVideo
import ImageIO
import UIKit

public final class AmbientLuxProbe: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, @unchecked Sendable {
    public static let shared = AmbientLuxProbe()

    private var captureSession: AVCaptureSession?
    private var videoDevice: AVCaptureDevice?
    private let sessionQueue = DispatchQueue(label: "com.onedeck.lux.sessionQueue")
    private let sampleQueue = DispatchQueue(label: "com.onedeck.lux.sampleQueue")
    private var isSampling: Bool = false
    private var lastUpdateTimestamp: CFAbsoluteTime = 0

    private var onUpdate: ((_ lux: Double, _ fc: Double, _ ev: Double, _ env: String) -> Void)?

    override private init() {
        super.init()
    }

    public func startLuxSampling(onUpdate: @escaping (_ lux: Double, _ fc: Double, _ ev: Double, _ env: String) -> Void) {
        guard !isSampling else { return }
        self.onUpdate = onUpdate
        self.isSampling = true
        self.lastUpdateTimestamp = 0

        // Emit instantaneous seed reading from screen brightness so UI is never blank
        #if canImport(UIKit)
        let seedLux = max(20.0, Double(UIScreen.main.brightness) * 450.0)
        let seedFc = seedLux / 10.764
        let seedEv = log2(seedLux / 2.5)
        let seedDesc = self.describeLux(seedLux)
        onUpdate(seedLux, seedFc, seedEv, seedDesc)
        #endif

        #if targetEnvironment(simulator)
        startSimulatorLuxLoop()
        #else
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        switch auth {
        case .authorized:
            sessionQueue.async { [weak self] in
                self?.configureSession()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                if granted {
                    self.isSampling = true
                    self.sessionQueue.async {
                        self.configureSession()
                    }
                } else {
                    self.isSampling = false
                }
            }
        case .denied, .restricted:
            self.isSampling = false
            return
        @unknown default:
            self.isSampling = false
            return
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
            guard let self else { return }
            self.captureSession?.stopRunning()
            self.captureSession = nil
            self.videoDevice = nil
        }
        #endif
    }

    private func configureSession() {
        guard isSampling else { return }
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = .low

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) ?? AVCaptureDevice.default(for: .video) else {
            session.commitConfiguration()
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
            if session.canAddInput(input) {
                session.addInput(input)
            }

            let output = AVCaptureVideoDataOutput()
            output.alwaysDiscardsLateVideoFrames = true
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            output.setSampleBufferDelegate(self, queue: sampleQueue)
            if session.canAddOutput(output) {
                session.addOutput(output)
            }

            session.commitConfiguration()
            session.startRunning()
            self.captureSession = session
        } catch {
            session.commitConfiguration()
        }
    }

    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isSampling else { return }

        // Rate limit UI updates (~12Hz normal / ~5Hz power saving) for snappy responsiveness without thermal throttle
        let now = CFAbsoluteTimeGetCurrent()
        let minInterval = AppState.shared.isSensorPowerSaving ? 0.20 : 0.08
        guard lastUpdateTimestamp == 0 || (now - lastUpdateTimestamp >= minInterval) else { return }
        lastUpdateTimestamp = now

        var fNumber = 1.8
        var exposureTime = 1.0 / 60.0
        var iso = 100.0

        // Extract metadata attachments
        if let attachments = CMCopyDictionaryOfAttachments(allocator: kCFAllocatorDefault, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate) as? [String: Any],
           let exif = attachments["{Exif}"] as? [String: Any] {
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

        // Secondary fallback to device hardware properties if EXIF was partial
        if let device = self.videoDevice {
            let devIso = Double(device.iso)
            let devSeconds = CMTimeGetSeconds(device.exposureDuration)
            let devAperture = Double(device.lensAperture)
            if devIso > 0 && devIso.isFinite { iso = devIso }
            if devSeconds > 0 && devSeconds.isFinite { exposureTime = devSeconds }
            if devAperture > 0 && devAperture.isFinite { fNumber = devAperture }
        }

        // Subsample center grid pixel luminance (Rec. 601 Luma: Y = 0.299R + 0.587G + 0.114B)
        var pixelLumaNormalized = 0.46
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
            let width = CVPixelBufferGetWidth(imageBuffer)
            let height = CVPixelBufferGetHeight(imageBuffer)
            let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
            if let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer), width > 0, height > 0 {
                var totalY: Double = 0
                var sampleCount: Double = 0
                let stepX = max(1, width / 8)
                let stepY = max(1, height / 8)
                for py in stride(from: stepY, to: height - stepY, by: stepY) {
                    let rowPtr = baseAddress.advanced(by: py * bytesPerRow).assumingMemoryBound(to: UInt8.self)
                    for px in stride(from: stepX, to: width - stepX, by: stepX) {
                        let offset = px * 4
                        let b = Double(rowPtr[offset])
                        let g = Double(rowPtr[offset + 1])
                        let r = Double(rowPtr[offset + 2])
                        totalY += (0.299 * r + 0.587 * g + 0.114 * b)
                        sampleCount += 1
                    }
                }
                if sampleCount > 0 {
                    pixelLumaNormalized = max(0.02, (totalY / sampleCount) / 255.0)
                }
            }
            CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        }

        // Standard Photometric Equation with dynamic pixel luma scaling:
        // EV = log2(N² / t) - log2(ISO / 100)
        let ev = log2((fNumber * fNumber) / max(0.0001, exposureTime)) - log2(max(1.0, iso) / 100.0)

        // Lux = 2.5 * 2^EV * (pixelLuma / 0.46)
        let rawLux = 2.5 * pow(2.0, ev) * (pixelLumaNormalized / 0.46)
        let lux = max(0.1, min(150_000.0, rawLux))
        let footCandles = lux / 10.764
        let envDescription = describeLux(lux)

        Task { @MainActor [weak self] in
            guard let self, self.isSampling else { return }
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
        timer.schedule(deadline: .now(), repeating: .milliseconds(150)) // ~7Hz

        timer.setEventHandler { [weak self] in
            guard let self, self.isSampling else { return }
            let lux = 480.0 + Double.random(in: 0 ..< 40)
            let fc = lux / 10.764
            let ev = 7.6

            let envText = self.describeLux(lux)
            Task { @MainActor [weak self] in
                guard let self, self.isSampling else { return }
                self.onUpdate?(lux, fc, ev, envText)
            }
        }
        timer.resume()
        self.simTimer = timer
    }
    #endif
}
