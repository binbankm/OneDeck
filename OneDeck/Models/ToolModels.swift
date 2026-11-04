//
//  ToolModels.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Domain data models for hardware diagnostic instruments.
//

import SwiftUI

// MARK: - Active Detail Tool Identifier
public enum ActiveDetailTool: String, Sendable {
    case none
    case barometer
    case seismometer
    case luxMeter
    case decibelMeter
    case compass
    case gnss
    case bleRadar
    case microscope
    case pulseMeter
    case spiritLevel
    case metalDetector
    case other
}

// MARK: - Hardware Tool Registry
public enum HardwareTool: String, CaseIterable, Identifiable, Hashable, Sendable {
    case spiritLevel
    case compass
    case seismometer
    case barometer
    case luxMeter
    case metalDetector
    case decibelMeter
    case waterEjector
    case toneGenerator
    case speakerLab
    case screenRuler
    case screenQuality
    case touchMatrix
    case hapticLab
    case precisionTorch
    case pulseMeter
    case microscope
    case gnssHub
    case bleRadar

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .spiritLevel: return L10n.Tools.spiritLevel
        case .compass: return L10n.Tools.compass
        case .seismometer: return L10n.Tools.seismometer
        case .barometer: return L10n.Tools.barometer
        case .luxMeter: return L10n.Tools.luxMeter
        case .metalDetector: return L10n.Tools.metalDetector
        case .decibelMeter: return L10n.Tools.decibelMeter
        case .waterEjector: return L10n.Tools.waterEjector
        case .toneGenerator: return L10n.Tools.toneGenerator
        case .speakerLab: return L10n.Tools.speakerLab
        case .screenRuler: return L10n.Tools.screenRuler
        case .screenQuality: return L10n.Tools.screenQuality
        case .touchMatrix: return L10n.Tools.touchMatrix
        case .hapticLab: return L10n.Tools.hapticLab
        case .precisionTorch: return L10n.Tools.torchLab
        case .pulseMeter: return L10n.Tools.pulseMeter
        case .microscope: return L10n.Tools.microscope
        case .gnssHub: return L10n.Tools.gnssHub
        case .bleRadar: return L10n.Tools.bleRadar
        }
    }

    public var subtitle: String {
        switch self {
        case .spiritLevel: return L10n.Tools.spiritLevelCardDesc
        case .compass: return L10n.Tools.compassCardDesc
        case .seismometer: return L10n.Tools.seismometerCardDesc
        case .barometer: return L10n.Tools.barometerCardDesc
        case .luxMeter: return L10n.Tools.luxMeterCardDesc
        case .metalDetector: return L10n.Tools.metalDetectorCardDesc
        case .decibelMeter: return L10n.Tools.decibelMeterCardDesc
        case .waterEjector: return L10n.Tools.waterEjectorCardDesc
        case .toneGenerator: return L10n.Tools.toneGeneratorCardDesc
        case .speakerLab: return L10n.Tools.speakerLabCardDesc
        case .screenRuler: return L10n.Tools.screenRulerCardDesc
        case .screenQuality: return L10n.Tools.screenQualityCardDesc
        case .touchMatrix: return L10n.Tools.touchMatrixCardDesc
        case .hapticLab: return L10n.Tools.hapticLabCardDesc
        case .precisionTorch: return L10n.Tools.torchLabCardDesc
        case .pulseMeter: return L10n.Tools.pulseMeterCardDesc
        case .microscope: return L10n.Tools.microscopeCardDesc
        case .gnssHub: return L10n.Tools.gnssHubCardDesc
        case .bleRadar: return L10n.Tools.bleRadarCardDesc
        }
    }

    public var icon: String {
        switch self {
        case .spiritLevel: return "level.fill"
        case .compass: return "location.north.line.fill"
        case .seismometer: return "waveform.path.ecg.rectangle.fill"
        case .barometer: return "gauge.with.needle.fill"
        case .luxMeter: return "sun.max.fill"
        case .metalDetector: return "sensor.fill"
        case .decibelMeter: return "waveform"
        case .waterEjector: return "drop.circle.fill"
        case .toneGenerator: return "tuningfork"
        case .speakerLab: return "speaker.wave.3.fill"
        case .screenRuler: return "ruler.fill"
        case .screenQuality: return "display"
        case .touchMatrix: return "grid"
        case .hapticLab: return "hand.tap.fill"
        case .precisionTorch: return "flashlight.on.fill"
        case .pulseMeter: return "heart.fill"
        case .microscope: return "camera.macro"
        case .gnssHub: return "location.north.circle.fill"
        case .bleRadar: return "antenna.radiowaves.left.and.right"
        }
    }
}

