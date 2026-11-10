//
//  ToolsViewModel.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  State management view model for diagnostic instruments toolkit.
//

import AVFAudio
import AVFoundation
import CoreBluetooth
import CoreHaptics
import CoreLocation
import Foundation
import Observation
import SwiftUI
import UIKit

public typealias ToolsService = ToolsViewModel

public enum BleBannerStatus: Equatable, Sendable {
    case normal
    case unauthorized
    case poweredOff
    case unsupported
}

@Observable
@MainActor
public final class ToolsViewModel {
    public static let shared = ToolsViewModel()

    // MARK: - 1. Spirit Level State
    public var spiritLevel = SpiritLevelData()
    public var spiritLevelOrientationOverride: SpiritLevelOrientation?
    private var wasLevelInLastTick: Bool = false

    // MARK: - 2. Native Screen Caliper State
    public var caliperUnit: ScreenCaliperUnit = .mm
    public var caliperMode: CaliperMode = .outside
    public var caliperRecords: [CaliperRecord] = []
    public private(set) var caliperRawSpanMm: Double = 25.4
    public var caliperCurrentMm: Double {
        max(0.0, caliperRawSpanMm - caliperTareOffsetMm)
    }
    public var caliperTareOffsetMm: Double = 0.0

    // MARK: - 3. Sonic Water Ejector State
    public var waterEjector = WaterEjectorState()
    private var waterTask: Task<Void, Never>?

    // MARK: - 4. Precision Torch & Strobe State
    public var torch = TorchState()

    // MARK: - 5. Magnetic Field & Metal Detector State
    public var metalDetector = MetalDetectorData()
    private var lastGeigerSoundTime: Date = .init()

    // MARK: - 6. Atmospheric Barometer & Altimeter State
    public var barometer = BarometerData()
    public private(set) var barometerAltitudeTareMeters: Double = 0.0
    private var rawRelativeAltitudeMeters: Double = 0.0

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
    public var decibelStatus: DecibelMeterStatus = .active

    // MARK: - 10. 3D Electronic Compass State
    public var compass = CompassData()
    public var isCompassActive: Bool = false
    public var compassAuthStatus: CLAuthorizationStatus = MotionHardwareProbe.shared.compassAuthStatus
    private var isCompassGpsEnabled: Bool = false

    // MARK: - 11. Stereo Speaker Diagnostics State
    public var speakerChannel: SpeakerChannel = .stereo

    // MARK: - 12. Fullscreen Touch Matrix State
    public var touchMatrixCells: [Bool] = Array(repeating: false, count: 80)
    public var touchMatrixPassedCount: Int {
        touchMatrixCells.filter { $0 }.count
    }

    // MARK: - 13. Camera PPG Optical Pulse State
    public var pulseMeter = PulseMeterData()
    public var pulseStatus: OpticalSensorStatus = .active
    public private(set) var isPulseTorchOn: Bool = false

    // MARK: - 14. Seismometer & Vibration Spectrum State
    public var seismometer = SeismometerData()
    public var isSeismicHardwareAvailable: Bool = SeismicVibrationProbe.shared.isHardwareAvailable

    // MARK: - 15. Ambient Lux Meter State
    public var luxMeter = LuxMeterData()
    public var luxStatus: OpticalSensorStatus = .active

    // MARK: - 16. GNSS Hub & Coordinate Conversion State
    public var gnssHub = GnssHubData()
    public var gnssAuthStatus: CLAuthorizationStatus = GnssSatelliteProbe.shared.authorizationStatus

    // MARK: - 17. Bluetooth LE Radar State
    public var bleRadar = BleRadarData()

    // MARK: - 18. Industrial Microscope State
    public var microscope = MicroscopeData()
    public var microscopeStatus: OpticalSensorStatus = .active
    public var microscopeProcessedImage: UIImage?

    // Hardware Probes
    private let pulseProbe = PulseOpticalProbe.shared
    private let seismicProbe = SeismicVibrationProbe.shared
    private let luxProbe = AmbientLuxProbe.shared
    private let gnssProbe = GnssSatelliteProbe.shared
    private let bleProbe = BleScannerProbe.shared
    private let microscopeProbe = MicroscopeCameraProbe.shared

