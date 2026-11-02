//
//  ToolsViewModel.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Central state management engine for Hardware Diagnostic & Precision Instruments Toolkit.
//

import SwiftUI
import Observation

public typealias ToolsService = ToolsViewModel

@Observable
@MainActor
public final class ToolsViewModel: Sendable {
    public static let shared = ToolsViewModel()

    // MARK: - 1. Spirit Level State
    public var spiritLevel = SpiritLevelData()
    private var wasLevelInLastTick: Bool = false

    // MARK: - 2. Native Screen Caliper State
    public var caliperUnit: ScreenCaliperUnit = .mm
    public var caliperMode: CaliperMode = .outside
    public var caliperRecords: [CaliperRecord] = []
    public var caliperCurrentMm: Double = 25.4
    public var caliperTareOffsetMm: Double = 0.0

    // MARK: - 3. Sonic Water Ejector State
    public var waterEjector = WaterEjectorState()
    private var waterTask: Task<Void, Never>?

    // MARK: - 4. Precision Torch & Strobe State
    public var torch = TorchState()

    // MARK: - 5. Magnetic Field & Metal Detector State
    public var metalDetector = MetalDetectorData()
    private var lastGeigerSoundTime: Date = Date()

    // MARK: - 6. Atmospheric Barometer & Altimeter State
    public var barometer = BarometerData()
    private var baselinePressureHpa: Double?

    // MARK: - 7. Audio Tone Generator State
    public var toneGenerator = ToneGeneratorData()

    // MARK: - 8. Screen Quality & Touch Matrix State
    public var screenQualityColor: ScreenQualityColor = .black
    public var touchPoints: [TouchPointItem] = []
    public var touchSamplingRateHz: Int = 120
    public var touchMaxPressure: CGFloat = 1.0
    public var isProximityNear: Bool = false

    // MARK: - 9. Decibel Sound Meter State
    public var decibelMeter = DecibelMeterData()
    public var isDecibelActive: Bool = false

    // MARK: - 10. 3D Electronic Compass State
    public var compass = CompassData()
    public var isCompassActive: Bool = false

    // MARK: - 11. Stereo Speaker Diagnostics State
    public var speakerChannel: SpeakerChannel = .stereo

    // MARK: - 12. Fullscreen Touch Matrix State
    public var touchMatrixCells: [Bool] = Array(repeating: false, count: 80)
    public var touchMatrixPassedCount: Int {
        touchMatrixCells.filter { $0 }.count
    }

    // MARK: - Lifecycle Tracking
    public var isToolsTabActive: Bool = false
    public var activeDetailCount: Int = 0
    public var isMotionActive: Bool = false
    public var isMagnetometerActive: Bool = false
    public var isBarometerActive: Bool = false

    public var isToolsModuleActive: Bool {
        isToolsTabActive || activeDetailCount > 0
    }

    // Probes
    private let motionProbe = MotionHardwareProbe.shared
    private let audioProbe = AudioAcousticProbe.shared
    private let torchProbe = TorchHardwareProbe.shared

    private init() {
        loadSavedCaliperRecords()
    }

    // MARK: - Lifecycle Management (Smart Battery-Saving Guard)
    public func onTabAppear() {
        isToolsTabActive = true
        startTabTelemetrySensors()
    }

    public func startTabTelemetrySensors() {
        // Run preview sensors at battery-optimized rates (12Hz / 10Hz, zero GPS)
        startMotionSensors(interval: 1.0 / 12.0)
        startCompass(enableGpsLocation: false)
        startBarometer()
        startMagnetometer(interval: 1.0 / 10.0)
    }

    public func onTabDisappear() {
        guard activeDetailCount == 0 else { return }
        isToolsTabActive = false
        stopAllSensors()
        stopWaterEjection()
        stopToneGenerator()
        torchProbe.turnOff()
        torch.isTorchOn = false
    }

    public func onAppBackground() {
        isToolsTabActive = false
        stopAllSensors()
        stopWaterEjection()
        stopToneGenerator()
        stopDecibelMeter()
        torchProbe.turnOff()
        torch.isTorchOn = false
    }

    public func onAppForeground() {
        if isToolsTabActive {
            startTabTelemetrySensors()
        }
    }

    public func enterDetailView() {
        activeDetailCount += 1
    }

    public func leaveDetailView() {
        activeDetailCount = max(0, activeDetailCount - 1)
        if activeDetailCount == 0 && isToolsTabActive {
            // Restore power-saving preview rates
            motionProbe.setMotionInterval(1.0 / 12.0)
            motionProbe.setMagnetometerInterval(1.0 / 10.0)
            motionProbe.setCompassGpsActive(false)
        }
    }

