//
//  PulseOpticalProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Optical camera photoplethysmography (PPG) pulse rate probe.
//

import AVFoundation
import CoreMedia
import Foundation
import os

public final class PulseOpticalProbe: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, @unchecked Sendable {
    public static let shared = PulseOpticalProbe()

    private struct ControlState: Sendable {
        var sessionGeneration: UInt64 = 0
        var isRunning: Bool = false
        var isTorchOn: Bool = false
        var onFrameCallback: (@MainActor @Sendable (_ bpm: Int, _ hrvMs: Double, _ pulseValue: Double, _ isFingerDetected: Bool) -> Void)?
        var onStatus: (@MainActor @Sendable (OpticalSensorStatus) -> Void)?
        var onTorchStateChange: (@MainActor @Sendable (Bool) -> Void)?
    }

    private struct SignalProcessorState {
        var hasEnsuredTorchOn: Bool = false
        var rawBuffer: [Double] = []
        var smoothedBuffer: [Double] = []
        var rrIntervalsMs: [Double] = []
        var lastPeakTime: Double = 0.0
        var lastValidBpm: Int = 0
        var lastValidHrv: Double = 0.0
        var consecutiveNonFingerFrames: Int = 0

        mutating func reset() {
            hasEnsuredTorchOn = false
            rawBuffer.removeAll()
            smoothedBuffer.removeAll()
            rrIntervalsMs.removeAll()
            lastPeakTime = 0.0
            lastValidBpm = 0
            lastValidHrv = 0.0
            consecutiveNonFingerFrames = 0
        }
    }

    // MARK: - Capture Infrastructure
    private let controlLock = OSAllocatedUnfairLock(initialState: ControlState())
    private let deviceLock = OSAllocatedUnfairLock<AVCaptureDevice?>(initialState: nil)
    private nonisolated(unsafe) var captureSession: AVCaptureSession?
    private let sessionQueue = DispatchQueue(label: "com.onedeck.pulse.sessionQueue")
    private let sampleQueue = DispatchQueue(label: "com.onedeck.pulse.sampleQueue")
    private nonisolated(unsafe) var signalState = SignalProcessorState() // Accessed exclusively on sampleQueue
    private nonisolated(unsafe) var interruptionObservers: [NSObjectProtocol] = []

    public nonisolated var isTorchOn: Bool {
        controlLock.withLock { $0.isTorchOn }
    }

