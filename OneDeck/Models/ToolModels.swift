//
//  ToolModels.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Domain Data Models for Hardware Diagnostic & Precision Instruments Toolkit.
//

import SwiftUI

// MARK: - 1. Spirit Level & Inclinometer Models
public enum SpiritLevelOrientation: String, Sendable {
    case flat       // Lying flat on table (2D circular bubble reticle)
    case vertical   // Standing upright on edge (1D builder's angle meter)
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
    case deep165Hz      // 165Hz Apple Watch resonant sine wave
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
    public var hearingCutoffFreq: Double? = nil

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

