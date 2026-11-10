//
//  SeismicVibrationProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Tri-axial accelerometer seismometer and vibration spectrum probe.
//

import CoreMotion
import Foundation
import os

public final class SeismicVibrationProbe: @unchecked Sendable {
    public static let shared = SeismicVibrationProbe()

    private struct SeismicState: Sendable {
        var isRecording: Bool = false
        var lastSignX: Int = 0
        var lastSignY: Int = 0
        var lastSignZ: Int = 0
        var zeroCrossingsX: Int = 0
        var zeroCrossingsY: Int = 0
        var zeroCrossingsZ: Int = 0
        var peakAxisAmpX: Double = 0.0
        var peakAxisAmpY: Double = 0.0
        var peakAxisAmpZ: Double = 0.0
        var windowStartTime: CFAbsoluteTime = 0
        var dominantFreqHz: Double = 0.0
        var currentPeakGal: Double = 0.0
        var gravityX: Double = 0.0
        var gravityY: Double = 0.0
        var gravityZ: Double = -1.0
        var onUpdate: (@MainActor @Sendable (_ data: SeismometerData) -> Void)?
        var onStatus: (@MainActor @Sendable (_ isAvailable: Bool) -> Void)?
    }

    private let stateLock = OSAllocatedUnfairLock(initialState: SeismicState())
    private let motionManager = CMMotionManager()
    private let motionQueue = OperationQueue()

    public var isHardwareAvailable: Bool {
        motionManager.isDeviceMotionAvailable || motionManager.isAccelerometerAvailable
    }

    private init() {
        motionQueue.name = "com.onedeck.seismic.queue"
        motionQueue.maxConcurrentOperationCount = 1
        motionQueue.qualityOfService = .userInteractive
    }