    // MARK: - Hardware Capability & Permission Helpers
    public var isMotionAvailable: Bool { motionProbe.isDeviceMotionAvailable }
    public var isMagnetometerAvailable: Bool { motionProbe.isMagnetometerAvailable }
    public var isBarometerAvailable: Bool { motionProbe.isAltimeterAvailable }
    public var isHeadingHardwareAvailable: Bool { motionProbe.isHeadingHardwareAvailable }
    public var isSpiritLevelCalibrated: Bool { motionProbe.isSpiritLevelCalibrated }
    public var isHapticHardwareAvailable: Bool { CHHapticEngine.capabilitiesForHardware().supportsHaptics }

    public var isCameraPermissionDenied: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return status == .denied || status == .restricted
    }

    public var isMicrophonePermissionDenied: Bool {
        AVAudioApplication.shared.recordPermission == .denied
    }

    public var isGnssLocationDenied: Bool {
        gnssAuthStatus == .denied || gnssAuthStatus == .restricted
    }

    public var isCompassLocationDenied: Bool {
        compassAuthStatus == .denied || compassAuthStatus == .restricted
    }

    public var bleBannerStatus: BleBannerStatus {
        switch bleRadar.bluetoothState {
        case .unauthorized:
            return .unauthorized
        case .poweredOff:
            return .poweredOff
        case .unsupported:
            return .unsupported
        default:
            return .normal
        }
    }

    public func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    @ViewBuilder
    public func makeMicroscopePreview() -> some View {
        CameraPreviewRepresentable(session: microscopeProbe.captureSession)
    }

    // MARK: - Lifecycle Tracking
    public var isToolsTabActive: Bool = false
    public var activeDetailCount: Int = 0
    public var currentActiveDetailTool: ActiveDetailTool = .none
    public var isSpiritLevelDetailActive: Bool = false
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
        self.barometer.isAvailable = motionProbe.isAltimeterAvailable
        loadSavedCaliperRecords()
    }

    // MARK: - Lifecycle Management (Smart Battery-Saving Guard)
    public func onTabAppear() {
        isToolsTabActive = true
        if activeDetailCount > 0 {
            resumeActiveDetailTool()
        }
    }

    public func onTabDisappear() {
        isToolsTabActive = false
        pauseActiveDetailTool()
        stopAllSensors()
        stopWaterEjection()
        stopToneGenerator()
        torchProbe.turnOff()
        torch.isTorchOn = false
    }

    public func onAppBackground() {
        pauseActiveDetailTool()
        stopAllSensors()
        stopWaterEjection()
        stopToneGenerator()
        torchProbe.turnOff()
        torch.isTorchOn = false
    }

    public func onAppForeground() {
        if activeDetailCount > 0 {
            resumeActiveDetailTool()
        }
    }

    @MainActor
    public func applyPowerSavingPreference() {
        let isPowerSaving = AppState.shared.isSensorPowerSaving
        if isMotionActive {
            motionProbe.setMotionInterval(isPowerSaving ? 1.0 / 24.0 : 1.0 / 60.0)
        }
        if isMagnetometerActive {
            motionProbe.setMagnetometerInterval(isPowerSaving ? 1.0 / 15.0 : 1.0 / 30.0)
        }
        if seismometer.isRecording {
            seismicProbe.setPowerSaving(isPowerSaving)
        }
        if luxMeter.isSampling {
            luxProbe.setPowerSaving(isPowerSaving)
        }
        if bleProbe.isScanning {
            bleProbe.setPowerSaving(isPowerSaving)
        }
        if gnssProbe.isTracking {
            startGnssTracking()
        }
    }

    public func enterDetailView(tool: ActiveDetailTool = .other) {
        activeDetailCount += 1
        currentActiveDetailTool = tool
    }

    public func leaveDetailView() {
        activeDetailCount = max(0, activeDetailCount - 1)
        if activeDetailCount == 0 {
            currentActiveDetailTool = .none
            isSpiritLevelDetailActive = false
        }
    }

    public func pauseActiveDetailTool() {
        switch currentActiveDetailTool {
        case .barometer:
            stopBarometer()
        case .seismometer:
            stopSeismicMonitoring()
        case .luxMeter:
            stopLuxSampling()
        case .decibelMeter:
            stopDecibelMeter()
        case .compass:
            stopCompass()
        case .gnss:
            stopGnssTracking()
        case .bleRadar:
            stopBleRadar()
        case .microscope:
            stopMicroscope()
        case .pulseMeter:
            stopPulseMeasurement()
        case .spiritLevel:
            stopMotionSensors()
        case .metalDetector:
            stopMagnetometer()
        case .torch:
            torchProbe.turnOff()
            torch.isTorchOn = false
        case .waterEjector:
            stopWaterEjection()
        case .toneGenerator:
            stopToneGenerator()
        case .speakerLab:
            stopSpeakerTest()
        case .screenQuality:
            stopProximityMonitoring()
        case .screenRuler, .touchMatrix, .hapticLab, .none, .other:
            break
        }
    }

    public func resumeActiveDetailTool() {
        switch currentActiveDetailTool {
        case .barometer:
            startBarometer()
        case .seismometer:
            startSeismicMonitoring()
        case .luxMeter:
            startLuxSampling()
        case .decibelMeter:
            startDecibelMeter()
        case .compass:
            startCompass(enableGpsLocation: isCompassGpsEnabled)
        case .gnss:
            startGnssTracking()
        case .bleRadar:
            startBleRadar()
        case .microscope:
            startMicroscope()
        case .pulseMeter:
            startPulseMeasurement()
        case .spiritLevel:
            startMotionSensors()
        case .metalDetector:
            startMagnetometer()
        case .screenQuality:
            startProximityMonitoring()
        case .torch, .waterEjector, .toneGenerator, .speakerLab, .screenRuler, .touchMatrix, .hapticLab, .none, .other:
            break
        }
    }

    // MARK: - 1. Spirit Level Actions
    public func startMotionSensors(interval: TimeInterval = 1.0 / 60.0) {
        guard motionProbe.isDeviceMotionAvailable else {
            isMotionActive = false
            return
        }
        guard !isMotionActive else {
            motionProbe.setMotionInterval(interval)
            return
        }
        isMotionActive = true

        motionProbe.startMotionUpdates(interval: interval) { [weak self] data in
            guard let self, self.isToolsModuleActive else { return }

            if !self.spiritLevel.isLocked {
                self.spiritLevel.rollDegrees = data.rollDegrees
                self.spiritLevel.pitchDegrees = data.pitchDegrees
                self.spiritLevel.tiltDegrees = data.tiltDegrees
                self.spiritLevel.isLevel = data.isLevel
                self.spiritLevel.orientation = data.orientation
                self.spiritLevel.slopePercent = data.slopePercent

                // Haptic & Sound Snap on 0.0° Level Lock (strictly scoped to Spirit Level detail view)
                if self.isSpiritLevelDetailActive && data.isLevel && !self.wasLevelInLastTick {
                    Haptics.impact(.medium)
                    if self.spiritLevel.isBeepEnabled && AppState.shared.isSoundEnabled {
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

    public func toggleSpiritLevelOrientation() {
        Haptics.selection()
        let next: SpiritLevelOrientation = if let override = spiritLevelOrientationOverride {
            override == .flat ? .vertical : .flat
        } else {
            spiritLevel.orientation == .flat ? .vertical : .flat
        }
        spiritLevelOrientationOverride = next
        motionProbe.orientationOverride = next
        spiritLevel.orientation = next
    }

    public func calibrateSpiritLevel() {
        Haptics.success()
        motionProbe.calibrateSpiritLevel()
        spiritLevel.rollDegrees = 0.0
        spiritLevel.pitchDegrees = 0.0
        spiritLevel.tiltDegrees = 0.0
        spiritLevel.slopePercent = 0.0
        spiritLevel.isLevel = true
    }

    public func resetSpiritLevelCalibration(emitHaptic: Bool = true) {
        if emitHaptic {
            Haptics.selection()
        }
        motionProbe.resetSpiritLevelCalibration()
        spiritLevelOrientationOverride = nil
        motionProbe.orientationOverride = nil
    }

    public func resetAllCalibrations(emitHaptic: Bool = true) {
        resetSpiritLevelCalibration(emitHaptic: emitHaptic)
        caliperTareOffsetMm = 0.0
        barometerAltitudeTareMeters = 0.0
        rawRelativeAltitudeMeters = 0.0
        barometer.relativeAltitudeMeters = 0.0
        metalDetector.baselineMicroTesla = 45.0
        metalDetector.deltaMicroTesla = 0.0
        metalDetector.normalizedSignal = 0.0
        seismicProbe.resetPeak()
        seismometer.peakGal = 0.0
    }

    // MARK: - 2. Screen Caliper Actions
    public nonisolated static func formatCaliperMeasurement(mm: Double, unit: ScreenCaliperUnit) -> String {
        switch unit {
        case .mm:
            return String(format: "%.1f mm", mm)
        case .cm:
            return String(format: "%.2f cm", mm / 10.0)
        case .inch:
            return String(format: "%.3f in", mm / 25.4)
        }
    }

    public func setCaliperMm(_ mm: Double) {
        caliperRawSpanMm = max(0.0, mm + caliperTareOffsetMm)
    }

    public func setCaliperRawMm(_ mm: Double) {
        caliperRawSpanMm = max(0.0, mm)
    }

    public func tareCaliper() {
        Haptics.tick()
        caliperTareOffsetMm = caliperRawSpanMm
    }

    public func resetTare() {
        Haptics.tick()
        caliperTareOffsetMm = 0.0
    }

    public func saveCurrentCaliperMeasurement() {
        Haptics.success()
        let val = caliperCurrentMm
        let formattedNote = Self.formatCaliperMeasurement(mm: val, unit: caliperUnit)
        let record = CaliperRecord(
            valueMm: val,
            unit: caliperUnit.title,
            timestamp: Date(),
            note: formattedNote
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
            for currentTick in 1 ... totalTicks {
                try? await Task.sleep(nanoseconds: 100_000_000)
                guard let self, !Task.isCancelled else { break }

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
    public var isTorchAvailable: Bool {
        torchProbe.isHardwareTorchAvailable
    }

    public func turnOffTorch() {
        torch.isTorchOn = false
        torchProbe.turnOff()
    }

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
        guard motionProbe.isMagnetometerAvailable else {
            isMagnetometerActive = false
            return
        }
        guard !isMagnetometerActive else {
            motionProbe.setMagnetometerInterval(interval)
            return
        }
        isMagnetometerActive = true

        motionProbe.startMagnetometerUpdates(interval: interval) { [weak self] x, y, z, total in
            guard let self, self.isToolsModuleActive else { return }

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
        barometer.isAvailable = motionProbe.isAltimeterAvailable
        guard barometer.isAvailable else {
            isBarometerActive = false
            return
        }
        guard !isBarometerActive else { return }
        isBarometerActive = true

        motionProbe.startAltimeterUpdates(onStatus: { [weak self] available in
            guard let self else { return }
            self.barometer.isAvailable = available
            if !available {
                self.isBarometerActive = false
            }
        }) { [weak self] pressureHpa, altitudeM, speedMps, trend in
            guard let self, self.isToolsModuleActive else { return }

            self.rawRelativeAltitudeMeters = altitudeM
            self.barometer.pressureHpa = pressureHpa
            self.barometer.relativeAltitudeMeters = altitudeM - self.barometerAltitudeTareMeters
            self.barometer.verticalSpeedMps = speedMps
            self.barometer.trend = trend

            // Append real pressure history sample
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
        barometerAltitudeTareMeters = 0.0
        rawRelativeAltitudeMeters = 0.0
    }

    public func resetBarometerAltitude() {
        Haptics.impact(.light)
        barometerAltitudeTareMeters = rawRelativeAltitudeMeters
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
            audioProbe.setToneWaveform(wave)
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
        stopLuxSampling()
        stopSeismicMonitoring()
        stopPulseMeasurement()
        stopGnssTracking()
        stopBleRadar()
        stopMicroscope()
        stopProximityMonitoring()
    }

    // MARK: - 9. Decibel Sound Meter Actions
    public func startDecibelMeter() {
        guard !isDecibelActive else { return }
        decibelStatus = .active
        decibelMeter.history.removeAll()
        decibelMeter.currentDb = 0.0
        decibelMeter.avgDb = 0.0
        decibelMeter.minDb = 120.0
        decibelMeter.peakDb = 0.0

        audioProbe.startDecibelMetering(onStatus: { [weak self] status in
            guard let self else { return }
            self.decibelStatus = status
            if status == .active {
                self.isDecibelActive = true
                self.decibelMeter.isRecording = true
            } else {
                self.isDecibelActive = false
                self.decibelMeter.isRecording = false
            }
        }) { [weak self] currentDb in
            guard let self, self.isToolsModuleActive else { return }
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
        isCompassGpsEnabled = enableGpsLocation
        guard !isCompassActive else {
            motionProbe.setCompassGpsActive(enableGpsLocation)
            return
        }
        isCompassActive = true
        motionProbe.startCompassUpdates(
            enableGpsLocation: enableGpsLocation,
            onAuthorizationChange: { [weak self] status in
                self?.compassAuthStatus = status
            }
        ) { [weak self] data in
            guard let self, self.isToolsModuleActive else { return }
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

    // MARK: - 14. Camera PPG Optical Pulse Actions
    public func startPulseMeasurement() {
        pulseStatus = .active
        pulseMeter.bpm = 0
        pulseMeter.hrvMs = 0.0
        pulseMeter.isFingerDetected = false
        pulseMeter.waveformHistory.removeAll()

        pulseProbe.startMeasurement(
            onStatus: { [weak self] status in
                guard let self else { return }
                self.pulseStatus = status
                self.pulseMeter.isMeasuring = (status == .active)
            },
            onTorchStateChange: { [weak self] isOn in
                self?.isPulseTorchOn = isOn
            }
        ) { [weak self] bpm, hrv, pulse, isDetected in
            guard let self else { return }
            self.pulseMeter.isFingerDetected = isDetected
            if bpm > 0 {
                self.pulseMeter.bpm = bpm
            }
            if hrv > 0 {
                self.pulseMeter.hrvMs = hrv
            }
            if isDetected {
                let pt = MetricPoint(timestamp: Date(), value: pulse)
                self.pulseMeter.waveformHistory.append(pt)
                if self.pulseMeter.waveformHistory.count > 60 {
                    self.pulseMeter.waveformHistory.removeFirst()
                }
            }
        }
    }

    public func stopPulseMeasurement() {
        pulseProbe.stopMeasurement()
        pulseMeter.isMeasuring = false
        isPulseTorchOn = false
    }

    public func togglePulseTorch() {
        pulseProbe.toggleTorch()
    }

    // MARK: - 15. Seismometer & Vibration Spectrum Actions
    public func startSeismicMonitoring(interval: TimeInterval = 1.0 / 60.0) {
        guard !seismometer.isRecording else { return }

        seismicProbe.startSeismicMonitoring(
            interval: interval,
            isPowerSaving: AppState.shared.isSensorPowerSaving,
            onStatus: { [weak self] available in
                guard let self else { return }
                self.isSeismicHardwareAvailable = available
                self.seismometer.isRecording = available
            }
        ) { [weak self] data in
            guard let self, self.isToolsModuleActive else { return }
            self.seismometer.accelX = data.accelX
            self.seismometer.accelY = data.accelY
            self.seismometer.accelZ = data.accelZ
            self.seismometer.vectorMagnitudeGal = data.vectorMagnitudeGal
            self.seismometer.peakGal = data.peakGal
            self.seismometer.dominantFrequencyHz = data.dominantFrequencyHz
            self.seismometer.intensity = data.intensity

            let pt = MetricPoint(timestamp: Date(), value: data.vectorMagnitudeGal)
            self.seismometer.historyMagnitude.append(pt)
            if self.seismometer.historyMagnitude.count > 60 {
                self.seismometer.historyMagnitude.removeFirst()
            }
        }
    }

    public func stopSeismicMonitoring() {
        seismicProbe.stopSeismicMonitoring()
        seismometer.isRecording = false
    }

    public func resetSeismicPeak() {
        Haptics.impact(.light)
        seismicProbe.resetPeak()
        seismometer.peakGal = 0.0
    }

    // MARK: - 16. Ambient Lux Meter Actions
    public func startLuxSampling() {
        guard !luxMeter.isSampling else { return }
        luxStatus = .active

        luxProbe.startLuxSampling(
            isPowerSaving: AppState.shared.isSensorPowerSaving,
            onStatus: { [weak self] status in
                guard let self else { return }
                self.luxStatus = status
                self.luxMeter.isSampling = (status == .active)
            }
        ) { [weak self] lux, fc, ev, env in
            guard let self, self.isToolsModuleActive else { return }
            self.luxMeter.currentLux = lux
            self.luxMeter.currentFootCandles = fc
            self.luxMeter.exposureValueEV = ev
            self.luxMeter.environmentDescription = env

            let pt = MetricPoint(timestamp: Date(), value: lux)
            self.luxMeter.history.append(pt)
            if self.luxMeter.history.count > 30 {
                self.luxMeter.history.removeFirst()
            }
        }
    }

    public func stopLuxSampling() {
        luxProbe.stopLuxSampling()
        luxMeter.isSampling = false
    }

    // MARK: - 17. GNSS Hub Actions
    public func startGnssTracking() {
        gnssProbe.startTracking(
            isPowerSaving: AppState.shared.isSensorPowerSaving,
            onAuthorizationChange: { [weak self] status in
                self?.gnssAuthStatus = status
            }
        ) { [weak self] data in
            guard let self else { return }
            self.gnssHub = data
        }
    }

    public func stopGnssTracking() {
        gnssProbe.stopTracking()
    }

    // MARK: - 18. Bluetooth LE Radar Actions
    public func startBleRadar() {
        bleProbe.startScanning(isPowerSaving: AppState.shared.isSensorPowerSaving) { [weak self] data in
            guard let self else { return }
            var normalized = data
            normalized.discoveredDevices = data.discoveredDevices.map { dev in
                guard dev.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return dev }
                return BleDeviceItem(
                    id: dev.id,
                    name: L10n.Tools.unknownBleDevice,
                    rssi: dev.rssi,
                    distanceEstimateM: dev.distanceEstimateM,
                    lastSeen: dev.lastSeen
                )
            }
            if !normalized.discoveredDevices.isEmpty,
               normalized.nearestDeviceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                normalized.nearestDeviceName = L10n.Tools.unknownBleDevice
            }
            self.bleRadar = normalized
        }
    }

    public func stopBleRadar() {
        bleProbe.stopScanning()
        bleRadar.isScanning = false
    }

    // MARK: - 19. Industrial Microscope Actions
    public func setMicroscopeZoom(_ factor: CGFloat) {
        let clamped = max(1.0, min(15.0, factor))
        microscope.zoomFactor = clamped
        microscopeProbe.setZoomFactor(clamped)
    }

    public func toggleMicroscopeFreeze() {
        Haptics.selection()
        microscope.isFrozen.toggle()
        microscopeProbe.setFrozen(microscope.isFrozen)
    }

    public func setMicroscopeFilter(_ filter: MicroscopeFilterMode) {
        Haptics.selection()
        microscope.filterMode = filter
        microscopeProbe.setFilterMode(filter)
    }

    // Aliases & Convenience
    public func startSeismometer() {
        startSeismicMonitoring()
    }
    public func stopSeismometer() {
        stopSeismicMonitoring()
    }

    public func startLuxMeter() {
        startLuxSampling()
    }
    public func stopLuxMeter() {
        stopLuxSampling()
    }

    public func startGnssHub() {
        startGnssTracking()
    }
    public func stopGnssHub() {
        stopGnssTracking()
    }

    public func startMicroscope() {
        microscopeStatus = .active
        microscopeProcessedImage = nil
        microscopeProbe.startSession(
            initialZoom: microscope.zoomFactor,
            initialTorch: microscope.isTorchOn,
            filterMode: microscope.filterMode,
            onStatus: { [weak self] status in
                self?.microscopeStatus = status
            },
            onFrameUpdate: { [weak self] image in
                self?.microscopeProcessedImage = image
            }
        )
    }

    public func stopMicroscope() {
        microscopeProbe.turnTorchOff()
        microscopeProbe.stopSession()
        microscope.isTorchOn = false
        microscope.isFrozen = false
        microscopeProcessedImage = nil
    }

    public func freezeMicroscopeFrame() {
        toggleMicroscopeFreeze()
    }

    public func toggleMicroscopeTorch() {
        Haptics.selection()
        microscope.isTorchOn.toggle()
        microscopeProbe.setTorchMode(isOn: microscope.isTorchOn)
    }

    public func cycleMicroscopeFilter() {
        let all = MicroscopeFilterMode.allCases
        if let idx = all.firstIndex(of: microscope.filterMode) {
            let next = all[(idx + 1) % all.count]
            setMicroscopeFilter(next)
        }
    }
}
