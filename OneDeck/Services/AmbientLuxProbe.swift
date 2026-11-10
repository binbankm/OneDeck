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
import os

public nonisolated enum OpticalSensorStatus: Sendable {
    case active
    case permissionDenied
    case hardwareUnavailable
}

public final class AmbientLuxProbe: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, @unchecked Sendable {
    public static let shared = AmbientLuxProbe()

    private struct ProbeState: Sendable {
        var sessionGeneration: UInt64 = 0
        var isSampling: Bool = false
        var isPowerSaving: Bool = false
        var lastUpdateTimestamp: CFAbsoluteTime = 0
        var onUpdate: (@MainActor @Sendable (_ lux: Double, _ fc: Double, _ ev: Double, _ env: String) -> Void)?
        var onStatus: (@MainActor @Sendable (OpticalSensorStatus) -> Void)?
    }

    private let stateLock = OSAllocatedUnfairLock(initialState: ProbeState())
    private let deviceLock = OSAllocatedUnfairLock<AVCaptureDevice?>(initialState: nil)
    private nonisolated(unsafe) var captureSession: AVCaptureSession?
    private nonisolated(unsafe) var interruptionObservers: [NSObjectProtocol] = []
    private let sessionQueue = DispatchQueue(label: "com.onedeck.lux.sessionQueue")
    private let sampleQueue = DispatchQueue(label: "com.onedeck.lux.sampleQueue")

    public nonisolated var isSampling: Bool {
        stateLock.withLock { $0.isSampling }
    }

    public nonisolated func setPowerSaving(_ isPowerSaving: Bool) {
        stateLock.withLock { $0.isPowerSaving = isPowerSaving }
    }