    public nonisolated var isHardwareAvailable: Bool {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) != nil
    }

    override private init() {
        super.init()
    }

    // MARK: - Public Controls
    public nonisolated func startMeasurement(
        onStatus: (@MainActor @Sendable (OpticalSensorStatus) -> Void)? = nil,
        onTorchStateChange: (@MainActor @Sendable (Bool) -> Void)? = nil,
        callback: @escaping @MainActor @Sendable (_ bpm: Int, _ hrvMs: Double, _ pulseValue: Double, _ isFingerDetected: Bool) -> Void
    ) {
        let (shouldStart, gen): (Bool, UInt64) = controlLock.withLock { state in
            state.onFrameCallback = callback
            state.onStatus = onStatus
            state.onTorchStateChange = onTorchStateChange
            if state.isRunning { return (false, state.sessionGeneration) }
            state.sessionGeneration &+= 1
            state.isRunning = true
            return (true, state.sessionGeneration)
        }
        guard shouldStart else { return }

        sampleQueue.async { [weak self] in
            self?.signalState.reset()
        }

        guard isHardwareAvailable else {
            controlLock.withLock { $0.isRunning = false }
            Task { @MainActor in
                onStatus?(.hardwareUnavailable)
            }
            return
        }

        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        switch auth {
        case .authorized:
            sessionQueue.async { [weak self] in
                self?.configureAndStartSession(generation: gen)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                let stillValid = self.controlLock.withLock { $0.isRunning && $0.sessionGeneration == gen }
                guard stillValid else { return }
                if granted {
                    self.sessionQueue.async {
                        self.configureAndStartSession(generation: gen)
                    }
                } else {
                    let statusCb = self.controlLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                        guard state.sessionGeneration == gen else { return nil }
                        state.isRunning = false
                        return state.onStatus
                    }
                    Task { @MainActor in
                        statusCb?(.permissionDenied)
                    }
                }
            }
        case .denied, .restricted:
            controlLock.withLock { $0.isRunning = false }
            Task { @MainActor in
                onStatus?(.permissionDenied)
            }
        @unknown default:
            controlLock.withLock { $0.isRunning = false }
            Task { @MainActor in
                onStatus?(.hardwareUnavailable)
            }
        }
    }

    public nonisolated func stopMeasurement() {
        let (wasRunning, torchCb) = controlLock.withLock { state -> (Bool, (@MainActor @Sendable (Bool) -> Void)?) in
            let prev = state.isRunning
            let cb = state.onTorchStateChange
            state.sessionGeneration &+= 1
            state.isRunning = false
            state.isTorchOn = false
            state.onFrameCallback = nil
            state.onStatus = nil
            state.onTorchStateChange = nil
            return (prev, cb)
        }
        if let torchCb {
            Task { @MainActor in torchCb(false) }
        }
        guard wasRunning else { return }

        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.removeInterruptionObservers()
            if let device = self.deviceLock.withLock({ $0 }) {
                self.enableTorchHardware(device: device, on: false)
            }
            self.captureSession?.stopRunning()
            self.captureSession = nil
            self.deviceLock.withLock { $0 = nil }
        }
    }

    // MARK: - Camera Session Configuration
    private nonisolated func configureAndStartSession(generation: UInt64) {
        let stillRunning = controlLock.withLock { $0.isRunning && $0.sessionGeneration == generation }
        guard stillRunning else { return }

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

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            session.commitConfiguration()
            let statusCb = controlLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                state.isRunning = false
                return state.onStatus
            }
            Task { @MainActor in
                statusCb?(.hardwareUnavailable)
            }
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input) else {
                session.commitConfiguration()
                let statusCb = controlLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                    state.isRunning = false
                    return state.onStatus
                }
                Task { @MainActor in
                    statusCb?(.hardwareUnavailable)
                }
                return
            }
            session.addInput(input)

            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            output.alwaysDiscardsLateVideoFrames = true
            output.setSampleBufferDelegate(self, queue: sampleQueue)

            if session.canAddOutput(output) {
                session.addOutput(output)
            }

            // Lock camera settings for stable optical reflectance PPG
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                if device.isExposureModeSupported(.continuousAutoExposure) {
                    device.exposureMode = .continuousAutoExposure
                }
                if device.isFocusModeSupported(.locked) {
                    device.focusMode = .locked
                }
            } catch {}

            session.commitConfiguration()

            guard controlLock.withLock({ $0.isRunning && $0.sessionGeneration == generation }) else { return }
            deviceLock.withLock { $0 = device }
            self.captureSession = session
            registerInterruptionObservers(for: session)
            session.startRunning()

            // Turn on torch AFTER session starts running
            enableTorchHardware(device: device, on: true)

            let statusCb = controlLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                guard state.isRunning && state.sessionGeneration == generation else { return nil }
                return state.onStatus
            }
            Task { @MainActor in
                statusCb?(.active)
            }
        } catch {
            session.commitConfiguration()
            deviceLock.withLock { $0 = nil }
            let statusCb = controlLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                state.isRunning = false
                return state.onStatus
            }
            Task { @MainActor in
                statusCb?(.hardwareUnavailable)
            }
        }
    }

    private nonisolated func registerInterruptionObservers(for session: AVCaptureSession) {
        let nc = NotificationCenter.default
        let interrupted = nc.addObserver(forName: AVCaptureSession.wasInterruptedNotification, object: session, queue: nil) { [weak self] _ in
            self?.sessionQueue.async { [weak self] in
                guard let self, let dev = self.deviceLock.withLock({ $0 }) else { return }
                self.enableTorchHardware(device: dev, on: false)
            }
        }
        let ended = nc.addObserver(forName: AVCaptureSession.interruptionEndedNotification, object: session, queue: nil) { [weak self] _ in
            self?.sessionQueue.async { [weak self] in
                guard let self else { return }
                let stillRunning = self.controlLock.withLock { $0.isRunning }
                guard stillRunning else { return }
                if let s = self.captureSession, !s.isRunning {
                    s.startRunning()
                }
                if let dev = self.deviceLock.withLock({ $0 }) {
                    self.enableTorchHardware(device: dev, on: true)
                }
            }
        }
        interruptionObservers = [interrupted, ended]
    }

    private nonisolated func removeInterruptionObservers() {
        for obs in interruptionObservers {
            NotificationCenter.default.removeObserver(obs)
        }
        interruptionObservers.removeAll()
    }

    // MARK: - Hardware Torch Controller
    private nonisolated func enableTorchHardware(device: AVCaptureDevice, on: Bool) {
        guard device.hasTorch else { return }
        var actualOn = false
        do {
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            if on {
                if device.isTorchModeSupported(.on) {
                    try device.setTorchModeOn(level: 0.8)
                    actualOn = true
                }
            } else {
                if device.isTorchModeSupported(.off) {
                    device.torchMode = .off
                    actualOn = false
                }
            }
        } catch {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                if on && device.isTorchModeSupported(.on) {
                    device.torchMode = .on
                    actualOn = true
                } else if !on && device.isTorchModeSupported(.off) {
                    device.torchMode = .off
                    actualOn = false
                }
            } catch {}
        }

        let resolvedTorchOn = actualOn
        let torchCb = controlLock.withLock { state -> (@MainActor @Sendable (Bool) -> Void)? in
            state.isTorchOn = resolvedTorchOn
            return state.onTorchStateChange
        }
        if let torchCb {
            Task { @MainActor in torchCb(resolvedTorchOn) }
        }
    }

    public nonisolated func toggleTorch() {
        sessionQueue.async { [weak self] in
            guard let self, let device = self.deviceLock.withLock({ $0 }) else { return }
            let nextState = !self.controlLock.withLock { $0.isTorchOn }
            self.enableTorchHardware(device: device, on: nextState)
        }
    }

    // MARK: - Video Frame Processing (PPG Hemoglobin Absorption)
    public nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let callback = controlLock.withLock { state -> (@MainActor @Sendable (_ bpm: Int, _ hrvMs: Double, _ pulseValue: Double, _ isFingerDetected: Bool) -> Void)? in
            guard state.isRunning else { return nil }
            return state.onFrameCallback
        }
        guard let callback, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // Secondary check to ensure torch is active on first frame
        if !signalState.hasEnsuredTorchOn, let dev = deviceLock.withLock({ $0 }), dev.hasTorch {
            signalState.hasEnsuredTorchOn = true
            if !dev.isTorchActive {
                sessionQueue.async { [weak self] in
                    guard let self, let activeDevice = self.deviceLock.withLock({ $0 }) else { return }
                    self.enableTorchHardware(device: activeDevice, on: true)
                }
            }
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }

        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else { return }
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        guard width > 0, height > 0 else { return }

        // Bounded center sampling window (up to 40x40)
        let boxW = min(40, width)
        let boxH = min(40, height)
        let startX = max(0, (width - boxW) / 2)
        let startY = max(0, (height - boxH) / 2)
        var totalRed = 0.0
        var totalGreen = 0.0
        var totalBlue = 0.0
        var sampleCount = 0.0

        let buffer = baseAddress.assumingMemoryBound(to: UInt8.self)
        for y in startY ..< (startY + boxH) {
            let rowOffset = y * bytesPerRow
            for x in startX ..< (startX + boxW) {
                let pixelOffset = x * 4
                guard pixelOffset + 3 <= bytesPerRow else { continue }
                let b = Double(buffer[rowOffset + pixelOffset + 0])
                let g = Double(buffer[rowOffset + pixelOffset + 1])
                let r = Double(buffer[rowOffset + pixelOffset + 2])

                totalRed += r
                totalGreen += g
                totalBlue += b
                sampleCount += 1.0
            }
        }

        guard sampleCount > 0 else { return }
        let avgRed = totalRed / sampleCount
        let avgGreen = totalGreen / sampleCount
        let avgBlue = totalBlue / sampleCount

        // Optical tissue transillumination detection:
        // Finger covering camera with torch creates elevated red brightness dominating blue channel
        let isOpticalFinger = avgRed > 25.0 && (avgRed >= avgGreen * 0.92 || avgRed > 120.0) && (avgRed > avgBlue * 1.1 || avgBlue < 80.0)

        if isOpticalFinger {
            signalState.consecutiveNonFingerFrames = 0
        } else {
            signalState.consecutiveNonFingerFrames += 1
        }

        let isFingerDetected = signalState.consecutiveNonFingerFrames < 12 // 400ms tolerance
        let currentTime = CFAbsoluteTimeGetCurrent()

        if !isFingerDetected {
            if signalState.consecutiveNonFingerFrames > 25 {
                signalState.rawBuffer.removeAll()
                signalState.smoothedBuffer.removeAll()
                signalState.rrIntervalsMs.removeAll()
                signalState.lastPeakTime = 0.0
            }
            let bpmSnap = signalState.lastValidBpm
            let hrvSnap = signalState.lastValidHrv
            Task { @MainActor [weak self] in
                guard let self, self.controlLock.withLock({ $0.isRunning }) else { return }
                callback(bpmSnap, hrvSnap, 0.0, false)
            }
            return
        }

        // Green channel absorption corresponds inversely to blood volume pulsation
        let rawSignal = -avgGreen
        signalState.rawBuffer.append(rawSignal)
        if signalState.rawBuffer.count > 180 { signalState.rawBuffer.removeFirst() }

        // High-pass DC baseline removal + 5-point smoothing
        let window = Array(signalState.rawBuffer.suffix(5))
        let smoothed = window.reduce(0.0, +) / Double(window.count)
        let dcBaseline = signalState.rawBuffer.reduce(0.0, +) / Double(signalState.rawBuffer.count)
        let acPulse = smoothed - dcBaseline

        signalState.smoothedBuffer.append(acPulse)
        if signalState.smoothedBuffer.count > 180 { signalState.smoothedBuffer.removeFirst() }

        // Adaptive peak detection for BPM
        if signalState.smoothedBuffer.count >= 6 {
            let lastIdx = signalState.smoothedBuffer.count - 2
            let pPrev = signalState.smoothedBuffer[lastIdx - 1]
            let pCurr = signalState.smoothedBuffer[lastIdx]
            let pNext = signalState.smoothedBuffer[lastIdx + 1]

            let minVal = signalState.smoothedBuffer.min() ?? -1.0
            let maxVal = signalState.smoothedBuffer.max() ?? 1.0
            let span = max(0.1, maxVal - minVal)
            let adaptiveThreshold = max(0.06, span * 0.18)

            if pCurr > pPrev && pCurr > pNext && pCurr > adaptiveThreshold {
                let timeSinceLast = currentTime - signalState.lastPeakTime
                // Physiologically realistic heart interval: 0.35s ~ 1.5s (40 ~ 171 BPM)
                if timeSinceLast >= 0.35 && timeSinceLast <= 1.5 {
                    let intervalMs = timeSinceLast * 1000.0

                    signalState.rrIntervalsMs.append(intervalMs)
                    if signalState.rrIntervalsMs.count > 12 { signalState.rrIntervalsMs.removeFirst() }

                    // RMSSD (Root Mean Square of Successive Differences for HRV)
                    if signalState.rrIntervalsMs.count >= 2 {
                        var sumSqDiff = 0.0
                        for i in 1 ..< signalState.rrIntervalsMs.count {
                            let diff = signalState.rrIntervalsMs[i] - signalState.rrIntervalsMs[i - 1]
                            sumSqDiff += diff * diff
                        }
                        signalState.lastValidHrv = sqrt(sumSqDiff / Double(signalState.rrIntervalsMs.count - 1))
                    }

                    // Average BPM across recent R-R intervals
                    let avgIntervalSec = (signalState.rrIntervalsMs.reduce(0.0, +) / Double(signalState.rrIntervalsMs.count)) / 1000.0
                    let calculated = Int(round(60.0 / avgIntervalSec))
                    if calculated >= 40 && calculated <= 180 {
                        signalState.lastValidBpm = calculated
                    }
                    signalState.lastPeakTime = currentTime
                } else if timeSinceLast > 1.5 {
                    signalState.lastPeakTime = currentTime
                }
            }
        }

        let finalBpm = signalState.lastValidBpm
        let finalHrv = signalState.lastValidHrv
        let finalPulse = acPulse

        Task { @MainActor [weak self] in
            guard let self, self.controlLock.withLock({ $0.isRunning }) else { return }
            callback(finalBpm, finalHrv, finalPulse, true)
        }
    }
}