    // MARK: - Public Controls
    @MainActor
    public func startSeismicMonitoring(
        interval: TimeInterval = 1.0 / 60.0,
        isPowerSaving: Bool = false,
        onStatus: (@MainActor @Sendable (_ isAvailable: Bool) -> Void)? = nil,
        onUpdate: @escaping @MainActor @Sendable (SeismometerData) -> Void
    ) {
        let now = CFAbsoluteTimeGetCurrent()
        let shouldStart = stateLock.withLock { state -> Bool in
            state.onUpdate = onUpdate
            state.onStatus = onStatus
            if state.isRecording { return false }
            state.isRecording = true
            state.currentPeakGal = 0.0
            state.zeroCrossingsX = 0
            state.zeroCrossingsY = 0
            state.zeroCrossingsZ = 0
            state.peakAxisAmpX = 0.0
            state.peakAxisAmpY = 0.0
            state.peakAxisAmpZ = 0.0
            state.lastSignX = 0
            state.lastSignY = 0
            state.lastSignZ = 0
            state.windowStartTime = now
            state.dominantFreqHz = 0.0
            state.gravityX = 0.0
            state.gravityY = 0.0
            state.gravityZ = -1.0
            return true
        }
        guard shouldStart else {
            onStatus?(isHardwareAvailable)
            return
        }

        guard isHardwareAvailable else {
            stateLock.withLock { $0.isRecording = false }
            onStatus?(false)
            return
        }

        onStatus?(true)
        let effectiveInterval = isPowerSaving ? max(interval, 1.0 / 30.0) : interval

        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = effectiveInterval
            motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: motionQueue) { [weak self] motion, error in
                guard let self, let motion, error == nil else { return }
                let userAcc = motion.userAcceleration
                self.processAccelerationSample(ux: userAcc.x, uy: userAcc.y, uz: userAcc.z)
            }
        } else if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = effectiveInterval
            motionManager.startAccelerometerUpdates(to: motionQueue) { [weak self] data, error in
                guard let self, let data, error == nil else { return }
                let (ux, uy, uz) = self.stateLock.withLock { state -> (Double, Double, Double) in
                    let alpha = 0.9
                    state.gravityX = alpha * state.gravityX + (1.0 - alpha) * data.acceleration.x
                    state.gravityY = alpha * state.gravityY + (1.0 - alpha) * data.acceleration.y
                    state.gravityZ = alpha * state.gravityZ + (1.0 - alpha) * data.acceleration.z
                    return (
                        data.acceleration.x - state.gravityX,
                        data.acceleration.y - state.gravityY,
                        data.acceleration.z - state.gravityZ
                    )
                }
                self.processAccelerationSample(ux: ux, uy: uy, uz: uz)
            }
        }
    }

    @MainActor
    public func setPowerSaving(_ isPowerSaving: Bool, baseInterval: TimeInterval = 1.0 / 60.0) {
        let isRecording = stateLock.withLock { $0.isRecording }
        guard isRecording else { return }
        let effectiveInterval = isPowerSaving ? max(baseInterval, 1.0 / 30.0) : baseInterval
        if motionManager.isDeviceMotionActive {
            motionManager.deviceMotionUpdateInterval = effectiveInterval
        }
        if motionManager.isAccelerometerActive {
            motionManager.accelerometerUpdateInterval = effectiveInterval
        }
    }

    @MainActor
    public func stopSeismicMonitoring() {
        let wasRecording = stateLock.withLock { state -> Bool in
            let prev = state.isRecording
            state.isRecording = false
            state.onUpdate = nil
            state.onStatus = nil
            return prev
        }
        guard wasRecording else { return }

        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }

    public nonisolated func resetPeak() {
        stateLock.withLock { state in
            state.currentPeakGal = 0.0
        }
    }

    private nonisolated func processAccelerationSample(ux: Double, uy: Double, uz: Double) {
        // 1 G = 980.665 Gal (cm/s^2)
        let galX = ux * 980.665
        let galY = uy * 980.665
        let galZ = uz * 980.665
        let magnitudeGal = sqrt(galX * galX + galY * galY + galZ * galZ)
        let now = CFAbsoluteTimeGetCurrent()

        let payload: (SeismometerData, @MainActor @Sendable (SeismometerData) -> Void)? = stateLock.withLock { state in
            guard state.isRecording, let callback = state.onUpdate else { return nil }

            // True running peak hold until explicit resetPeak()
            if magnitudeGal > state.currentPeakGal {
                state.currentPeakGal = magnitudeGal
            }

            // Track dominant tri-axial zero-crossings with ~0.0005g hysteresis deadband
            let threshold = 0.0005
            state.peakAxisAmpX = max(state.peakAxisAmpX, abs(ux))
            state.peakAxisAmpY = max(state.peakAxisAmpY, abs(uy))
            state.peakAxisAmpZ = max(state.peakAxisAmpZ, abs(uz))

            if ux > threshold {
                if state.lastSignX == -1 { state.zeroCrossingsX += 1 }
                state.lastSignX = 1
            } else if ux < -threshold {
                if state.lastSignX == 1 { state.zeroCrossingsX += 1 }
                state.lastSignX = -1
            }

            if uy > threshold {
                if state.lastSignY == -1 { state.zeroCrossingsY += 1 }
                state.lastSignY = 1
            } else if uy < -threshold {
                if state.lastSignY == 1 { state.zeroCrossingsY += 1 }
                state.lastSignY = -1
            }

            if uz > threshold {
                if state.lastSignZ == -1 { state.zeroCrossingsZ += 1 }
                state.lastSignZ = 1
            } else if uz < -threshold {
                if state.lastSignZ == 1 { state.zeroCrossingsZ += 1 }
                state.lastSignZ = -1
            }

            let elapsedSec = now - state.windowStartTime
            if elapsedSec >= 0.5 {
                let dominantCrossings: Int
                if state.peakAxisAmpX >= state.peakAxisAmpY && state.peakAxisAmpX >= state.peakAxisAmpZ {
                    dominantCrossings = state.zeroCrossingsX
                } else if state.peakAxisAmpY >= state.peakAxisAmpZ {
                    dominantCrossings = state.zeroCrossingsY
                } else {
                    dominantCrossings = state.zeroCrossingsZ
                }

                if dominantCrossings > 0 {
                    state.dominantFreqHz = (Double(dominantCrossings) / 2.0) / elapsedSec
                } else {
                    state.dominantFreqHz = 0.0
                }
                state.windowStartTime = now
                state.zeroCrossingsX = 0
                state.zeroCrossingsY = 0
                state.zeroCrossingsZ = 0
                state.peakAxisAmpX = 0.0
                state.peakAxisAmpY = 0.0
                state.peakAxisAmpZ = 0.0
            }

            let intensity: SeismicIntensity = if state.currentPeakGal < 1.0 {
                .instrumental
            } else if state.currentPeakGal < 5.0 {
                .weak
            } else if state.currentPeakGal < 25.0 {
                .moderate
            } else {
                .strong
            }

            let data = SeismometerData(
                accelX: galX,
                accelY: galY,
                accelZ: galZ,
                vectorMagnitudeGal: magnitudeGal,
                peakGal: state.currentPeakGal,
                dominantFrequencyHz: state.dominantFreqHz,
                intensity: intensity,
                isRecording: true
            )
            return (data, callback)
        }

        if let (result, callback) = payload {
            Task { @MainActor [weak self] in
                guard let self, self.stateLock.withLock({ $0.isRecording }) else { return }
                callback(result)
            }
        }
    }
}