    // MARK: - 1. Spirit Level Actions
    public func startMotionSensors(interval: TimeInterval = 1.0 / 60.0) {
        guard !isMotionActive else {
            motionProbe.setMotionInterval(interval)
            return
        }
        isMotionActive = true

        motionProbe.startMotionUpdates(interval: interval) { [weak self] data in
            guard let self = self, self.isToolsModuleActive else { return }

            if !self.spiritLevel.isLocked {
                self.spiritLevel.rollDegrees = data.rollDegrees
                self.spiritLevel.pitchDegrees = data.pitchDegrees
                self.spiritLevel.tiltDegrees = data.tiltDegrees
                self.spiritLevel.isLevel = data.isLevel
                self.spiritLevel.orientation = data.orientation
                self.spiritLevel.slopePercent = data.slopePercent

                // Haptic & Sound Snap on 0.0° Level Lock
                if data.isLevel && !self.wasLevelInLastTick {
                    Haptics.impact(.medium)
                    if self.spiritLevel.isBeepEnabled {
                        self.audioProbe.playLevelLockSound()
                    }
                }
                self.wasLevelInLastTick = data.isLevel
            }
        }
    }

    public func stopMotionSensors() {
        motionProbe.stopMotionUpdates()
        isMotionActive = false
    }

    public func toggleLevelLock() {
        Haptics.selection()
        spiritLevel.isLocked.toggle()
    }

    public func toggleLevelBeep() {
        Haptics.selection()
        spiritLevel.isBeepEnabled.toggle()
    }

    // MARK: - 2. Screen Caliper Actions
    public func setCaliperMm(_ mm: Double) {
        caliperCurrentMm = max(0.0, mm)
    }

    public func tareCaliper() {
        Haptics.tick()
        caliperTareOffsetMm = caliperCurrentMm
    }

    public func resetTare() {
        Haptics.tick()
        caliperTareOffsetMm = 0.0
    }

    public func saveCurrentCaliperMeasurement() {
        Haptics.success()
        let val = max(0.0, caliperCurrentMm - caliperTareOffsetMm)
        let record = CaliperRecord(
            valueMm: val,
            unit: caliperUnit.title,
            timestamp: Date(),
            note: String(format: "%.1f %@", val, caliperUnit.title)
        )
        caliperRecords.insert(record, at: 0)
        if caliperRecords.count > 20 {
            caliperRecords = Array(caliperRecords.prefix(20))
        }
        persistCaliperRecords()
    }

    public func deleteCaliperRecord(at offsets: IndexSet) {
        caliperRecords.remove(atOffsets: offsets)
        persistCaliperRecords()
    }

    private func persistCaliperRecords() {
        if let data = try? JSONEncoder().encode(caliperRecords) {
            UserDefaults.standard.set(data, forKey: "onedeck_caliper_records")
        }
    }

    private func loadSavedCaliperRecords() {
        if let data = UserDefaults.standard.data(forKey: "onedeck_caliper_records"),
           let recs = try? JSONDecoder().decode([CaliperRecord].self, from: data) {
            self.caliperRecords = recs
        }
    }

    // MARK: - 3. Sonic Water Ejector Actions
    public func toggleWaterEjector() {
        if waterEjector.isRunning {
            stopWaterEjection()
        } else {
            startWaterEjection()
        }
    }

    public func startWaterEjection() {
        Haptics.impact(.heavy)
        waterEjector.isRunning = true
        waterEjector.progress = 0.0
        waterEjector.remainingSeconds = 12

        // Start 165Hz pure tone
        audioProbe.startTone(frequency: waterEjector.selectedMode.targetFrequency, waveform: .sine, volume: 1.0)

        waterTask?.cancel()
        let totalTicks = 120 // 12 seconds in 0.1s increments

        waterTask = Task { @MainActor [weak self] in
            for currentTick in 1...totalTicks {
                try? await Task.sleep(nanoseconds: 100_000_000)
                guard let self = self, !Task.isCancelled else { break }

                self.waterEjector.progress = Double(currentTick) / Double(totalTicks)
                self.waterEjector.remainingSeconds = max(0, 12 - (currentTick / 10))

                // Periodic heavy haptic bursts
                if currentTick % 10 == 0 {
                    Haptics.impact(.heavy)
                }

                if currentTick >= totalTicks {
                    self.stopWaterEjection()
                    Haptics.success()
                }
            }
        }
    }

    public func stopWaterEjection() {
        waterTask?.cancel()
        waterTask = nil
        waterEjector.isRunning = false
        waterEjector.progress = 0.0
        audioProbe.stopTone()
    }

    // MARK: - 4. Precision Torch & Strobe Actions
    public func toggleTorch() {
        Haptics.impact(.medium)
        torch.isTorchOn.toggle()
        if torch.isTorchOn {
            applyCurrentTorchMode()
        } else {
            torchProbe.turnOff()
        }
    }

