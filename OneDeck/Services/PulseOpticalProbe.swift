//
//  PulseOpticalProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Camera Optical Photoplethysmography (PPG) Heart Rate & Pulse Waveform Hardware Probe.
//

import Foundation
import AVFoundation
import CoreMedia

public final class PulseOpticalProbe: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, @unchecked Sendable {
    public static let shared = PulseOpticalProbe()

    // MARK: - Capture Infrastructure
    private var captureSession: AVCaptureSession?
    private var videoDevice: AVCaptureDevice?
    private let sessionQueue = DispatchQueue(label: "com.onedeck.pulse.sessionQueue")
    private let sampleQueue = DispatchQueue(label: "com.onedeck.pulse.sampleQueue")

    // MARK: - State & Filtering
    private var onFrameCallback: ((_ bpm: Int, _ hrvMs: Double, _ pulseValue: Double, _ isFingerDetected: Bool) -> Void)?
    private var isRunning: Bool = false
    public private(set) var isTorchOn: Bool = false
    private var hasEnsuredTorchOn: Bool = false

    // Signal Processing (Moving Average & Peak Detection)
    private var rawBuffer: [Double] = []
    private var smoothedBuffer: [Double] = []
    private var rrIntervalsMs: [Double] = []
    private var lastPeakTime: Double = 0.0
    private var lastValidBpm: Int = 0
    private var lastValidHrv: Double = 0.0
    private var consecutiveNonFingerFrames: Int = 0

    private override init() {
        super.init()
    }

