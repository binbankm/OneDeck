//
//  SeismicVibrationProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Tri-axial accelerometer seismometer and vibration spectrum probe.
//

import CoreMotion
import Foundation

public final class SeismicVibrationProbe: @unchecked Sendable {
    public static let shared = SeismicVibrationProbe()

    @MainActor
    private var motionManager: CMMotionManager {
        MotionHardwareProbe.shared.motionManager
    }

    private let motionQueue = OperationQueue()
    private var isRecording: Bool = false

    // Peak & Frequency Tracking
    private var lastAccelZ: Double = 0.0
    private var zeroCrossingsCount: Int = 0
    private var sampleCount: Int = 0
    private var dominantFreqHz: Double = 0.0
    private var currentPeakGal: Double = 0.0

    private var onUpdate: ((_ data: SeismometerData) -> Void)?

    private init() {
        motionQueue.name = "com.onedeck.seismic.queue"
        motionQueue.maxConcurrentOperationCount = 1
        motionQueue.qualityOfService = .userInteractive
    }

    // MARK: - Public Controls
    public func startSeismicMonitoring(interval: TimeInterval = 1.0 / 60.0, onUpdate: @escaping (SeismometerData) -> Void) {
        guard !isRecording else { return }
        self.onUpdate = onUpdate
        self.isRecording = true
        self.currentPeakGal = 0.0
        self.sampleCount = 0
        self.zeroCrossingsCount = 0
        self.dominantFreqHz = 0.0
        self.lastAccelZ = 0.0

        Task { @MainActor [weak self] in
            guard let self, self.isRecording else { return }
            let manager = self.motionManager

            guard manager.isDeviceMotionAvailable else {
                #if targetEnvironment(simulator)
                self.startSimulatorSeismicLoop()
                #endif
                return
            }

            let effectiveInterval = AppState.shared.isSensorPowerSaving ? max(interval, 1.0 / 30.0) : interval
            manager.deviceMotionUpdateInterval = effectiveInterval
            manager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: self.motionQueue) { [weak self] motion, error in
                guard let self, let motion, error == nil, self.isRecording else { return }

                let userAcc = motion.userAcceleration
                // 1 G = 980.665 Gal (cm/s²)
                let galX = userAcc.x * 980.665
                let galY = userAcc.y * 980.665
                let galZ = userAcc.z * 980.665
                let magnitudeGal = sqrt(galX * galX + galY * galY + galZ * galZ)

                if magnitudeGal > self.currentPeakGal {
                    self.currentPeakGal = magnitudeGal
                } else {
                    // Smooth exponential peak decay (~0.8% decay per 60Hz frame)
                    self.currentPeakGal = max(magnitudeGal, self.currentPeakGal * 0.992)
                }

                // Estimate dominant vibration frequency via zero crossings of Z-axis user acceleration
                self.sampleCount += 1
                if (userAcc.z > 0 && self.lastAccelZ <= 0) || (userAcc.z < 0 && self.lastAccelZ >= 0) {
                    self.zeroCrossingsCount += 1
                }
                self.lastAccelZ = userAcc.z

                if self.sampleCount >= 30 {
                    // Dominant frequency calculation over 0.5s window
                    self.dominantFreqHz = max(0.5, Double(self.zeroCrossingsCount))
                    self.sampleCount = 0
                    self.zeroCrossingsCount = 0
                }

                // Seismic Intensity mapping (PGA based)
                let intensity: SeismicIntensity = if self.currentPeakGal < 1.0 {
                    .instrumental
                } else if self.currentPeakGal < 5.0 {
                    .weak
                } else if self.currentPeakGal < 25.0 {
                    .moderate
                } else {
                    .strong
                }

                let result = SeismometerData(
                    accelX: galX,
                    accelY: galY,
                    accelZ: galZ,
                    vectorMagnitudeGal: magnitudeGal,
                    peakGal: self.currentPeakGal,
                    dominantFrequencyHz: self.dominantFreqHz,
                    intensity: intensity,
                    isRecording: true
                )

                Task { @MainActor [weak self] in
                    guard let self, self.isRecording else { return }
                    self.onUpdate?(result)
                }
            }
        }
    }

    public func stopSeismicMonitoring() {
        guard isRecording else { return }
        isRecording = false
        onUpdate = nil

        Task { @MainActor [weak self] in
            self?.motionManager.stopDeviceMotionUpdates()
        }

        #if targetEnvironment(simulator)
        simTimer?.cancel()
        simTimer = nil
        #endif
    }

    public func resetPeak() {
        currentPeakGal = 0.0
    }

    #if targetEnvironment(simulator)
    private var simTimer: DispatchSourceTimer?

    private func startSimulatorSeismicLoop() {
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .userInteractive))
        timer.schedule(deadline: .now(), repeating: .milliseconds(16)) // 60Hz

        var step = 0.0
        timer.setEventHandler { [weak self] in
            guard let self, self.isRecording else { return }
            step += 0.2
            let x = sin(step * 0.7) * 2.5
            let y = cos(step * 1.1) * 3.1
            let z = sin(step * 1.5) * 4.2
            let mag = sqrt(x * x + y * y + z * z)
            self.currentPeakGal = max(mag, self.currentPeakGal * 0.99)

            let intensity: SeismicIntensity = if self.currentPeakGal < 1.0 {
                .instrumental
            } else if self.currentPeakGal < 5.0 {
                .weak
            } else if self.currentPeakGal < 25.0 {
                .moderate
            } else {
                .strong
            }

            let data = SeismometerData(
                accelX: x,
                accelY: y,
                accelZ: z,
                vectorMagnitudeGal: mag,
                peakGal: self.currentPeakGal,
                dominantFrequencyHz: 4.5,
                intensity: intensity,
                isRecording: true
            )

            Task { @MainActor [weak self] in
                guard let self, self.isRecording else { return }
                self.onUpdate?(data)
            }
        }
        timer.resume()
        self.simTimer = timer
    }
    #endif
}