// MARK: - 1. Spirit Level & Inclinometer Models
public enum SpiritLevelOrientation: String, Sendable {
    case flat // Lying flat on table (2D circular bubble reticle)
    case vertical // Standing upright on edge (1D builder's angle meter)
}

public struct SpiritLevelData: Sendable {
    public var rollDegrees: Double = 0.0
    public var pitchDegrees: Double = 0.0
    public var tiltDegrees: Double = 0.0
    public var isLevel: Bool = true
    public var orientation: SpiritLevelOrientation = .flat
    public var slopePercent: Double = 0.0
    public var isLocked: Bool = false
    public var isBeepEnabled: Bool = false

    public init(
        rollDegrees: Double = 0.0,
        pitchDegrees: Double = 0.0,
        tiltDegrees: Double = 0.0,
        isLevel: Bool = true,
        orientation: SpiritLevelOrientation = .flat,
        slopePercent: Double = 0.0,
        isLocked: Bool = false,
        isBeepEnabled: Bool = false
    ) {
        self.rollDegrees = rollDegrees
        self.pitchDegrees = pitchDegrees
        self.tiltDegrees = tiltDegrees
        self.isLevel = isLevel
        self.orientation = orientation
        self.slopePercent = slopePercent
        self.isLocked = isLocked
        self.isBeepEnabled = isBeepEnabled
    }
}

// MARK: - 2. Native Screen Caliper Models
public enum ScreenCaliperUnit: String, CaseIterable, Identifiable, Sendable {
    case mm
    case cm
    case inch

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .mm: return "mm"
        case .cm: return "cm"
        case .inch: return "inch"
        }
    }
}

public enum CaliperMode: String, CaseIterable, Identifiable, Sendable {
    case outside
    case inside
    case depth

    public var id: String { rawValue }
}

public struct CaliperRecord: Identifiable, Codable, Sendable {
    public let id: UUID
    public let valueMm: Double
    public let unit: String
    public let timestamp: Date
    public var note: String

    public init(id: UUID = UUID(), valueMm: Double, unit: String, timestamp: Date = Date(), note: String = "") {
        self.id = id
        self.valueMm = valueMm
        self.unit = unit
        self.timestamp = timestamp
        self.note = note
    }
}

// MARK: - 3. Sonic Water Ejector Models
public enum WaterEjectorMode: String, CaseIterable, Identifiable, Sendable {
    case deep165Hz // 165Hz Apple Watch resonant sine wave
    case dustClear440Hz // 440Hz / 800Hz high-frequency dust impulse

    public var id: String { rawValue }

    public var targetFrequency: Double {
        switch self {
        case .deep165Hz: return 165.0
        case .dustClear440Hz: return 440.0
        }
    }
}

public struct WaterEjectorState: Sendable {
    public var isRunning: Bool = false
    public var progress: Double = 0.0
    public var remainingSeconds: Int = 12
    public var selectedMode: WaterEjectorMode = .deep165Hz

    public init(
        isRunning: Bool = false,
        progress: Double = 0.0,
        remainingSeconds: Int = 12,
        selectedMode: WaterEjectorMode = .deep165Hz
    ) {
        self.isRunning = isRunning
        self.progress = progress
        self.remainingSeconds = remainingSeconds
        self.selectedMode = selectedMode
    }
}

// MARK: - 4. Precision Torch & Strobe Models
public enum TorchWorkMode: String, CaseIterable, Identifiable, Sendable {
    case continuous
    case strobe
    case sos
    case softbox

    public var id: String { rawValue }
}

public struct TorchState: Sendable {
    public var isTorchOn: Bool = false
    public var brightness: Float = 0.5
    public var currentMode: TorchWorkMode = .continuous
    public var strobeFrequencyHz: Double = 10.0
    public var morseInputText: String = "SOS"
    public var isMorseFlashing: Bool = false
    public var softboxKelvin: Double = 5000.0
    public var softboxColorHex: String = "#FFFFFF"