    public nonisolated var isHardwareAvailable: Bool {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) != nil
            || AVCaptureDevice.default(for: .video) != nil
    }

    override private init() {
        super.init()
    }

    public nonisolated func startLuxSampling(
        isPowerSaving: Bool = false,
        onStatus: (@MainActor @Sendable (OpticalSensorStatus) -> Void)? = nil,
        onUpdate: @escaping @MainActor @Sendable (_ lux: Double, _ fc: Double, _ ev: Double, _ env: String) -> Void
    ) {
        let (shouldStart, gen): (Bool, UInt64) = stateLock.withLock { state in
            state.onUpdate = onUpdate
            state.onStatus = onStatus
            state.isPowerSaving = isPowerSaving
            if state.isSampling { return (false, state.sessionGeneration) }
            state.sessionGeneration &+= 1
            state.isSampling = true
            state.lastUpdateTimestamp = 0
            return (true, state.sessionGeneration)
        }
        guard shouldStart else { return }

        guard isHardwareAvailable else {
            stateLock.withLock { $0.isSampling = false }
            Task { @MainActor in
                onStatus?(.hardwareUnavailable)
            }
            return
        }

        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        switch auth {
        case .authorized:
            sessionQueue.async { [weak self] in
                self?.configureSession(generation: gen)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                let stillWantsRun = self.stateLock.withLock { $0.isSampling && $0.sessionGeneration == gen }
                guard stillWantsRun else { return }
                if granted {
                    self.sessionQueue.async {
                        self.configureSession(generation: gen)
                    }
                } else {
                    let statusCb = self.stateLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                        guard state.sessionGeneration == gen else { return nil }
                        state.isSampling = false
                        return state.onStatus
                    }
                    Task { @MainActor in
                        statusCb?(.permissionDenied)
                    }
                }
            }
        case .denied, .restricted:
            stateLock.withLock { $0.isSampling = false }
            Task { @MainActor in
                onStatus?(.permissionDenied)
            }
        @unknown default:
            stateLock.withLock { $0.isSampling = false }
            Task { @MainActor in
                onStatus?(.hardwareUnavailable)
            }
        }
    }

    public nonisolated func stopLuxSampling() {
        let wasSampling = stateLock.withLock { state -> Bool in
            let prev = state.isSampling
            state.sessionGeneration &+= 1
            state.isSampling = false
            state.onUpdate = nil
            state.onStatus = nil
            return prev
        }
        guard wasSampling else { return }

        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.removeInterruptionObservers()
            self.captureSession?.stopRunning()
            self.captureSession = nil
            self.deviceLock.withLock { $0 = nil }
        }
    }

    private nonisolated func configureSession(generation: UInt64) {
        let shouldConfigure = stateLock.withLock { $0.isSampling && $0.sessionGeneration == generation }
        guard shouldConfigure else { return }

        if let existing = captureSession {
            existing.stopRunning()
            captureSession = nil
        }
        removeInterruptionObservers()

        let session = AVCaptureSession()
        session.beginConfiguration()
        if session.canSetSessionPreset(.low) {
            session.sessionPreset = .low
        }

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            ?? AVCaptureDevice.default(for: .video) else {
            session.commitConfiguration()
            let statusCb = stateLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                state.isSampling = false
                return state.onStatus
            }
            Task { @MainActor in
                statusCb?(.hardwareUnavailable)
            }
            return
        }

        do {
            try device.lockForConfiguration()
            if device.isExposureModeSupported(.continuousAutoExposure) {
                device.exposureMode = .continuousAutoExposure
            }
            device.unlockForConfiguration()

            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input) else {
                session.commitConfiguration()
                let statusCb = stateLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                    state.isSampling = false
                    return state.onStatus
                }
                Task { @MainActor in
                    statusCb?(.hardwareUnavailable)
                }
                return
            }
            session.addInput(input)

            let output = AVCaptureVideoDataOutput()
            output.alwaysDiscardsLateVideoFrames = true
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            output.setSampleBufferDelegate(self, queue: sampleQueue)
            if session.canAddOutput(output) {
                session.addOutput(output)
            }

            session.commitConfiguration()
            guard stateLock.withLock({ $0.isSampling && $0.sessionGeneration == generation }) else { return }
            deviceLock.withLock { $0 = device }
            self.captureSession = session
            registerInterruptionObservers(for: session)
            session.startRunning()

            let statusCb = stateLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                guard state.isSampling && state.sessionGeneration == generation else { return nil }
                return state.onStatus
            }
            Task { @MainActor in
                statusCb?(.active)
            }
        } catch {
            session.commitConfiguration()
            deviceLock.withLock { $0 = nil }
            let statusCb = stateLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                state.isSampling = false
                return state.onStatus
            }
            Task { @MainActor in
                statusCb?(.hardwareUnavailable)
            }
        }
    }

    private nonisolated func registerInterruptionObservers(for session: AVCaptureSession) {
        let nc = NotificationCenter.default
        let ended = nc.addObserver(forName: AVCaptureSession.interruptionEndedNotification, object: session, queue: nil) { [weak self] _ in
            self?.sessionQueue.async { [weak self] in
                guard let self else { return }
                let stillSampling = self.stateLock.withLock { $0.isSampling }
                guard stillSampling else { return }
                if let s = self.captureSession, !s.isRunning {
                    s.startRunning()
                }
            }
        }
        interruptionObservers = [ended]
    }

    private nonisolated func removeInterruptionObservers() {
        for obs in interruptionObservers {
            NotificationCenter.default.removeObserver(obs)
        }
        interruptionObservers.removeAll()
    }

    public nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let now = CFAbsoluteTimeGetCurrent()
        let callback: (@MainActor @Sendable (_ lux: Double, _ fc: Double, _ ev: Double, _ env: String) -> Void)? = stateLock.withLock { state in
            guard state.isSampling, let cb = state.onUpdate else { return nil }
            let minInterval = state.isPowerSaving ? 0.20 : 0.08
            guard state.lastUpdateTimestamp == 0 || (now - state.lastUpdateTimestamp >= minInterval) else {
                return nil
            }
            state.lastUpdateTimestamp = now
            return cb
        }
        guard let callback else { return }

        var fNumber = 1.8
        var exposureTime = 1.0 / 60.0
        var iso = 100.0
        var hasExifFNumber = false
        var hasExifExposure = false
        var hasExifIso = false

        // Extract metadata attachments
        if let attachments = CMCopyDictionaryOfAttachments(
            allocator: kCFAllocatorDefault,
            target: sampleBuffer,
            attachmentMode: kCMAttachmentMode_ShouldPropagate
        ) as? [String: Any],
           let exif = attachments["{Exif}"] as? [String: Any] {
            if let fn = (exif[kCGImagePropertyExifFNumber as String] as? NSNumber)?.doubleValue, fn.isFinite, fn > 0 {
                fNumber = fn
                hasExifFNumber = true
            }
            if let et = (exif[kCGImagePropertyExifExposureTime as String] as? NSNumber)?.doubleValue, et.isFinite, et > 0 {
                exposureTime = et
                hasExifExposure = true
            }
            if let isoArr = exif[kCGImagePropertyExifISOSpeedRatings as String] as? [NSNumber],
               let first = isoArr.first?.doubleValue, first.isFinite, first > 0 {
                iso = first
                hasExifIso = true
            } else if let isoArr = exif[kCGImagePropertyExifISOSpeedRatings as String] as? NSArray,
                      let first = (isoArr.firstObject as? NSNumber)?.doubleValue, first.isFinite, first > 0 {
                iso = first
                hasExifIso = true
            }
        }

        // Secondary fallback to device hardware properties ONLY when EXIF metadata fields were absent
        if (!hasExifIso || !hasExifExposure || !hasExifFNumber), let device = deviceLock.withLock({ $0 }) {
            let devIso = Double(device.iso)
            let devSeconds = CMTimeGetSeconds(device.exposureDuration)
            let devAperture = Double(device.lensAperture)
            if !hasExifIso && devIso > 0 && devIso.isFinite { iso = devIso }
            if !hasExifExposure && devSeconds > 0 && devSeconds.isFinite { exposureTime = devSeconds }
            if !hasExifFNumber && devAperture > 0 && devAperture.isFinite { fNumber = devAperture }
        }

        // Subsample center grid pixel luminance (Rec. 601 Luma: Y = 0.299R + 0.587G + 0.114B)
        var pixelLumaNormalized = 0.46
        if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
            let width = CVPixelBufferGetWidth(imageBuffer)
            let height = CVPixelBufferGetHeight(imageBuffer)
            let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
            if let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer), width > 2, height > 2 {
                var totalY: Double = 0
                var sampleCount: Double = 0
                let stepX = max(1, width / 8)
                let stepY = max(1, height / 8)
                for py in stride(from: stepY, to: height - stepY, by: stepY) {
                    let rowPtr = baseAddress.advanced(by: py * bytesPerRow).assumingMemoryBound(to: UInt8.self)
                    for px in stride(from: stepX, to: width - stepX, by: stepX) {
                        let offset = px * 4
                        guard offset + 3 <= bytesPerRow else { continue }
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
        // EV = log2(N^2 / t) - log2(ISO / 100)
        let ev = log2((fNumber * fNumber) / max(0.0001, exposureTime)) - log2(max(1.0, iso) / 100.0)
        let rawLux = 2.5 * pow(2.0, ev) * (pixelLumaNormalized / 0.46)
        let lux = max(0.1, min(150_000.0, rawLux))
        let footCandles = lux / 10.764

        Task { @MainActor [weak self] in
            guard let self else { return }
            let stillActive = self.stateLock.withLock { $0.isSampling }
            guard stillActive else { return }
            let envDescription = self.describeLux(lux)
            callback(lux, footCandles, ev, envDescription)
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
}
