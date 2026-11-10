//
//  MicroscopeCameraProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Macro optical camera magnifier and digital zoom probe.
//

import AVFoundation
import CoreImage
import Foundation
import os
import SwiftUI
import UIKit

public final class MicroscopeCameraProbe: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, @unchecked Sendable {
    public static let shared = MicroscopeCameraProbe()

    private struct ControlState: Sendable {
        var desiredRunning: Bool = false
        var isRunning: Bool = false
        var isSessionConfigured: Bool = false
        var isFrozen: Bool = false
        var pendingFreezeCapture: Bool = false
        var filterMode: MicroscopeFilterMode = .normal
        var desiredZoomFactor: CGFloat = 1.0
        var desiredTorchOn: Bool = false
        var lastFilterTimestamp: CFAbsoluteTime = 0
        var onFrameUpdate: (@MainActor @Sendable (UIImage?) -> Void)?
        var onStatus: (@MainActor @Sendable (OpticalSensorStatus) -> Void)?
    }

    public nonisolated(unsafe) let captureSession = AVCaptureSession()
    private let controlLock = OSAllocatedUnfairLock(initialState: ControlState())
    private let sessionQueue = DispatchQueue(label: "com.onedeck.microscope.sessionQueue")
    private let sampleQueue = DispatchQueue(label: "com.onedeck.microscope.sampleQueue")
    private let ciContext = CIContext(options: [.useSoftwareRenderer: false])
    private nonisolated(unsafe) var videoDevice: AVCaptureDevice?
    private nonisolated(unsafe) var videoInput: AVCaptureDeviceInput?
    private nonisolated(unsafe) var videoOutput: AVCaptureVideoDataOutput?
    private nonisolated(unsafe) var frozenSourceCGImage: CGImage? // Accessed exclusively on sampleQueue
    private nonisolated(unsafe) var interruptionObservers: [NSObjectProtocol] = []