    public init(
        isTorchOn: Bool = false,
        brightness: Float = 0.5,
        currentMode: TorchWorkMode = .continuous,
        strobeFrequencyHz: Double = 10.0,
        morseInputText: String = "SOS",
        isMorseFlashing: Bool = false,
        softboxKelvin: Double = 5000.0,
        softboxColorHex: String = "#FFFFFF"
    ) {
        self.isTorchOn = isTorchOn
        self.brightness = brightness
        self.currentMode = currentMode
        self.strobeFrequencyHz = strobeFrequencyHz
        self.morseInputText = morseInputText
        self.isMorseFlashing = isMorseFlashing
        self.softboxKelvin = softboxKelvin
        self.softboxColorHex = softboxColorHex
    }
}

// MARK: - 5. Magnetic Field & Metal Detector Models
public struct MetalDetectorData: Sendable {
    public var xMicroTesla: Double = 0.0
    public var yMicroTesla: Double = 0.0
    public var zMicroTesla: Double = 0.0
    public var totalMicroTesla: Double = 45.0
    public var baselineMicroTesla: Double = 45.0
    public var deltaMicroTesla: Double = 0.0
    public var normalizedSignal: Double = 0.0 // 0.0 ~ 1.0 (clamped)
    public var isGeigerAudioActive: Bool = false
    public var history: [MetricPoint] = []

    public init(
        xMicroTesla: Double = 0.0,
        yMicroTesla: Double = 0.0,
        zMicroTesla: Double = 0.0,
        totalMicroTesla: Double = 45.0,
        baselineMicroTesla: Double = 45.0,
        deltaMicroTesla: Double = 0.0,
        normalizedSignal: Double = 0.0,
        isGeigerAudioActive: Bool = false,
        history: [MetricPoint] = []
    ) {
        self.xMicroTesla = xMicroTesla
        self.yMicroTesla = yMicroTesla
        self.zMicroTesla = zMicroTesla
        self.totalMicroTesla = totalMicroTesla
        self.baselineMicroTesla = baselineMicroTesla
        self.deltaMicroTesla = deltaMicroTesla
        self.normalizedSignal = normalizedSignal
        self.isGeigerAudioActive = isGeigerAudioActive
        self.history = history
    }
}

// MARK: - 6. Atmospheric Barometer & Altimeter Models
public enum PressureTrend: String, Sendable {
    case rising
    case steady
    case falling
}

public struct BarometerData: Sendable {
    public var pressureHpa: Double = 1013.25
    public var relativeAltitudeMeters: Double = 0.0
    public var verticalSpeedMps: Double = 0.0
    public var trend: PressureTrend = .steady
    public var history: [MetricPoint] = []
    public var isAvailable: Bool = true

    public init(
        pressureHpa: Double = 1013.25,
        relativeAltitudeMeters: Double = 0.0,
        verticalSpeedMps: Double = 0.0,
        trend: PressureTrend = .steady,
        history: [MetricPoint] = [],
        isAvailable: Bool = true
    ) {
        self.pressureHpa = pressureHpa
        self.relativeAltitudeMeters = relativeAltitudeMeters
        self.verticalSpeedMps = verticalSpeedMps
        self.trend = trend
        self.history = history
        self.isAvailable = isAvailable
    }
}

// MARK: - 7. Tone Generator & Hearing Test Models
public enum ToneWaveform: String, CaseIterable, Identifiable, Sendable {
    case sine
    case square
    case triangle
    case sawtooth

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .sine: return "Sine"
        case .square: return "Square"
        case .triangle: return "Triangle"
        case .sawtooth: return "Saw"
        }
    }
}

public struct ToneGeneratorData: Sendable {
    public var frequencyHz: Double = 440.0
    public var waveform: ToneWaveform = .sine
    public var isPlaying: Bool = false
    public var volume: Float = 0.5
    public var isHearingTestActive: Bool = false
    public var hearingTestCurrentFreq: Double = 8000.0
    public var hearingCutoffFreq: Double?

    public init(
        frequencyHz: Double = 440.0,
        waveform: ToneWaveform = .sine,
        isPlaying: Bool = false,
        volume: Float = 0.5,
        isHearingTestActive: Bool = false,
        hearingTestCurrentFreq: Double = 8000.0,
        hearingCutoffFreq: Double? = nil
    ) {
        self.frequencyHz = frequencyHz
        self.waveform = waveform
        self.isPlaying = isPlaying
        self.volume = volume
        self.isHearingTestActive = isHearingTestActive
        self.hearingTestCurrentFreq = hearingTestCurrentFreq
        self.hearingCutoffFreq = hearingCutoffFreq
    }
}