    // MARK: - Public Controls
    public func startMeasurement(callback: @escaping (_ bpm: Int, _ hrvMs: Double, _ pulseValue: Double, _ isFingerDetected: Bool) -> Void) {
        guard !isRunning else { return }
        self.onFrameCallback = callback
        self.isRunning = true
        self.lastValidBpm = 0
        self.lastValidHrv = 0.0
        self.consecutiveNonFingerFrames = 0
        self.hasEnsuredTorchOn = false

        self.rawBuffer.removeAll()
        self.smoothedBuffer.removeAll()
        self.rrIntervalsMs.removeAll()
        self.lastPeakTime = 0.0

        #if targetEnvironment(simulator)
        startSimulatorMockLoop()
        #else
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        if auth == .authorized {
            sessionQueue.async { [weak self] in
                self?.configureAndStartSession()
            }
        } else if auth == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.sessionQueue.async {
                        self?.configureAndStartSession()
                    }
                }
            }
        }
        #endif
    }

    public func stopMeasurement() {
        guard isRunning else { return }
        isRunning = false
        onFrameCallback = nil

        #if targetEnvironment(simulator)
        simTimer?.cancel()
        simTimer = nil
        #else
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            if let device = self.videoDevice {
                self.enableTorchHardware(device: device, on: false)
            }
            self.captureSession?.stopRunning()
            self.captureSession = nil
            self.videoDevice = nil
        }
        #endif
    }

    // MARK: - Camera Session Configuration
    private func configureAndStartSession() {
        let session = AVCaptureSession()
        session.sessionPreset = .low

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            return
        }
        self.videoDevice = device

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }

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
                if device.isExposureModeSupported(.continuousAutoExposure) {
                    device.exposureMode = .continuousAutoExposure
                }
                if device.isFocusModeSupported(.locked) {
                    device.focusMode = .locked
                }
                device.unlockForConfiguration()
            } catch {}

            // Start capture pipeline
            session.startRunning()
            self.captureSession = session

            // IMPORTANT: Turn on torch AFTER session starts running
            enableTorchHardware(device: device, on: true)
        } catch {
            return
        }
    }

    // MARK: - Hardware Torch Controller
    private func enableTorchHardware(device: AVCaptureDevice, on: Bool) {
        guard device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if on {
                if device.isTorchModeSupported(.on) {
                    try device.setTorchModeOn(level: 0.8)
                    self.isTorchOn = true
                }
            } else {
                if device.isTorchModeSupported(.off) {
                    device.torchMode = .off
                    self.isTorchOn = false
                }
            }
            device.unlockForConfiguration()
        } catch {
            do {
                try device.lockForConfiguration()
                device.torchMode = on ? .on : .off
                self.isTorchOn = on
                device.unlockForConfiguration()
            } catch {}
        }
    }

    public func toggleTorch() {
        sessionQueue.async { [weak self] in
            guard let self = self, let device = self.videoDevice else { return }
            self.enableTorchHardware(device: device, on: !self.isTorchOn)
        }
    }

    // MARK: - Video Frame Processing (PPG Hemoglobin Absorption)
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isRunning, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // Secondary check to ensure torch is active on first frame
        if !hasEnsuredTorchOn, let dev = self.videoDevice, dev.hasTorch {
            hasEnsuredTorchOn = true
            if !dev.isTorchActive {
                enableTorchHardware(device: dev, on: true)
            }
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }

        guard let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer) else { return }
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)

        // Center 40x40 sampling window
        let startX = max(0, (width - 40) / 2)
        let startY = max(0, (height - 40) / 2)
        var totalRed: Double = 0.0
        var totalGreen: Double = 0.0
        var totalBlue: Double = 0.0
        var sampleCount: Double = 0.0

        let buffer = baseAddress.assumingMemoryBound(to: UInt8.self)
        for y in startY..<(startY + 40) {
            let rowOffset = y * bytesPerRow
            for x in startX..<(startX + 40) {
                let pixelOffset = rowOffset + x * 4
                let b = Double(buffer[pixelOffset + 0])
                let g = Double(buffer[pixelOffset + 1])
                let r = Double(buffer[pixelOffset + 2])

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
            consecutiveNonFingerFrames = 0
        } else {
            consecutiveNonFingerFrames += 1
        }

        let isFingerDetected = consecutiveNonFingerFrames < 12 // 400ms tolerance for minor finger adjustments
        let currentTime = CACurrentMediaTime()

        if !isFingerDetected {
            if consecutiveNonFingerFrames > 25 {
                rawBuffer.removeAll()
                smoothedBuffer.removeAll()
                rrIntervalsMs.removeAll()
            }
            Task { @MainActor [weak self] in
                guard let self = self, self.isRunning else { return }
                self.onFrameCallback?(self.lastValidBpm, self.lastValidHrv, 0.0, false)
            }
            return
        }

        // Green channel absorption corresponds inversely to blood volume pulsation
        let rawSignal = -avgGreen
        rawBuffer.append(rawSignal)
        if rawBuffer.count > 180 { rawBuffer.removeFirst() }

        // High-pass DC baseline removal + 5-point smoothing
        let window = Array(rawBuffer.suffix(5))
        let smoothed = window.reduce(0.0, +) / Double(window.count)
        let dcBaseline = rawBuffer.reduce(0.0, +) / Double(rawBuffer.count)
        let acPulse = smoothed - dcBaseline

        smoothedBuffer.append(acPulse)
        if smoothedBuffer.count > 180 { smoothedBuffer.removeFirst() }

        // Adaptive peak detection for BPM
        if smoothedBuffer.count >= 6 {
            let lastIdx = smoothedBuffer.count - 2
            let pPrev = smoothedBuffer[lastIdx - 1]
            let pCurr = smoothedBuffer[lastIdx]
            let pNext = smoothedBuffer[lastIdx + 1]

            // Dynamic amplitude threshold based on recent pulse signal span
            let minVal = smoothedBuffer.min() ?? -1.0
            let maxVal = smoothedBuffer.max() ?? 1.0
            let span = max(0.1, maxVal - minVal)
            let adaptiveThreshold = max(0.06, span * 0.18)

            // Local maximum with adaptive amplitude threshold
            if pCurr > pPrev && pCurr > pNext && pCurr > adaptiveThreshold {
                let timeSinceLast = currentTime - lastPeakTime
                // Physiologically realistic heart interval: 0.35s ~ 1.5s (40 ~ 171 BPM)
                if timeSinceLast >= 0.35 && timeSinceLast <= 1.5 {
                    let intervalMs = timeSinceLast * 1000.0

                    rrIntervalsMs.append(intervalMs)
                    if rrIntervalsMs.count > 12 { rrIntervalsMs.removeFirst() }

                    // RMSSD (Root Mean Square of Successive Differences for HRV)
                    if rrIntervalsMs.count >= 2 {
                        var sumSqDiff: Double = 0.0
                        for i in 1..<rrIntervalsMs.count {
                            let diff = rrIntervalsMs[i] - rrIntervalsMs[i - 1]
                            sumSqDiff += diff * diff
                        }
                        lastValidHrv = sqrt(sumSqDiff / Double(rrIntervalsMs.count - 1))
                    }

                    // Average BPM across recent R-R intervals
                    let avgIntervalSec = (rrIntervalsMs.reduce(0.0, +) / Double(rrIntervalsMs.count)) / 1000.0
                    let calculated = Int(round(60.0 / avgIntervalSec))
                    if calculated >= 40 && calculated <= 180 {
                        lastValidBpm = calculated
                    }
                    lastPeakTime = currentTime
                } else if timeSinceLast > 1.5 {
                    lastPeakTime = currentTime
                }
            }
        }

        let finalBpm = lastValidBpm
        let finalHrv = lastValidHrv
        let finalPulse = acPulse

        Task { @MainActor [weak self] in
            guard let self = self, self.isRunning else { return }
            self.onFrameCallback?(finalBpm, finalHrv, finalPulse, true)
        }
    }

    // MARK: - Simulator Fallback
    #if targetEnvironment(simulator)
    private var simTimer: DispatchSourceTimer?

    private func startSimulatorMockLoop() {
        let timer = DispatchSource.makeTimerSource(queue: sampleQueue)
        timer.schedule(deadline: .now(), repeating: .milliseconds(33)) // 30Hz

        var step: Double = 0.0
        timer.setEventHandler { [weak self] in
            guard let self = self, self.isRunning else { return }
            step += 0.12
            let pulse = sin(step) * 1.5 + sin(step * 2.0) * 0.4
            let bpm = 72 + Int(sin(step * 0.1) * 3.0)
            let hrv = 45.0 + cos(step * 0.1) * 4.0

            Task { @MainActor [weak self] in
                guard let self = self, self.isRunning else { return }
                self.onFrameCallback?(bpm, hrv, pulse, true)
            }
        }
        timer.resume()
        self.simTimer = timer
    }
    #endif
}