    public nonisolated var isHardwareAvailable: Bool {
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) != nil
            || AVCaptureDevice.default(for: .video) != nil
    }

    public nonisolated var authorizationStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }

    override private init() {
        super.init()
    }

    public nonisolated func startSession(
        initialZoom: CGFloat = 1.0,
        initialTorch: Bool = true,
        filterMode: MicroscopeFilterMode = .normal,
        onStatus: (@MainActor @Sendable (OpticalSensorStatus) -> Void)? = nil,
        onFrameUpdate: (@MainActor @Sendable (UIImage?) -> Void)? = nil
    ) {
        controlLock.withLock { state in
            state.desiredRunning = true
            state.isFrozen = false
            state.pendingFreezeCapture = false
            state.filterMode = filterMode
            state.desiredZoomFactor = max(1.0, min(15.0, initialZoom))
            state.desiredTorchOn = initialTorch
            state.onStatus = onStatus
            state.onFrameUpdate = onFrameUpdate
            state.lastFilterTimestamp = 0
        }

        guard isHardwareAvailable else {
            controlLock.withLock { $0.desiredRunning = false }
            Task { @MainActor in
                onStatus?(.hardwareUnavailable)
            }
            return
        }

        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        switch auth {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self else { return }
                let stillWantsRun = self.controlLock.withLock { $0.desiredRunning }
                guard stillWantsRun else { return }
                if granted {
                    self.sessionQueue.async {
                        self.configureAndStartOnSessionQueue()
                    }
                } else {
                    let statusCb = self.controlLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                        state.desiredRunning = false
                        return state.onStatus
                    }
                    Task { @MainActor in
                        statusCb?(.permissionDenied)
                    }
                }
            }
        case .denied, .restricted:
            controlLock.withLock { $0.desiredRunning = false }
            Task { @MainActor in
                onStatus?(.permissionDenied)
            }
        case .authorized:
            sessionQueue.async { [weak self] in
                self?.configureAndStartOnSessionQueue()
            }
        @unknown default:
            controlLock.withLock { $0.desiredRunning = false }
            Task { @MainActor in
                onStatus?(.hardwareUnavailable)
            }
        }
    }

    public nonisolated func stopSession() {
        controlLock.withLock { state in
            state.desiredRunning = false
            state.desiredTorchOn = false
            state.isFrozen = false
            state.pendingFreezeCapture = false
            state.onStatus = nil
            state.onFrameUpdate = nil
        }

        sampleQueue.async { [weak self] in
            self?.frozenSourceCGImage = nil
        }

        sessionQueue.async { [weak self] in
            guard let self else { return }
            self.removeInterruptionObservers()
            self.applyTorchOnSessionQueue(isOn: false)
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
            self.controlLock.withLock { $0.isRunning = false }
        }
    }

    public nonisolated func updateVideoRotation(angle: CGFloat) {
        sessionQueue.async { [weak self] in
            guard let self, let output = self.videoOutput,
                  let conn = output.connection(with: .video),
                  conn.isVideoRotationAngleSupported(angle) else { return }
            conn.videoRotationAngle = angle
        }
    }

    public nonisolated func setZoomFactor(_ factor: CGFloat) {
        let clamped = max(1.0, min(15.0, factor))
        controlLock.withLock { $0.desiredZoomFactor = clamped }
        sessionQueue.async { [weak self] in
            self?.applyZoomOnSessionQueue(clamped)
        }
    }

    public nonisolated func setTorchMode(isOn: Bool) {
        controlLock.withLock { $0.desiredTorchOn = isOn }
        sessionQueue.async { [weak self] in
            self?.applyTorchOnSessionQueue(isOn: isOn)
        }
    }

    public nonisolated func turnTorchOff() {
        setTorchMode(isOn: false)
    }

    public nonisolated func setFilterMode(_ mode: MicroscopeFilterMode) {
        let (isFrozen, callback) = controlLock.withLock { state -> (Bool, (@MainActor @Sendable (UIImage?) -> Void)?) in
            state.filterMode = mode
            return (state.isFrozen, state.onFrameUpdate)
        }
        if isFrozen {
            sampleQueue.async { [weak self] in
                guard let self, let sourceCG = self.frozenSourceCGImage else { return }
                let filtered = self.renderFilteredImage(from: CIImage(cgImage: sourceCG), mode: mode)
                guard let cb = self.controlLock.withLock({ $0.desiredRunning ? $0.onFrameUpdate : nil }) else { return }
                Task { @MainActor in
                    cb(filtered)
                }
            }
        } else if mode == .normal, let callback {
            Task { @MainActor in
                callback(nil)
            }
        }
    }

    public nonisolated func setFrozen(_ frozen: Bool) {
        let callback = controlLock.withLock { state -> (@MainActor @Sendable (UIImage?) -> Void)? in
            state.isFrozen = frozen
            if frozen {
                state.pendingFreezeCapture = true
                return nil
            } else {
                state.pendingFreezeCapture = false
                return state.filterMode == .normal ? state.onFrameUpdate : nil
            }
        }
        if !frozen {
            sampleQueue.async { [weak self] in
                self?.frozenSourceCGImage = nil
            }
        }
        if let callback {
            Task { @MainActor in
                callback(nil)
            }
        }
    }

    // MARK: - Session Queue Helpers
    private nonisolated func configureAndStartOnSessionQueue() {
        let desired = controlLock.withLock { $0.desiredRunning }
        guard desired else { return }

        let alreadyConfigured = controlLock.withLock { $0.isSessionConfigured }
        if !alreadyConfigured {
            captureSession.beginConfiguration()
            if captureSession.canSetSessionPreset(.hd1920x1080) {
                captureSession.sessionPreset = .hd1920x1080
            } else if captureSession.canSetSessionPreset(.high) {
                captureSession.sessionPreset = .high
            }

            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
                ?? AVCaptureDevice.default(for: .video) else {
                captureSession.commitConfiguration()
                let statusCb = controlLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                    state.desiredRunning = false
                    return state.onStatus
                }
                Task { @MainActor in
                    statusCb?(.hardwareUnavailable)
                }
                return
            }

            self.videoDevice = device

            do {
                let input = try AVCaptureDeviceInput(device: device)
                guard captureSession.canAddInput(input) else {
                    captureSession.commitConfiguration()
                    let statusCb = controlLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                        state.desiredRunning = false
                        return state.onStatus
                    }
                    Task { @MainActor in
                        statusCb?(.hardwareUnavailable)
                    }
                    return
                }
                captureSession.addInput(input)
                self.videoInput = input

                let output = AVCaptureVideoDataOutput()
                output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
                output.alwaysDiscardsLateVideoFrames = true
                output.setSampleBufferDelegate(self, queue: sampleQueue)
                if captureSession.canAddOutput(output) {
                    captureSession.addOutput(output)
                    self.videoOutput = output
                    if let conn = output.connection(with: .video), conn.isVideoRotationAngleSupported(90) {
                        conn.videoRotationAngle = 90
                    }
                }
            } catch {
                captureSession.commitConfiguration()
                let statusCb = controlLock.withLock { state -> (@MainActor @Sendable (OpticalSensorStatus) -> Void)? in
                    state.desiredRunning = false
                    return state.onStatus
                }
                Task { @MainActor in
                    statusCb?(.hardwareUnavailable)
                }
                return
            }

            captureSession.commitConfiguration()
            controlLock.withLock { $0.isSessionConfigured = true }
        }

        // Re-check desired state after potentially heavy configuration
        guard controlLock.withLock({ $0.desiredRunning }) else { return }

        registerInterruptionObservers()
        if !captureSession.isRunning {
            captureSession.startRunning()
        }

        let (zoom, torchOn, statusCb) = controlLock.withLock { state -> (CGFloat, Bool, (@MainActor @Sendable (OpticalSensorStatus) -> Void)?) in
            state.isRunning = true
            return (state.desiredZoomFactor, state.desiredTorchOn, state.onStatus)
        }

        applyZoomOnSessionQueue(zoom)
        if torchOn {
            applyTorchOnSessionQueue(isOn: true)
        }

        Task { @MainActor in
            statusCb?(.active)
        }
    }

    private nonisolated func registerInterruptionObservers() {
        removeInterruptionObservers()
        let nc = NotificationCenter.default
        let interrupted = nc.addObserver(forName: AVCaptureSession.wasInterruptedNotification, object: captureSession, queue: nil) { [weak self] _ in
            self?.sessionQueue.async { [weak self] in
                self?.applyTorchOnSessionQueue(isOn: false)
            }
        }
        let ended = nc.addObserver(forName: AVCaptureSession.interruptionEndedNotification, object: captureSession, queue: nil) { [weak self] _ in
            self?.sessionQueue.async { [weak self] in
                guard let self else { return }
                let (desired, torchOn) = self.controlLock.withLock { ($0.desiredRunning, $0.desiredTorchOn) }
                guard desired else { return }
                if !self.captureSession.isRunning {
                    self.captureSession.startRunning()
                }
                if torchOn {
                    self.applyTorchOnSessionQueue(isOn: true)
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

    private nonisolated func applyZoomOnSessionQueue(_ factor: CGFloat) {
        guard let device = videoDevice else { return }
        do {
            try device.lockForConfiguration()
            let maxZoom = min(15.0, device.activeFormat.videoMaxZoomFactor)
            device.videoZoomFactor = max(1.0, min(maxZoom, factor))
            device.unlockForConfiguration()
        } catch {}
    }

    private nonisolated func applyTorchOnSessionQueue(isOn: Bool) {
        guard let device = videoDevice, device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if isOn {
                if device.isTorchModeSupported(.on) {
                    try device.setTorchModeOn(level: 1.0)
                }
            } else {
                if device.isTorchModeSupported(.off) {
                    device.torchMode = .off
                }
            }
            device.unlockForConfiguration()
        } catch {}
    }

    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    public nonisolated func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        let now = CFAbsoluteTimeGetCurrent()
        let job: (MicroscopeFilterMode, Bool, @MainActor @Sendable (UIImage?) -> Void)? = controlLock.withLock { state in
            guard state.desiredRunning, let cb = state.onFrameUpdate else { return nil }

            if state.pendingFreezeCapture {
                state.pendingFreezeCapture = false
                return (state.filterMode, true, cb)
            }

            if state.isFrozen || state.filterMode == .normal {
                return nil
            }

            // Throttle live CoreImage filtering to ~20fps for crisp, low-thermal preview
            guard state.lastFilterTimestamp == 0 || (now - state.lastFilterTimestamp >= 0.05) else {
                return nil
            }
            state.lastFilterTimestamp = now
            return (state.filterMode, false, cb)
        }

        guard let (filterMode, capturingFreeze, callback) = job,
              let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let baseImage = CIImage(cvPixelBuffer: pixelBuffer)
        if capturingFreeze {
            self.frozenSourceCGImage = ciContext.createCGImage(baseImage, from: baseImage.extent)
        }

        guard let uiImage = renderFilteredImage(from: baseImage, mode: filterMode) else { return }

        Task { @MainActor [weak self] in
            guard let self, self.controlLock.withLock({ $0.desiredRunning }) else { return }
            callback(uiImage)
        }
    }

    private nonisolated func renderFilteredImage(from baseImage: CIImage, mode: MicroscopeFilterMode) -> UIImage? {
        let outputImage: CIImage

        switch mode {
        case .normal:
            outputImage = baseImage
        case .inverted:
            if let filter = CIFilter(name: "CIColorInvert") {
                filter.setValue(baseImage, forKey: kCIInputImageKey)
                outputImage = filter.outputImage ?? baseImage
            } else {
                outputImage = baseImage
            }
        case .highContrast:
            if let filter = CIFilter(name: "CIColorControls") {
                filter.setValue(baseImage, forKey: kCIInputImageKey)
                filter.setValue(0.0, forKey: kCIInputSaturationKey)
                filter.setValue(2.2, forKey: kCIInputContrastKey)
                filter.setValue(0.05, forKey: kCIInputBrightnessKey)
                outputImage = filter.outputImage ?? baseImage
            } else {
                outputImage = baseImage
            }
        case .edgeDetection:
            if let filter = CIFilter(name: "CIEdges") {
                filter.setValue(baseImage, forKey: kCIInputImageKey)
                filter.setValue(5.0, forKey: kCIInputIntensityKey)
                outputImage = filter.outputImage ?? baseImage
            } else {
                outputImage = baseImage
            }
        }

        guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

// MARK: - SwiftUI Camera Preview Layer
public struct CameraPreviewRepresentable: UIViewRepresentable {
    public let session: AVCaptureSession

    public init(session: AVCaptureSession) {
        self.session = session
    }

    public func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.videoPreviewLayer?.session = session
        view.videoPreviewLayer?.videoGravity = .resizeAspectFill
        view.syncVideoOrientation()
        return view
    }

    public func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        uiView.videoPreviewLayer?.session = session
        uiView.syncVideoOrientation()
    }
}

public final class CameraPreviewUIView: UIView {
    override public class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    public var videoPreviewLayer: AVCaptureVideoPreviewLayer? {
        layer as? AVCaptureVideoPreviewLayer
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        syncVideoOrientation()
    }

    public func syncVideoOrientation() {
        let orientation = window?.windowScene?.interfaceOrientation ?? .portrait
        let angle: CGFloat = switch orientation {
        case .portrait: 90
        case .portraitUpsideDown: 270
        case .landscapeRight: 0
        case .landscapeLeft: 180
        case .unknown: 90
        @unknown default: 90
        }
        if let conn = videoPreviewLayer?.connection, conn.isVideoRotationAngleSupported(angle) {
            conn.videoRotationAngle = angle
        }
        MicroscopeCameraProbe.shared.updateVideoRotation(angle: angle)
    }
}