// MARK: - 8. Screen Quality & Touch Models
public enum ScreenQualityColor: CaseIterable, Identifiable, Sendable {
    case black
    case white
    case red
    case green
    case blue
    case yellow
    case grayscale

    public var id: String {
        switch self {
        case .black: return "black"
        case .white: return "white"
        case .red: return "red"
        case .green: return "green"
        case .blue: return "blue"
        case .yellow: return "yellow"
        case .grayscale: return "grayscale"
        }
    }

    public var color: Color {
        switch self {
        case .black: return .black
        case .white: return .white
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        case .yellow: return .yellow
        case .grayscale: return Color(white: 0.5)
        }
    }
}

public struct TouchPointItem: Identifiable, Sendable {
    public let id: Int
    public var location: CGPoint
    public var radius: CGFloat
    public var pressure: CGFloat

    public init(id: Int, location: CGPoint, radius: CGFloat = 24.0, pressure: CGFloat = 1.0) {
        self.id = id
        self.location = location
        self.radius = radius
        self.pressure = pressure
    }
}

// MARK: - 9. Haptic Engine Lab Models
public enum HapticImpactStyle: String, CaseIterable, Identifiable, Sendable {
    case light
    case medium
    case heavy
    case rigid
    case soft

    public var id: String { rawValue }
}

public enum HapticNotificationStyle: String, CaseIterable, Identifiable, Sendable {
    case success
    case warning
    case error

    public var id: String { rawValue }
}

// MARK: - 10. Decibel Sound Meter Models
public struct DecibelMeterData: Sendable {
    public var currentDb: Double = 0.0
    public var peakDb: Double = 0.0
    public var minDb: Double = 0.0
    public var avgDb: Double = 0.0
    public var isRecording: Bool = false
    public var history: [MetricPoint] = []

    public init(
        currentDb: Double = 0.0,
        peakDb: Double = 0.0,
        minDb: Double = 0.0,
        avgDb: Double = 0.0,
        isRecording: Bool = false,
        history: [MetricPoint] = []
    ) {
        self.currentDb = currentDb
        self.peakDb = peakDb
        self.minDb = minDb
        self.avgDb = avgDb
        self.isRecording = isRecording
        self.history = history
    }
}

// MARK: - 11. 3D Compass Models
public struct CompassData: Sendable {
    public var magneticHeading: Double = 0.0
    public var trueHeading: Double = 0.0
    public var headingAccuracy: Double = 0.0
    public var cardinalDirection: String = "N"
    public var rollDegrees: Double = 0.0
    public var pitchDegrees: Double = 0.0
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0
    public var altitudeMeters: Double = 0.0

    public init(
        magneticHeading: Double = 0.0,
        trueHeading: Double = 0.0,
        headingAccuracy: Double = 0.0,
        cardinalDirection: String = "N",
        rollDegrees: Double = 0.0,
        pitchDegrees: Double = 0.0,
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        altitudeMeters: Double = 0.0
    ) {
        self.magneticHeading = magneticHeading
        self.trueHeading = trueHeading
        self.headingAccuracy = headingAccuracy
        self.cardinalDirection = cardinalDirection
        self.rollDegrees = rollDegrees
        self.pitchDegrees = pitchDegrees
        self.latitude = latitude
        self.longitude = longitude
        self.altitudeMeters = altitudeMeters
    }
}

// MARK: - 12. Stereo Speaker Diagnostics Models
public enum SpeakerChannel: String, CaseIterable, Identifiable, Sendable {
    case stereo
    case left
    case right

    public var id: String { rawValue }
}

// MARK: - 13. Camera PPG Optical Pulse Meter Models
public struct PulseMeterData: Sendable {
    public var bpm: Int = 0
    public var hrvMs: Double = 0.0
    public var signalQuality: Double = 0.0
    public var isFingerDetected: Bool = false
    public var isMeasuring: Bool = false
    public var waveformHistory: [MetricPoint] = []

    public init(
        bpm: Int = 0,
        hrvMs: Double = 0.0,
        signalQuality: Double = 0.0,
        isFingerDetected: Bool = false,
        isMeasuring: Bool = false,
        waveformHistory: [MetricPoint] = []
    ) {
        self.bpm = bpm
        self.hrvMs = hrvMs
        self.signalQuality = signalQuality
        self.isFingerDetected = isFingerDetected
        self.isMeasuring = isMeasuring
        self.waveformHistory = waveformHistory
    }
}