    public func setTorchBrightness(_ level: Float) {
        torch.brightness = max(0.01, min(1.0, level))
        if torch.isTorchOn && torch.currentMode == .continuous {
            torchProbe.setTorch(level: torch.brightness)
        }
    }

    public func setTorchMode(_ mode: TorchWorkMode) {
        Haptics.selection()
        torch.currentMode = mode
        if torch.isTorchOn {
            applyCurrentTorchMode()
        }
    }

    public func setStrobeFrequency(_ hz: Double) {
        torch.strobeFrequencyHz = max(0.5, min(30.0, hz))
        if torch.isTorchOn && torch.currentMode == .strobe {
            torchProbe.startStrobe(frequencyHz: torch.strobeFrequencyHz)
        }
    }

    private func applyCurrentTorchMode() {
        switch torch.currentMode {
        case .continuous:
            torchProbe.setTorch(level: torch.brightness)
        case .strobe:
            torchProbe.startStrobe(frequencyHz: torch.strobeFrequencyHz)
        case .sos:
            torchProbe.startMorseCode(text: "SOS")
        case .softbox:
            torchProbe.turnOff() // Screen takes over illumination
        }
    }

    // MARK: - 5. Magnetic Field & Metal Detector Actions
    public func startMagnetometer(interval: TimeInterval = 1.0 / 30.0) {
        guard !isMagnetometerActive else {
            motionProbe.setMagnetometerInterval(interval)
            return
        }
        isMagnetometerActive = true

        motionProbe.startMagnetometerUpdates(interval: interval) { [weak self] x, y, z, total in
            guard let self = self, self.isToolsModuleActive else { return }

            self.metalDetector.xMicroTesla = x
            self.metalDetector.yMicroTesla = y
            self.metalDetector.zMicroTesla = z
            self.metalDetector.totalMicroTesla = total

            let delta = max(0.0, total - self.metalDetector.baselineMicroTesla)
            self.metalDetector.deltaMicroTesla = delta

            // Normalized signal (0.0 to 1.0 based on 0 ~ 150 uT delta range)
            let norm = min(1.0, delta / 120.0)
            self.metalDetector.normalizedSignal = norm

            // Append rolling history
            let point = MetricPoint(timestamp: Date(), value: total)
            self.metalDetector.history.append(point)
            if self.metalDetector.history.count > 40 {
                self.metalDetector.history.removeFirst()
            }

            // Geiger audio tick when anomaly is detected
            if self.metalDetector.isGeigerAudioActive && delta > 12.0 {
                let now = Date()
                let interval = max(0.08, 0.6 - (norm * 0.52))
                if now.timeIntervalSince(self.lastGeigerSoundTime) >= interval {
                    self.audioProbe.playGeigerClick()
                    Haptics.tick()
                    self.lastGeigerSoundTime = now
                }
            }
        }
    }

    public func stopMagnetometer() {
        motionProbe.stopMagnetometerUpdates()
        isMagnetometerActive = false
    }

    public func calibrateMetalDetectorBaseline() {
        Haptics.impact(.medium)
        metalDetector.baselineMicroTesla = metalDetector.totalMicroTesla
        metalDetector.deltaMicroTesla = 0.0
        metalDetector.normalizedSignal = 0.0
    }

    public func toggleGeigerAudio() {
        Haptics.selection()
        metalDetector.isGeigerAudioActive.toggle()
    }

    // MARK: - 6. Barometer & Altimeter Actions
    public func startBarometer() {
        guard !isBarometerActive else { return }
        isBarometerActive = true

        if barometer.history.isEmpty {
            let now = Date()
            barometer.history = [
                MetricPoint(timestamp: now.addingTimeInterval(-2.0), value: barometer.pressureHpa),
                MetricPoint(timestamp: now, value: barometer.pressureHpa)
            ]
        }

        motionProbe.startAltimeterUpdates { [weak self] pressureHpa, altitudeM, speedMps, trend in
            guard let self = self, self.isToolsModuleActive else { return }

            self.barometer.pressureHpa = pressureHpa
            self.barometer.relativeAltitudeMeters = altitudeM
            self.barometer.verticalSpeedMps = speedMps
            self.barometer.trend = trend

            // Append pressure history
            let point = MetricPoint(timestamp: Date(), value: pressureHpa)
            self.barometer.history.append(point)
            if self.barometer.history.count > 40 {
                self.barometer.history.removeFirst()
            }
        }
    }

    public func stopBarometer() {
        motionProbe.stopAltimeterUpdates()
        isBarometerActive = false
    }

    public func resetBarometerAltitude() {
        Haptics.impact(.light)
        barometer.relativeAltitudeMeters = 0.0
        barometer.verticalSpeedMps = 0.0
    }

