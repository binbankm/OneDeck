//
//  MicroscopeCameraProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Macro optical camera magnifier and digital zoom probe.
//

import AVFoundation
import Foundation
import SwiftUI
import UIKit

@MainActor
public final class MicroscopeCameraProbe: NSObject {
    public static let shared = MicroscopeCameraProbe()

    public let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice?
    private var videoInput: AVCaptureDeviceInput?
    private var isSessionConfigured: Bool = false
    private(set) var isRunning: Bool = false

    override private init() {
        super.init()
    }

    public func configureSession() {
        guard !isSessionConfigured else { return }

        captureSession.beginConfiguration()
        captureSession.sessionPreset = .hd1920x1080

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            captureSession.commitConfiguration()
            return
        }

        self.videoDevice = device

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                self.videoInput = input
            }
        } catch {
            print("MicroscopeCameraProbe: Failed to configure input: \(error)")
        }

        captureSession.commitConfiguration()
        isSessionConfigured = true
    }

    public func startSession() {
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        switch auth {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    Task { @MainActor in
                        MicroscopeCameraProbe.shared.startSession()
                    }
                }
            }
            return
        case .denied, .restricted:
            return
        case .authorized:
            break
        @unknown default:
            break
        }

        configureSession()
        guard !captureSession.isRunning else {
            isRunning = true
            return
        }

        let session = self.captureSession
        Task.detached(priority: .userInitiated) {
            session.startRunning()
            await MainActor.run {
                MicroscopeCameraProbe.shared.isRunning = true
            }
        }
    }

    public func stopSession() {
        guard captureSession.isRunning else {
            isRunning = false
            return
        }

        turnTorchOff()
        let session = self.captureSession
        Task.detached(priority: .background) {
            session.stopRunning()
            await MainActor.run {
                MicroscopeCameraProbe.shared.isRunning = false
            }
        }
    }

    public func setZoomFactor(_ factor: CGFloat) {
        guard let device = videoDevice else { return }
        do {
            try device.lockForConfiguration()
            let maxZoom = min(15.0, device.activeFormat.videoMaxZoomFactor)
            let clamped = max(1.0, min(maxZoom, factor))
            device.videoZoomFactor = clamped
            device.unlockForConfiguration()
        } catch {
            print("MicroscopeCameraProbe zoom error: \(error)")
        }
    }

    public func setTorchMode(isOn: Bool) {
        guard let device = videoDevice, device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            if isOn {
                try device.setTorchModeOn(level: 1.0)
            } else {
                device.torchMode = .off
            }
            device.unlockForConfiguration()
        } catch {
            print("MicroscopeCameraProbe torch error: \(error)")
        }
    }

    public func turnTorchOff() {
        guard let device = videoDevice, device.hasTorch, device.isTorchActive else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = .off
            device.unlockForConfiguration()
        } catch {
            // Ignore on teardown
        }
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
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    public func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        uiView.videoPreviewLayer.session = session
    }
}

public final class CameraPreviewUIView: UIView {
    override public class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    public var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        (layer as? AVCaptureVideoPreviewLayer) ?? AVCaptureVideoPreviewLayer()
    }
}