// MARK: - 14. Seismometer & Vibration Spectrum Models
public enum SeismicIntensity: String, CaseIterable, Identifiable, Sendable {
    case instrumental // 0 ~ I (微震无感)
    case weak // II ~ III (轻微震颤)
    case moderate // IV (有感震动)
    case strong // V+ (较强震动)

    public var id: String { rawValue }

    public var labelZh: String { title }

    public var title: String {
        switch self {
        case .instrumental: return L10n.tr(zh: "微震 (0-I度)", en: "Micro (0-I)", hant: "微震 (0-I度)")
        case .weak: return L10n.tr(zh: "轻微 (II-III度)", en: "Minor (II-III)", hant: "輕微 (II-III度)")
        case .moderate: return L10n.tr(zh: "中度 (IV度)", en: "Moderate (IV)", hant: "中度 (IV度)")
        case .strong: return L10n.tr(zh: "较强 (V+度)", en: "Strong (V+)", hant: "較強 (V+度)")
        }
    }

    public var titleZh: String { title }

    public var shortCode: String {
        switch self {
        case .instrumental: return "I"
        case .weak: return "II-III"
        case .moderate: return "IV"
        case .strong: return "V+"
        }
    }

    public var maxGal: Double {
        switch self {
        case .instrumental: return 2.5
        case .weak: return 10.0
        case .moderate: return 25.0
        case .strong: return 100.0
        }
    }

    public var color: Color {
        switch self {
        case .instrumental: return Color.green
        case .weak: return Color.blue
        case .moderate: return Color.orange
        case .strong: return Color.red
        }
    }
}

public struct SeismometerData: Sendable {
    public var accelX: Double = 0.0
    public var accelY: Double = 0.0
    public var accelZ: Double = 0.0
    public var vectorMagnitudeGal: Double = 0.0
    public var peakGal: Double = 0.0
    public var dominantFrequencyHz: Double = 0.0
    public var intensity: SeismicIntensity = .instrumental
    public var historyMagnitude: [MetricPoint] = []
    public var isRecording: Bool = false

    public var currentGal: Double { vectorMagnitudeGal }
    public var waveform: [MetricPoint] { historyMagnitude }

    public init(
        accelX: Double = 0.0,
        accelY: Double = 0.0,
        accelZ: Double = 0.0,
        vectorMagnitudeGal: Double = 0.0,
        peakGal: Double = 0.0,
        dominantFrequencyHz: Double = 0.0,
        intensity: SeismicIntensity = .instrumental,
        historyMagnitude: [MetricPoint] = [],
        isRecording: Bool = false
    ) {
        self.accelX = accelX
        self.accelY = accelY
        self.accelZ = accelZ
        self.vectorMagnitudeGal = vectorMagnitudeGal
        self.peakGal = peakGal
        self.dominantFrequencyHz = dominantFrequencyHz
        self.intensity = intensity
        self.historyMagnitude = historyMagnitude
        self.isRecording = isRecording
    }
}

// MARK: - 15. Ambient Lux Meter Models
public struct LuxMeterData: Sendable {
    public var currentLux: Double = 0.0
    public var currentFootCandles: Double = 0.0
    public var exposureValueEV: Double = 0.0
    public var environmentDescription: String = ""
    public var history: [MetricPoint] = []
    public var isSampling: Bool = false

    public var lux: Double { currentLux }
    public var footCandles: Double { currentFootCandles }
    public var ev: Double { exposureValueEV }

    public init(
        currentLux: Double = 0.0,
        currentFootCandles: Double = 0.0,
        exposureValueEV: Double = 0.0,
        environmentDescription: String = "",
        history: [MetricPoint] = [],
        isSampling: Bool = false
    ) {
        self.currentLux = currentLux
        self.currentFootCandles = currentFootCandles
        self.exposureValueEV = exposureValueEV
        self.environmentDescription = environmentDescription
        self.history = history
        self.isSampling = isSampling
    }
}

// MARK: - 16. GNSS Hub & Coordinate Conversion Models
public struct GnssHubData: Sendable {
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0
    public var altitudeAmsl: Double = 0.0
    public var horizontalAccuracyM: Double = 0.0
    public var verticalAccuracyM: Double = 0.0
    public var speedKmh: Double = 0.0
    public var courseDeg: Double = 0.0
    public var hdop: Double = 1.0
    public var vdop: Double = 1.0
    public var wgs84Formatted: String = "--"
    public var gcj02Formatted: String = "--"
    public var bd09Formatted: String = "--"
    public var mgrsFormatted: String = "--"
    public var isFixAcquired: Bool = false

