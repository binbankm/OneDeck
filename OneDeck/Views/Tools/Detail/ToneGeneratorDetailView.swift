//
//  ToneGeneratorDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  20Hz-20,000Hz Pure Audio Tone Synthesizer & Hearing Age Test Fullscreen Workspace.
//

import SwiftUI

struct ToneGeneratorDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // Presets
    private let quickPresets: [Double] = [60.0, 165.0, 440.0, 1000.0, 8000.0, 15000.0]

    // State
    @State private var showHearingTest: Bool = false

    // MARK: - Body
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: SpacingTheme.cardStack) {
                // Waveform Selector
                waveformPickerBar

                Spacer()

                // Center Frequency Wheel / Readout
                frequencyCenterReadout

                Spacer()

                // Frequency Slider & Steppers
                frequencySliderSection

                // Quick Presets
                presetsRow

                // Master Play / Stop Button
                playToggleButton
            }
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.toneGenerator)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView()
        }
        .onDisappear {
            tools.leaveDetailView()
            if tools.toneGenerator.isPlaying {
                tools.toggleToneGenerator()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Haptics.selection()
                    showHearingTest = true
                } label: {
                    Image(systemName: "hearingdevice.ear.fill")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(appState.accentColor)
                }
            }
        }
        .sheet(isPresented: $showHearingTest) {
            hearingAgeSheet
        }
    }

    // MARK: - Waveform Picker
    @ViewBuilder
    private var waveformPickerBar: some View {
        Picker("", selection: Binding(
            get: { tools.toneGenerator.waveform },
            set: { tools.setToneWaveform($0) }
        )) {
            ForEach(ToneWaveform.allCases) { wave in
                Text(L10n.Tools.waveformTitle(wave)).tag(wave)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Frequency Center Readout
    @ViewBuilder
    private var frequencyCenterReadout: some View {
        VStack(spacing: SpacingTheme.micro) {
            Text(String(format: tools.toneGenerator.frequencyHz >= 1000 ? "%.0f" : "%.1f", tools.toneGenerator.frequencyHz))
                .font(Typography.displayHero)
                .monospacedDigit()
                .foregroundStyle(tools.toneGenerator.isPlaying ? appState.accentColor : Theme.textTertiary(for: colorScheme))

            Text(L10n.Tools.hertzUnit)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            Text(L10n.Tools.frequencyBandTitle(tools.toneGenerator.frequencyHz))
                .font(Typography.caption)
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.micro)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
        }
    }

    // MARK: - Frequency Slider
    @ViewBuilder
    private var frequencySliderSection: some View {
        VStack(spacing: SpacingTheme.compact) {
            // Logarithmic mapping for smooth acoustic exploration
            Slider(value: Binding(
                get: { log10(max(20.0, tools.toneGenerator.frequencyHz)) },
                set: { tools.setToneFrequency(pow(10.0, $0)) }
            ), in: log10(20.0)...log10(20000.0))
            .tint(appState.accentColor)
            .padding(.horizontal, SpacingTheme.standard)

            HStack {
                Text("20 Hz")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                Spacer()
                Text("20 kHz")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
            }
            .padding(.horizontal, SpacingTheme.standard)
        }
    }

    // MARK: - Presets Row
    @ViewBuilder
    private var presetsRow: some View {
        HStack(spacing: SpacingTheme.compact) {
            ForEach(quickPresets, id: \.self) { freq in
                Button {
                    Haptics.tick()
                    tools.setToneFrequency(freq)
                } label: {
                    Text(freq >= 1000 ? "\(Int(freq/1000))k" : "\(Int(freq))")
                        .font(Typography.badgeTagMonoMedium)
                        .foregroundStyle(abs(tools.toneGenerator.frequencyHz - freq) < 1.0 ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, SpacingTheme.compact)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Master Play/Stop Button
    @ViewBuilder
    private var playToggleButton: some View {
        let isPlaying = tools.toneGenerator.isPlaying

        Button {
            tools.toggleToneGenerator()
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                    .font(IconTheme.actionButton)
                Text(isPlaying ? L10n.Tools.stopTone : L10n.Tools.generateTone)
                    .font(Typography.headlineValue)
            }
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                    .fill(isPlaying ? Color.red : appState.accentColor)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Hearing Age Sheet
    @ViewBuilder
    private var hearingAgeSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpacingTheme.cardStack) {
                    VStack(spacing: SpacingTheme.micro) {
                        Image(systemName: "hearingdevice.ear.fill")
                            .font(Typography.displayHero)
                            .foregroundStyle(appState.accentColor)
                            .padding(.bottom, SpacingTheme.micro)

                        Text(L10n.Tools.hearingAgeChallenge)
                            .font(Typography.title1)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))

                        Text(L10n.Tools.hearingAgeTip)
                            .font(Typography.badgeTag)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, SpacingTheme.standard)
                    }
                    .padding(.top, SpacingTheme.standard)

                    VStack(spacing: SpacingTheme.compact) {
                        hearingTestRow(freq: 8000, age: L10n.Tools.hearingAgeBracket(60))
                        hearingTestRow(freq: 12000, age: L10n.Tools.hearingAgeBracket(50))
                        hearingTestRow(freq: 14000, age: L10n.Tools.hearingAgeBracket(40))
                        hearingTestRow(freq: 16000, age: L10n.Tools.hearingAgeBracket(30))
                        hearingTestRow(freq: 17400, age: L10n.Tools.hearingAgeBracket(24))
                        hearingTestRow(freq: 19000, age: L10n.Tools.hearingAgeBracket(20))
                    }
                }
                .padding(SpacingTheme.cardStack)
            }
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if tools.toneGenerator.isPlaying {
                            tools.toggleToneGenerator()
                        }
                        showHearingTest = false
                    } label: {
                        Text(L10n.Common.done)
                            .font(Typography.calloutBold)
                            .foregroundStyle(appState.accentColor)
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    @ViewBuilder
    private func hearingTestRow(freq: Double, age: String) -> some View {
        let isCurrent = abs(tools.toneGenerator.frequencyHz - freq) < 1.0 && tools.toneGenerator.isPlaying

        Button {
            Haptics.selection()
            tools.setToneFrequency(freq)
            if !tools.toneGenerator.isPlaying {
                tools.toggleToneGenerator()
            }
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isCurrent ? "waveform" : "play.circle.fill")
                    .font(IconTheme.actionButton)
                    .foregroundStyle(isCurrent ? Color.red : appState.accentColor)

                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    Text("\(Int(freq)) Hz")
                        .font(Typography.bodyValueMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    Text(age)
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Spacer()

                if isCurrent {
                    Text(L10n.Tools.stopTone)
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(Color.red)
                } else {
                    Text(L10n.Tools.generateTone)
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(appState.accentColor)
                }
            }
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.7))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(isCurrent ? Color.red.opacity(0.5) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ToneGeneratorDetailView()
    }
}

