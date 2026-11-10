//
//  ToneGeneratorDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Pure audio sine wave synthesizer and frequency sweep workspace.
//

import SwiftUI

struct ToneGeneratorDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // Presets
    private let quickPresets: [Double] = [60.0, 165.0, 440.0, 1000.0, 8000.0, 15000.0]

    // State
    @State private var showHearingTest: Bool = false

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    // Waveform Selector
                    waveformPickerBar

                    Spacer(minLength: SpacingTheme.standard)

                    // Center Frequency Wheel / Readout
                    frequencyCenterReadout

                    Spacer(minLength: SpacingTheme.standard)

                    // Frequency Slider & Steppers
                    frequencySliderSection

                    // Quick Presets
                    presetsRow

                    // Master Play / Stop Button
                    playToggleButton
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .frame(maxWidth: .infinity, minHeight: geo.size.height)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.toneGenerator)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .toneGenerator)
        }
        .onDisappear {
            tools.stopToneGenerator()
            tools.leaveDetailView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Haptics.selection()
                    showHearingTest = true
                } label: {
                    Image(systemName: "hearingdevice.ear.fill")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(accentFg)
                }
                .accessibilityLabel(L10n.Tools.hearingAgeChallenge)
            }
        }
        .sheet(isPresented: $showHearingTest) {
            hearingAgeSheet
        }
    }

    // MARK: - Waveform Picker
    @ViewBuilder
    private var waveformPickerBar: some View {
        Picker(L10n.Tools.waveformType, selection: Binding(
            get: { tools.toneGenerator.waveform },
            set: { tools.setToneWaveform($0) }
        )) {
            ForEach(ToneWaveform.allCases) { wave in
                Text(L10n.Tools.waveformTitle(wave)).tag(wave)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .accessibilityLabel(L10n.Tools.waveformType)
    }

    // MARK: - Frequency Center Readout
    @ViewBuilder
    private var frequencyCenterReadout: some View {
        let safeFreq = tools.toneGenerator.frequencyHz.isFinite ? tools.toneGenerator.frequencyHz : 440.0
        let freqString = String(format: safeFreq >= 1000 ? "%.0f" : "%.1f", safeFreq)
        let bandTitle = L10n.Tools.frequencyBandTitle(safeFreq)

        VStack(spacing: SpacingTheme.micro) {
            Text(freqString)
                .font(Typography.displayHero)
                .monospacedDigit()
                .contentTransition(.numericText())
                .foregroundStyle(tools.toneGenerator.isPlaying ? accentFg : Theme.textTertiary(for: colorScheme))

            Text(L10n.Tools.hertzUnit)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            Text(bandTitle)
                .font(Typography.caption)
                .foregroundStyle(accentFg)
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.micro)
                .background(accentFg.opacity(0.14))
                .clipShape(Capsule())
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Tools.hertzUnit)
        .accessibilityValue("\(freqString) Hz, \(bandTitle)")
    }

    // MARK: - Frequency Slider
    @ViewBuilder
    private var frequencySliderSection: some View {
        let safeFreq = tools.toneGenerator.frequencyHz.isFinite ? tools.toneGenerator.frequencyHz : 440.0
        let freqDisplay = safeFreq >= 1000 ? String(format: "%.0f Hz", safeFreq) : String(format: "%.1f Hz", safeFreq)

        VStack(spacing: SpacingTheme.compact) {
            // Logarithmic mapping for smooth acoustic exploration
            Slider(value: Binding(
                get: { log10(min(20000.0, max(20.0, safeFreq))) },
                set: { tools.setToneFrequency(pow(10.0, $0)) }
            ), in: log10(20.0) ... log10(20000.0))
                .tint(accentFg)
                .padding(.horizontal, SpacingTheme.standard)
                .accessibilityLabel(L10n.Tools.hertzUnit)
                .accessibilityValue(freqDisplay)

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
        let safeFreq = tools.toneGenerator.frequencyHz.isFinite ? tools.toneGenerator.frequencyHz : 440.0
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: SpacingTheme.compact),
            count: dynamicTypeSize.isAccessibilitySize ? 3 : 6
        )

        LazyVGrid(columns: columns, spacing: SpacingTheme.compact) {
            ForEach(quickPresets, id: \.self) { freq in
                let isSelected = abs(safeFreq - freq) < 1.0

                Button {
                    Haptics.selection()
                    tools.setToneFrequency(freq)
                } label: {
                    Text(freq >= 1000 ? "\(Int(freq / 1000))k" : "\(Int(freq))")
                        .font(Typography.badgeTagMonoMedium)
                        .foregroundStyle(isSelected ? Theme.contrastingForeground(for: appState.accentColor) : Theme.textPrimary(for: colorScheme))
                        .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .fill(isSelected ? appState.accentColor : Theme.chipBackground(for: colorScheme))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .stroke(isSelected ? appState.accentColor : Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(freq >= 1000 ? "\(Int(freq / 1000)) kHz" : "\(Int(freq)) Hz")
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        }
    }

    // MARK: - Master Play/Stop Button
    @ViewBuilder
    private var playToggleButton: some View {
        let isPlaying = tools.toneGenerator.isPlaying
        let buttonBg = isPlaying ? Theme.readableRed(for: colorScheme) : appState.accentColor

        Button {
            tools.toggleToneGenerator()
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(isPlaying ? L10n.Tools.stopTone : L10n.Tools.generateTone)
                    .font(Typography.headlineValue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(Theme.contrastingForeground(for: buttonBg))
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                    .fill(buttonBg)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
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
                            .foregroundStyle(accentFg)
                            .padding(.bottom, SpacingTheme.micro)
                            .accessibilityHidden(true)

                        Text(L10n.Tools.hearingAgeChallenge)
                            .font(Typography.title1)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .multilineTextAlignment(.center)

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
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .frame(maxWidth: .infinity)
                .padding(SpacingTheme.cardStack)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Haptics.selection()
                        if tools.toneGenerator.isPlaying {
                            tools.stopToneGenerator()
                        }
                        showHearingTest = false
                    } label: {
                        Text(L10n.Common.done)
                            .font(Typography.calloutBold)
                            .foregroundStyle(accentFg)
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .onDisappear {
            if tools.toneGenerator.isPlaying {
                tools.stopToneGenerator()
            }
        }
    }

    @ViewBuilder
    private func hearingTestRow(freq: Double, age: String) -> some View {
        let isCurrent = abs(tools.toneGenerator.frequencyHz - freq) < 1.0 && tools.toneGenerator.isPlaying
        let redAccent = Theme.readableRed(for: colorScheme)

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
                    .foregroundStyle(isCurrent ? redAccent : accentFg)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    Text("\(Int(freq)) Hz")
                        .font(Typography.bodyValueMono)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    Text(age)
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Spacer()

                if isCurrent {
                    Text(L10n.Tools.stopTone)
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(redAccent)
                } else {
                    Text(L10n.Tools.generateTone)
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(accentFg)
                }
            }
            .padding(.horizontal, SpacingTheme.rowStandard)
            .padding(.vertical, SpacingTheme.row)
            .frame(minHeight: LayoutTheme.minTapTarget)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.tileBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(isCurrent ? redAccent.opacity(0.5) : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityAddTraits(isCurrent ? .isSelected : [])
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ToneGeneratorDetailView()
    }
}
