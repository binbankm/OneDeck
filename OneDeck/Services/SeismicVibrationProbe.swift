//
//  SeismicVibrationProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Tri-Axial High-Precision Seismometer & Micro-Vibration Spectrum Hardware Probe.
//

import Foundation
import CoreMotion

public final class SeismicVibrationProbe: @unchecked Sendable {
    public static let shared = SeismicVibrationProbe()

    private let motionManager = CMMotionManager()
    private let motionQueue = OperationQueue()
    private var isRecording: Bool = false

    // High-Pass Filter Memory (Gravity DC Isolation)
    private var lastRawX: Double = 0.0
    private var lastRawY: Double = 0.0
    private var lastRawZ: Double = 0.0
    private var filteredX: Double = 0.0
    private var filteredY: Double = 0.0
    private var filteredZ: Double = 0.0

    // Peak & Frequency Tracking
    private var rollingZeroCrossings: Int = 0
    private var sampleCountWindow: Int = 0
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
        self.sampleCountWindow = 0
        self.rollingZeroCrossings = 0

        guard motionManager.isAccelerometerAvailable else {
            #if targetEnvironment(simulator)
            startSimulatorSeismicLoop()
            #endif
            return
        }

        motionManager.accelerometerUpdateInterval = interval
        motionManager.startAccelerometerUpdates(to: motionQueue) { [weak self] data, error in
            guard let self = self, let data = data, error == nil, self.isRecording else { return }

            let rawX = data.acceleration.x
            let rawY = data.acceleration.y
            let rawZ = data.acceleration.z

            // 1st-order IIR High-pass filter (cutoff ~0.5Hz at 60Hz rate)
            let alpha = 0.92
            self.filteredX = alpha * (self.filteredX + rawX - self.lastRawX)
            self.filteredY = alpha * (self.filteredY + rawY - self.lastRawY)
            self.filteredZ = alpha * (self.filteredZ + rawZ - self.lastRawZ)

            self.lastRawX = rawX
            self.lastRawY = rawY
            self.lastRawZ = rawZ

            // 1G = 9.80665 m/s² = 980.665 Gal
            let galX = self.filteredX * 980.665
            let galY = self.filteredY * 980.665
            let galZ = self.filteredZ * 980.665
            let magnitudeGal = sqrt(galX * galX + galY * galY + galZ * galZ)

            if magnitudeGal > self.currentPeakGal {
                self.currentPeakGal = magnitudeGal
            } else {
                self.currentPeakGal = max(magnitudeGal, self.currentPeakGal * 0.992) // Smooth peak decay
            }

            // Estimate dominant vibration frequency via zero crossings
            self.sampleCountWindow += 1
            if (self.filteredZ > 0 && self.lastRawZ <= 0) || (self.filteredZ < 0 && self.lastRawZ >= 0) {
                self.rollingZeroCrossings += 1
            }

            var dominantFreq = 0.0
            if self.sampleCountWindow >= 60 {
                // 60 samples ~ 1 second: freq = crossings / 2
                dominantFreq = max(0.5, Double(self.rollingZeroCrossings) / 2.0)
                self.sampleCountWindow = 0
                self.rollingZeroCrossings = 0
            }

            // Seismic Intensity mapping (PGA based)
            let intensity: SeismicIntensity
            if self.currentPeakGal < 1.0 {
                intensity = .instrumental
            } else if self.currentPeakGal < 5.0 {
                intensity = .weak
            } else if self.currentPeakGal < 25.0 {
                intensity = .moderate
            } else {
                intensity = .strong
            }

            let result = SeismometerData(
                accelX: galX,
                accelY: galY,
                accelZ: galZ,
                vectorMagnitudeGal: magnitudeGal,
                peakGal: self.currentPeakGal,
                dominantFrequencyHz: dominantFreq,
                intensity: intensity,
                isRecording: true
            )

            Task { @MainActor [weak self] in
                guard let self = self, self.isRecording else { return }
                self.onUpdate?(result)
            }
        }
    }

    public func stopSeismicMonitoring() {
        guard isRecording else { return }
        isRecording = false
        motionManager.stopAccelerometerUpdates()
        onUpdate = nil
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

        var step: Double = 0.0
        timer.setEventHandler { [weak self] in
            guard let self = self, self.isRecording else { return }
            step += 0.2
            let x = sin(step * 0.7) * 2.5
            let y = cos(step * 1.1) * 3.1
            let z = sin(step * 1.5) * 4.2
            let mag = sqrt(x*x + y*y + z*z)
            self.currentPeakGal = max(mag, self.currentPeakGal * 0.99)

            let result = SeismometerData(
                accelX: x,
                accelY: y,
                accelZ: z,
                vectorMagnitudeGal: mag,
                peakGal: self.currentPeakGal,
                dominantFrequencyHz: 14.5,
                intensity: mag > 5.0 ? .moderate : (mag > 1.0 ? .weak : .instrumental),
                isRecording: true
            )

            Task { @MainActor [weak self] in
                guard let self = self, self.isRecording else { return }
                self.onUpdate?(result)
            }
        }
        timer.resume()
        self.simTimer = timer
    }
    #endif
}

