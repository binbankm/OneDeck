//
//  AudioAcousticProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Acoustic audio synthesizer and resonance tone generator probe.
//

import AudioToolbox
import AVFoundation
import Foundation
import os

public nonisolated enum DecibelMeterStatus: Sendable {
    case active
    case permissionDenied
    case hardwareUnavailable
}

private struct AudioSynthState: Sendable {
    var frequency: Double = 440.0
    var waveform: ToneWaveform = .sine
    var volume: Float = 0.5
    var leftGain: Float = 1.0
    var rightGain: Float = 1.0
    var phase: Double = 0.0
}

@MainActor
public final class AudioAcousticProbe {
    public static let shared = AudioAcousticProbe()

    private var audioEngine: AVAudioEngine?
    private var sourceNode: AVAudioSourceNode?
    private let synthLock = OSAllocatedUnfairLock(initialState: AudioSynthState())
    private var currentFrequency: Double = 165.0
    private var currentWaveform: ToneWaveform = .sine
    private var currentVolume: Float = 0.8
    private var isPlaying: Bool = false
    private var interruptionObserver: NSObjectProtocol?
    private var routeChangeObserver: NSObjectProtocol?

    private init() {
        interruptionObserver = NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let typeVal = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let type = AVAudioSession.InterruptionType(rawValue: typeVal) else { return }
            Task { @MainActor [weak self] in
                guard let self else { return }
                if type == .began {
                    self.stopTone()
                    self.stopDecibelMetering()
                }
            }
        }
        routeChangeObserver = NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let reasonVal = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                  let reason = AVAudioSession.RouteChangeReason(rawValue: reasonVal),
                  reason == .oldDeviceUnavailable else { return }
            Task { @MainActor [weak self] in
                self?.stopTone()
            }
        }
    }

    // MARK: - Audio Session Setup
    private func configureSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            // Audio session config error ignored
        }
    }

    // MARK: - 1. Tone & Waveform Synthesis (20Hz - 20,000Hz, Phase-Continuous)
    public func startTone(frequency: Double, waveform: ToneWaveform = .sine, volume: Float = 0.8) {
        let clampedFreq = max(20.0, min(20000.0, frequency))
        let clampedVol = max(0.0, min(1.0, volume))
        self.currentFrequency = clampedFreq
        self.currentWaveform = waveform
        self.currentVolume = clampedVol

        synthLock.withLock { state in
            state.frequency = clampedFreq
            state.waveform = waveform
            state.volume = clampedVol
            state.leftGain = 1.0
            state.rightGain = 1.0
        }

        if isPlaying, let engine = audioEngine, engine.isRunning {
            return
        }

        stopTone()
        configureSession()
        startSourceEngine()
    }

    public func updateFrequency(_ frequency: Double) {
        let clamped = max(20.0, min(20000.0, frequency))
        currentFrequency = clamped
        synthLock.withLock { state in
            state.frequency = clamped
        }
    }

    public func setToneWaveform(_ waveform: ToneWaveform) {
        currentWaveform = waveform
        synthLock.withLock { state in
            state.waveform = waveform
        }
    }

    public func updateVolume(_ volume: Float) {
        let clamped = max(0.0, min(1.0, volume))
        currentVolume = clamped
        synthLock.withLock { state in
            state.volume = clamped
        }
    }

    public func stopTone() {
        let wasActive = isPlaying || audioEngine != nil || sourceNode != nil
        audioEngine?.stop()
        if let node = sourceNode {
            audioEngine?.detach(node)
        }
        sourceNode = nil
        audioEngine = nil
        isPlaying = false
        synthLock.withLock { state in
            state.phase = 0.0
        }
        if wasActive && audioRecorder == nil {
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        }
    }

    private func startSourceEngine() {
        let sampleRate = 44100.0
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2) else { return }

        let engine = AVAudioEngine()
        let node = Self.makeSourceNode(synthLock: synthLock, sampleRate: sampleRate)
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: format)

        do {
            try engine.start()
            self.audioEngine = engine
            self.sourceNode = node
            self.isPlaying = true
        } catch {
            stopTone()
        }
    }

    private nonisolated static func makeSourceNode(
        synthLock: OSAllocatedUnfairLock<AudioSynthState>,
        sampleRate: Double
    ) -> AVAudioSourceNode {
        AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let params = synthLock.withLock { state -> AudioSynthState in
                let snapshot = state
                let phaseAdvance = (Double(frameCount) * state.frequency) / sampleRate
                state.phase = (state.phase + phaseAdvance).truncatingRemainder(dividingBy: 1.0)
                return snapshot
            }

            let step = params.frequency / sampleRate
            let baseGain = params.volume * 0.75
            let twoPi = 2.0 * Double.pi

            for frame in 0 ..< Int(frameCount) {
                let phase = (params.phase + Double(frame) * step).truncatingRemainder(dividingBy: 1.0)
                let rawSample: Float = switch params.waveform {
                case .sine:
                    Float(sin(twoPi * phase))
                case .square:
                    phase < 0.5 ? 0.75 : -0.75
                case .triangle:
                    Float(4.0 * abs(phase - 0.5) - 1.0)
                case .sawtooth:
                    Float(2.0 * phase - 1.0)
                }

                let leftSample = rawSample * baseGain * params.leftGain
                let rightSample = rawSample * baseGain * params.rightGain

                if ablPointer.count >= 2 {
                    if let leftBuf = ablPointer[0].mData?.assumingMemoryBound(to: Float.self) {
                        leftBuf[frame] = leftSample
                    }
                    if let rightBuf = ablPointer[1].mData?.assumingMemoryBound(to: Float.self) {
                        rightBuf[frame] = rightSample
                    }
                } else if ablPointer.count >= 1,
                          let monoBuf = ablPointer[0].mData?.assumingMemoryBound(to: Float.self) {
                    monoBuf[frame] = (leftSample + rightSample) * 0.5
                }
            }
            return noErr
        }
    }

    // MARK: - 2. Geiger Counter Click Sound
    public func playGeigerClick() {
        guard AppState.shared.isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1104) // Tick sound
    }

    public func playLevelLockSound() {
        guard AppState.shared.isSoundEnabled else { return }
        AudioServicesPlaySystemSound(1057) // Soft ping sound
    }

    // MARK: - 3. Decibel Sound Metering (SPL)
    private var audioRecorder: AVAudioRecorder?
    private var decibelTimerTask: Task<Void, Never>?
    private var decibelSessionGeneration: UInt64 = 0

    public func startDecibelMetering(
        onStatus: (@MainActor @Sendable (DecibelMeterStatus) -> Void)? = nil,
        handler: @escaping @MainActor @Sendable (Double) -> Void
    ) {
        decibelSessionGeneration &+= 1
        let gen = decibelSessionGeneration

        let session = AVAudioSession.sharedInstance()
        let permission = AVAudioApplication.shared.recordPermission
        if permission == .undetermined {
            AVAudioApplication.requestRecordPermission { granted in
                Task { @MainActor in
                    let probe = AudioAcousticProbe.shared
                    guard probe.decibelSessionGeneration == gen else { return }
                    if granted {
                        probe.startDecibelMetering(onStatus: onStatus, handler: handler)
                    } else {
                        onStatus?(.permissionDenied)
                    }
                }
            }
            return
        } else if permission == .denied {
            onStatus?(.permissionDenied)
            return
        }

        stopDecibelMetering(incrementGeneration: false)

        do {
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
            try session.setActive(true)
        } catch {
            onStatus?(.hardwareUnavailable)
            return
        }

        guard session.isInputAvailable else {
            if !isPlaying {
                try? session.setActive(false, options: .notifyOthersOnDeactivation)
            }
            onStatus?(.hardwareUnavailable)
            return
        }

        let url = URL(fileURLWithPath: "/dev/null")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]

        do {
            let recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder.isMeteringEnabled = true
            guard recorder.record() else {
                if !isPlaying {
                    try? session.setActive(false, options: .notifyOthersOnDeactivation)
                }
                onStatus?(.hardwareUnavailable)
                return
            }
            self.audioRecorder = recorder
            onStatus?(.active)

            decibelTimerTask = Task { @MainActor [weak self] in
                while !Task.isCancelled {
                    let sleepNs: UInt64 = AppState.shared.isSensorPowerSaving ? 100_000_000 : 50_000_000 // 10Hz vs 20Hz
                    try? await Task.sleep(nanoseconds: sleepNs)
                    guard let self, let recorder = self.audioRecorder, recorder.isRecording else { break }
                    recorder.updateMeters()
                    let avgPower = Double(recorder.averagePower(forChannel: 0))
                    // Convert -160...0 dBFS to ~30...115 dB SPL
                    let spl = max(30.0, min(120.0, (avgPower + 100.0) * 1.15))
                    handler(spl)
                }
            }
        } catch {
            stopDecibelMetering(incrementGeneration: false)
            onStatus?(.hardwareUnavailable)
        }
    }

    public func stopDecibelMetering(incrementGeneration: Bool = true) {
        if incrementGeneration {
            decibelSessionGeneration &+= 1
        }
        let wasActive = decibelTimerTask != nil || audioRecorder != nil
        decibelTimerTask?.cancel()
        decibelTimerTask = nil
        audioRecorder?.stop()
        audioRecorder = nil
        if wasActive && !isPlaying {
            try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        }
    }

    // MARK: - 4. Stereo Channel Separation Diagnostics
    public func playChannelTone(channel: SpeakerChannel, frequency: Double = 1000.0) {
        let clampedFreq = max(20.0, min(20000.0, frequency))
        self.currentFrequency = clampedFreq
        self.currentWaveform = .sine
        self.currentVolume = 0.8

        let left: Float = (channel == .left || channel == .stereo) ? 1.0 : 0.0
        let right: Float = (channel == .right || channel == .stereo) ? 1.0 : 0.0

        synthLock.withLock { state in
            state.frequency = clampedFreq
            state.waveform = .sine
            state.volume = 0.8
            state.leftGain = left
            state.rightGain = right
        }

        if isPlaying, let engine = audioEngine, engine.isRunning {
            return
        }

        stopTone()
        configureSession()
        startSourceEngine()
    }
}