    // MARK: - 7. Audio Tone Generator Actions
    public func toggleToneGenerator() {
        Haptics.selection()
        if toneGenerator.isPlaying {
            stopToneGenerator()
        } else {
            startToneGenerator()
        }
    }

    public func startToneGenerator() {
        toneGenerator.isPlaying = true
        audioProbe.startTone(frequency: toneGenerator.frequencyHz, waveform: toneGenerator.waveform, volume: toneGenerator.volume)
    }

    public func stopToneGenerator() {
        toneGenerator.isPlaying = false
        audioProbe.stopTone()
    }

    public func setToneFrequency(_ freq: Double) {
        toneGenerator.frequencyHz = max(20.0, min(20000.0, freq))
        if toneGenerator.isPlaying {
            audioProbe.updateFrequency(toneGenerator.frequencyHz)
        }
    }

    public func setToneWaveform(_ wave: ToneWaveform) {
        Haptics.selection()
        toneGenerator.waveform = wave
        if toneGenerator.isPlaying {
            audioProbe.startTone(frequency: toneGenerator.frequencyHz, waveform: wave, volume: toneGenerator.volume)
        }
    }

    // MARK: - Global Sensor Stop
    public func stopAllSensors() {
        stopMotionSensors()
        stopMagnetometer()
        stopBarometer()
        stopDecibelMeter()
        stopCompass()
        stopSpeakerTest()
    }

    // MARK: - 9. Decibel Sound Meter Actions
    public func startDecibelMeter() {
        guard !isDecibelActive else { return }
        isDecibelActive = true
        decibelMeter.isRecording = true
        decibelMeter.minDb = 120.0
        decibelMeter.peakDb = 0.0

        audioProbe.startDecibelMetering { [weak self] currentDb in
            guard let self = self, self.isToolsModuleActive else { return }
            self.decibelMeter.currentDb = currentDb
            if currentDb > self.decibelMeter.peakDb {
                self.decibelMeter.peakDb = currentDb
            }
            if currentDb < self.decibelMeter.minDb {
                self.decibelMeter.minDb = currentDb
            }
            let point = MetricPoint(timestamp: Date(), value: currentDb)
            self.decibelMeter.history.append(point)
            if self.decibelMeter.history.count > 30 {
                self.decibelMeter.history.removeFirst()
            }
            let sum = self.decibelMeter.history.reduce(0.0) { $0 + $1.value }
            self.decibelMeter.avgDb = sum / Double(max(1, self.decibelMeter.history.count))
        }
    }

    public func stopDecibelMeter() {
        audioProbe.stopDecibelMetering()
        isDecibelActive = false
        decibelMeter.isRecording = false
    }

    public func toggleDecibelMeter() {
        Haptics.selection()
        if isDecibelActive {
            stopDecibelMeter()
        } else {
            startDecibelMeter()
        }
    }

    // MARK: - 10. 3D Compass Actions
    public func startCompass(enableGpsLocation: Bool = false) {
        guard !isCompassActive else {
            motionProbe.setCompassGpsActive(enableGpsLocation)
            return
        }
        isCompassActive = true
        motionProbe.startCompassUpdates(enableGpsLocation: enableGpsLocation) { [weak self] data in
            guard let self = self, self.isToolsModuleActive else { return }
            self.compass = data
        }
    }

    public func stopCompass() {
        motionProbe.stopCompassUpdates()
        isCompassActive = false
    }

    // MARK: - 11. Stereo Speaker Diagnostics Actions
    public var isSpeakerTesting: Bool = false

    public func playSpeakerTest(channel: SpeakerChannel, frequency: Double = 1000.0) {
        Haptics.selection()
        speakerChannel = channel
        isSpeakerTesting = true
        audioProbe.playChannelTone(channel: channel, frequency: frequency)
    }

    public func stopSpeakerTest() {
        isSpeakerTesting = false
        audioProbe.stopTone()
    }

    // MARK: - 12. Touch Matrix Actions
    public func touchMatrixHit(at index: Int) {
        guard index >= 0 && index < touchMatrixCells.count else { return }
        if !touchMatrixCells[index] {
            touchMatrixCells[index] = true
            Haptics.tick()
        }
    }

    public func resetTouchMatrix() {
        Haptics.impact(.medium)
        touchMatrixCells = Array(repeating: false, count: 80)
    }

    // MARK: - 13. Proximity Sensor Actions
    public func startProximityMonitoring() {
        UIDevice.current.isProximityMonitoringEnabled = true
        isProximityNear = UIDevice.current.proximityState
    }

    public func stopProximityMonitoring() {
        UIDevice.current.isProximityMonitoringEnabled = false
    }

    public func updateProximityState() {
        isProximityNear = UIDevice.current.proximityState
    }
}

