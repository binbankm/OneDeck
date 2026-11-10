//
//  TorchHardwareProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Hardware torch control probe with micro-brightness and strobe timer.
//

import AVFoundation
import Foundation

@MainActor
public final class TorchHardwareProbe {
    public static let shared = TorchHardwareProbe()

    private var device: AVCaptureDevice? {
        AVCaptureDevice.default(for: .video)
    }

    private var strobeTask: Task<Void, Never>?
    private var morseTask: Task<Void, Never>?
    private var activeSessionID: UInt64 = 0

    private(set) var isHardwareTorchAvailable: Bool = false

    private init() {
        self.isHardwareTorchAvailable = device?.hasTorch ?? false
    }

    // MARK: - 1. Continuous Linear Micro-Brightness
    public func setTorch(level: Float) {
        stopSpecialModes()
        activeSessionID &+= 1
        guard let device, device.hasTorch else { return }

        let clamped = max(0.0, min(1.0, level))

        do {
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            if clamped <= 0.001 {
                device.torchMode = .off
            } else {
                try device.setTorchModeOn(level: clamped)
            }
        } catch {
            // Torch configuration lock error ignored
        }
    }

    public func turnOff() {
        stopSpecialModes()
        activeSessionID &+= 1
        guard let device, device.hasTorch else { return }

        do {
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            device.torchMode = .off
        } catch {
            // Ignored
        }
    }

    // MARK: - 2. High-Frequency Strobe Tachometer
    public func startStrobe(frequencyHz: Double) {
        stopSpecialModes()
        activeSessionID &+= 1
        let sessionID = activeSessionID
        guard let device, device.hasTorch else { return }

        let clampedHz = max(0.5, min(30.0, frequencyHz))
        let halfPeriodMs = UInt64((1000.0 / clampedHz) / 2.0)
        let halfPeriodNanos = halfPeriodMs * 1_000_000

        strobeTask = Task { [weak self] in
            while !Task.isCancelled {
                do {
                    try device.lockForConfiguration()
                    defer { device.unlockForConfiguration() }
                    try device.setTorchModeOn(level: 1.0)
                } catch { break }

                try? await Task.sleep(nanoseconds: halfPeriodNanos)
                if Task.isCancelled { break }

                do {
                    try device.lockForConfiguration()
                    defer { device.unlockForConfiguration() }
                    device.torchMode = .off
                } catch { break }

                try? await Task.sleep(nanoseconds: halfPeriodNanos)
            }

            if let self, self.activeSessionID == sessionID {
                do {
                    try device.lockForConfiguration()
                    defer { device.unlockForConfiguration() }
                    device.torchMode = .off
                } catch {}
            }
        }
    }

    // MARK: - 3. SOS & Morse Code Flasher
    public func startMorseCode(text: String, completion: (@Sendable () -> Void)? = nil) {
        stopSpecialModes()
        activeSessionID &+= 1
        let sessionID = activeSessionID
        guard let device, device.hasTorch else {
            completion?()
            return
        }

        let morsePattern = Self.convertToMorse(text)
        guard !morsePattern.isEmpty else {
            completion?()
            return
        }

        let dotDurationNanos: UInt64 = 180_000_000 // 180ms per dot
        let dashDurationNanos: UInt64 = dotDurationNanos * 3
        let elementGapNanos: UInt64 = dotDurationNanos
        let letterGapNanos: UInt64 = dotDurationNanos * 3
        let wordGapNanos: UInt64 = dotDurationNanos * 7

        morseTask = Task { [weak self] in
            while !Task.isCancelled {
                for char in morsePattern {
                    if Task.isCancelled { break }

                    if char == "." {
                        try? await self?.flashTorch(device: device, nanos: dotDurationNanos)
                        try? await Task.sleep(nanoseconds: elementGapNanos)
                    } else if char == "-" {
                        try? await self?.flashTorch(device: device, nanos: dashDurationNanos)
                        try? await Task.sleep(nanoseconds: elementGapNanos)
                    } else if char == " " {
                        try? await Task.sleep(nanoseconds: letterGapNanos)
                    } else if char == "/" {
                        try? await Task.sleep(nanoseconds: wordGapNanos)
                    }
                }
                if Task.isCancelled { break }
                // Pause between loops
                try? await Task.sleep(nanoseconds: wordGapNanos)
            }

            if let self, self.activeSessionID == sessionID {
                do {
                    try device.lockForConfiguration()
                    defer { device.unlockForConfiguration() }
                    device.torchMode = .off
                } catch {}
            }
            completion?()
        }
    }

    private func flashTorch(device: AVCaptureDevice, nanos: UInt64) async throws {
        do {
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            try device.setTorchModeOn(level: 1.0)
        } catch { return }

        defer {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.torchMode = .off
            } catch {}
        }

        try await Task.sleep(nanoseconds: nanos)
    }

    public func stopSpecialModes() {
        activeSessionID &+= 1
        strobeTask?.cancel()
        strobeTask = nil
        morseTask?.cancel()
        morseTask = nil
        guard let device, device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            device.torchMode = .off
        } catch {}
    }

    // MARK: - Morse Code Converter
    internal nonisolated static func convertToMorse(_ text: String) -> String {
        let morseDict: [Character: String] = [
            "A": ".-", "B": "-...", "C": "-.-.", "D": "-..", "E": ".",
            "F": "..-.", "G": "--.", "H": "....", "I": "..", "J": ".---",
            "K": "-.-", "L": ".-..", "M": "--", "N": "-.", "O": "---",
            "P": ".--.", "Q": "--.-", "R": ".-.", "S": "...", "T": "-",
            "U": "..-", "V": "...-", "W": ".--", "X": "-..-", "Y": "-.--",
            "Z": "--..", "1": ".----", "2": "..---", "3": "...--", "4": "....-",
            "5": ".....", "6": "-....", "7": "--...", "8": "---..", "9": "----.",
            "0": "-----", " ": "/"
        ]

        return text.uppercased().compactMap { morseDict[$0] }.joined(separator: " ")
    }
}
