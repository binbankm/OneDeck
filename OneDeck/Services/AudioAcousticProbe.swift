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

@MainActor
public final class AudioAcousticProbe {
    public static let shared = AudioAcousticProbe()

    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    private var currentFrequency: Double = 165.0
    private var currentWaveform: ToneWaveform = .sine
    private var isPlaying: Bool = false

    private init() {}

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

    // MARK: - 1. Tone & Waveform Synthesis (20Hz - 20,000Hz)
    public func startTone(frequency: Double, waveform: ToneWaveform = .sine, volume: Float = 0.8) {
        stopTone()
        configureSession()

        self.currentFrequency = max(20.0, min(20000.0, frequency))
        self.currentWaveform = waveform

        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        engine.attach(player)

        let sampleRate = 44100.0
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else { return }

        engine.connect(player, to: engine.mainMixerNode, format: format)
        engine.mainMixerNode.outputVolume = volume

        // Generate 0.5s seamless looping PCM buffer
        let bufferLength = AVAudioFrameCount(sampleRate * 0.5)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: bufferLength) else { return }
        buffer.frameLength = bufferLength

        guard let channelData = buffer.floatChannelData?[0] else { return }

        let freq = self.currentFrequency
        let wave = self.currentWaveform
        let twoPi = 2.0 * Double.pi

        for frame in 0 ..< Int(bufferLength) {
            let time = Double(frame) / sampleRate
            let phase = (time * freq).truncatingRemainder(dividingBy: 1.0)
            let sample: Float = switch wave {
            case .sine:
                Float(sin(twoPi * freq * time))
            case .square:
                phase < 0.5 ? 0.75 : -0.75
            case .triangle:
                Float(4.0 * abs(phase - 0.5) - 1.0)
            case .sawtooth:
                Float(2.0 * phase - 1.0)
            }

            channelData[frame] = sample * 0.75
        }

        do {
            try engine.start()
            player.play()
            player.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
            self.audioEngine = engine
            self.playerNode = player
            self.isPlaying = true
        } catch {
            stopTone()
        }
    }

    public func updateFrequency(_ frequency: Double) {
        guard isPlaying else { return }
        startTone(frequency: frequency, waveform: currentWaveform)
    }

    public func stopTone() {
        playerNode?.stop()
        audioEngine?.stop()
        playerNode = nil
        audioEngine = nil
        isPlaying = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    // MARK: - 2. Geiger Counter Click Sound
    public func playGeigerClick() {
        AudioServicesPlaySystemSound(1104) // Tick sound
    }

    public func playLevelLockSound() {
        AudioServicesPlaySystemSound(1057) // Soft ping sound
    }

    // MARK: - 3. Decibel Sound Metering (SPL)
    private var audioRecorder: AVAudioRecorder?
    private var decibelTimerTask: Task<Void, Never>?

    public func startDecibelMetering(handler: @escaping (Double) -> Void) {
        let session = AVAudioSession.sharedInstance()
        let permission = AVAudioApplication.shared.recordPermission
        if permission == .undetermined {
            AVAudioApplication.requestRecordPermission { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.startDecibelMetering(handler: handler)
                    }
                }
            }
            return
        } else if permission == .denied {
            return
        }

        stopDecibelMetering()

        do {
            try session.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
            try session.setActive(true)
        } catch {
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
            recorder.record()
            self.audioRecorder = recorder

            decibelTimerTask = Task { @MainActor [weak self] in
                while !Task.isCancelled {
                    let sleepNs: UInt64 = AppState.shared.isSensorPowerSaving ? 100_000_000 : 50_000_000 // 10Hz vs 20Hz
                    try? await Task.sleep(nanoseconds: sleepNs)
                    guard let self, let recorder = self.audioRecorder, recorder.isRecording else { break }
                    recorder.updateMeters()
                    let avgPower = Double(recorder.averagePower(forChannel: 0))
                    // Convert -160...0 dBFS to ~30...120 dB SPL
                    let spl = max(30.0, min(120.0, avgPower + 100.0))
                    handler(spl)
                }
            }
        } catch {
            stopDecibelMetering()
        }
    }

    public func stopDecibelMetering() {
        decibelTimerTask?.cancel()
        decibelTimerTask = nil
        audioRecorder?.stop()
        audioRecorder = nil
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    // MARK: - 4. Stereo Channel Separation Diagnostics
    public func playChannelTone(channel: SpeakerChannel, frequency: Double = 1000.0) {
        stopTone()
        configureSession()

        let engine = AVAudioEngine()
        let player = AVAudioPlayerNode()
        engine.attach(player)

        let sampleRate = 44100.0
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2) else { return }

        engine.connect(player, to: engine.mainMixerNode, format: format)

        switch channel {
        case .left:
            player.pan = -1.0
        case .right:
            player.pan = 1.0
        case .stereo:
            player.pan = 0.0
        }

        let bufferLength = AVAudioFrameCount(sampleRate * 0.5)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: bufferLength) else { return }
        buffer.frameLength = bufferLength

        guard let leftData = buffer.floatChannelData?[0], let rightData = buffer.floatChannelData?[1] else { return }
        let twoPi = 2.0 * Double.pi

        for frame in 0 ..< Int(bufferLength) {
            let time = Double(frame) / sampleRate
            let sample = Float(sin(twoPi * frequency * time)) * 0.8
            leftData[frame] = (channel == .left || channel == .stereo) ? sample : 0
            rightData[frame] = (channel == .right || channel == .stereo) ? sample : 0
        }

        do {
            try engine.start()
            player.play()
            player.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
            self.audioEngine = engine
            self.playerNode = player
            self.isPlaying = true
        } catch {
            stopTone()
        }
    }
}