    public var mgrsString: String { mgrsFormatted }
    public var fixStatusText: String {
        isFixAcquired
            ? L10n.tr(zh: "3D 差分定位", en: "3D Differential Fix", hant: "3D 差分定位")
            : L10n.tr(zh: "搜索卫星...", en: "Searching...", hant: "搜尋衛星...")
    }
    public var altitudeM: Double { altitudeAmsl }

    public init(
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        altitudeAmsl: Double = 0.0,
        horizontalAccuracyM: Double = 0.0,
        verticalAccuracyM: Double = 0.0,
        speedKmh: Double = 0.0,
        courseDeg: Double = 0.0,
        hdop: Double = 1.0,
        vdop: Double = 1.0,
        wgs84Formatted: String = "--",
        gcj02Formatted: String = "--",
        bd09Formatted: String = "--",
        mgrsFormatted: String = "--",
        isFixAcquired: Bool = false
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitudeAmsl = altitudeAmsl
        self.horizontalAccuracyM = horizontalAccuracyM
        self.verticalAccuracyM = verticalAccuracyM
        self.speedKmh = speedKmh
        self.courseDeg = courseDeg
        self.hdop = hdop
        self.vdop = vdop
        self.wgs84Formatted = wgs84Formatted
        self.gcj02Formatted = gcj02Formatted
        self.bd09Formatted = bd09Formatted
        self.mgrsFormatted = mgrsFormatted
        self.isFixAcquired = isFixAcquired
    }
}

// MARK: - 17. Bluetooth LE Radar Models
public struct BleDeviceItem: Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let rssi: Int
    public let distanceEstimateM: Double
    public let lastSeen: Date

    public var estimatedDistanceMeters: Double { distanceEstimateM }

    public init(id: UUID, name: String, rssi: Int, distanceEstimateM: Double, lastSeen: Date = Date()) {
        self.id = id
        self.name = name
        self.rssi = rssi
        self.distanceEstimateM = distanceEstimateM
        self.lastSeen = lastSeen
    }
}

public struct BleRadarData: Sendable {
    public var discoveredDevices: [BleDeviceItem] = []
    public var isScanning: Bool = false
    public var nearestDeviceName: String = "--"
    public var strongestRssi: Int = -100

    public var devices: [BleDeviceItem] { discoveredDevices }
    public var nearestDeviceRssi: Int { strongestRssi }
    public var estimatedDistanceMeters: Double {
        guard strongestRssi != -100 else { return 0.0 }
        let ratio = Double(-59 - strongestRssi) / (10.0 * 2.5)
        return pow(10.0, ratio)
    }

    public init(
        discoveredDevices: [BleDeviceItem] = [],
        isScanning: Bool = false,
        nearestDeviceName: String = "--",
        strongestRssi: Int = -100
    ) {
        self.discoveredDevices = discoveredDevices
        self.isScanning = isScanning
        self.nearestDeviceName = nearestDeviceName
        self.strongestRssi = strongestRssi
    }
}

// MARK: - 18. Industrial Microscope Models
public enum MicroscopeFilterMode: String, CaseIterable, Identifiable, Sendable {
    case normal
    case inverted
    case highContrast
    case edgeDetection

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .normal: return L10n.Tools.filterNormal
        case .inverted: return L10n.Tools.filterInvert
        case .highContrast: return L10n.tr(zh: "高反差黑白", en: "High Contrast", hant: "高反差黑白")
        case .edgeDetection: return L10n.Tools.filterSobel
        }
    }
}

public struct MicroscopeData: Sendable {
    public var zoomFactor: CGFloat = 1.0
    public var isTorchOn: Bool = true
    public var isFrozen: Bool = false
    public var filterMode: MicroscopeFilterMode = .normal

    public init(
        zoomFactor: CGFloat = 1.0,
        isTorchOn: Bool = true,
        isFrozen: Bool = false,
        filterMode: MicroscopeFilterMode = .normal
    ) {
        self.zoomFactor = zoomFactor
        self.isTorchOn = isTorchOn
        self.isFrozen = isFrozen
        self.filterMode = filterMode
    }
}
