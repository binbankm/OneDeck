//
//  SpeakerLabDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Stereo acoustic channel separation and frequency response workspace.
//

import SwiftUI

struct SpeakerLabDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - State
    @State private var activeFrequency: Double = 1000.0
    @State private var isPlaying: Bool = false
    @State private var activeChannel: SpeakerChannel = .stereo

    // Frequency Presets
    private var testFrequencies: [(title: String, freq: Double)] {
        [
            (L10n.Tools.speakerFreqPresetTitle(250.0), 250.0),
            (L10n.Tools.speakerFreqPresetTitle(1000.0), 1000.0),
            (L10n.Tools.speakerFreqPresetTitle(4000.0), 4000.0),
            (L10n.Tools.speakerFreqPresetTitle(10000.0), 10000.0)
        ]
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { _ in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    // Visual Hardware Speaker Diagram
                    speakerDiagramCard

                    // Section 1: Channel Isolation Buttons
                    channelIsolationSection

                    // Section 2: Frequency Selector
                    frequencySelectorSection

                    // Master Stop / Play Button
                    primaryToggleButton
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
            }
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.speakerLab)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView()
        }
        .onDisappear {
            tools.leaveDetailView()
            stopAudio()
        }
    }

    // MARK: - Visual Speaker Diagram
    @ViewBuilder
    private var speakerDiagramCard: some View {
        VStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.cardStack) {
                // Left / Top Speaker Indicator
                VStack(spacing: SpacingTheme.micro) {
                    Image(systemName: "speaker.wave.3.fill")
                        .font(IconTheme.prominentAction)
                        .foregroundStyle(isPlaying && (activeChannel == .left || activeChannel == .stereo) ? appState.accentColor : Theme.textTertiary(for: colorScheme))

                    Text(L10n.Tools.leftSpeaker)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, SpacingTheme.rowStandard)
                .background(Theme.cardBackground(for: colorScheme).opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))

                // Right / Bottom Speaker Indicator
                VStack(spacing: SpacingTheme.micro) {
                    Image(systemName: "speaker.wave.3.fill")
                        .font(IconTheme.prominentAction)
                        .foregroundStyle(isPlaying && (activeChannel == .right || activeChannel == .stereo) ? appState.accentColor : Theme.textTertiary(for: colorScheme))

                    Text(L10n.Tools.rightSpeaker)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, SpacingTheme.rowStandard)
                .background(Theme.cardBackground(for: colorScheme).opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Channel Isolation Section
    @ViewBuilder
    private var channelIsolationSection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.speakerLab,
                icon: "arrow.left.and.right.square.fill",
                subtitle: L10n.Tools.stereoSeparation
            )

            HStack(spacing: SpacingTheme.compact) {
                channelButton(title: L10n.Tools.leftOnly, channel: .left)
                channelButton(title: L10n.Tools.dualSpeaker, channel: .stereo)
                channelButton(title: L10n.Tools.rightOnly, channel: .right)
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    @ViewBuilder
    private func channelButton(title: String, channel: SpeakerChannel) -> some View {
        let isSelected = activeChannel == channel && isPlaying

        Button {
            activeChannel = channel
            playAudio()
        } label: {
            Text(title)
                .font(Typography.badgeTagMono)
                .foregroundStyle(isSelected ? Color.white : Theme.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity)
                .padding(.vertical, SpacingTheme.rowStandard)
                .background(isSelected ? appState.accentColor : Theme.cardBackground(for: colorScheme).opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                        .stroke(isSelected ? appState.accentColor : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Frequency Selector Section
    @ViewBuilder
    private var frequencySelectorSection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.diaphragmResonance,
                icon: "waveform",
                subtitle: L10n.Tools.diaphragmResonanceSub
            )

            VStack(spacing: SpacingTheme.compact) {
                ForEach(testFrequencies, id: \.title) { item in
                    Button {
                        activeFrequency = item.freq
                        if isPlaying {
                            playAudio()
                        }
                    } label: {
                        HStack {
                            Text(item.title)
                                .font(Typography.captionMono)
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))

                            Spacer()

                            if abs(activeFrequency - item.freq) < 1.0 {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(IconTheme.badgeInline)
                                    .foregroundStyle(appState.accentColor)
                            }
                        }
                        .padding(SpacingTheme.rowStandard)
                        .background(Theme.cardBackground(for: colorScheme).opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .stroke(abs(activeFrequency - item.freq) < 1.0 ? appState.accentColor : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Primary Toggle Button
    @ViewBuilder
    private var primaryToggleButton: some View {
        Button {
            if isPlaying {
                stopAudio()
            } else {
                playAudio()
            }
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                    .font(IconTheme.actionButton)
                Text(isPlaying ? L10n.Tools.stopTone : L10n.Tools.playChannelTest)
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

    // MARK: - Audio Intent Helpers (MVVM Delegated)
    private func playAudio() {
        isPlaying = true
        tools.playSpeakerTest(channel: activeChannel, frequency: activeFrequency)
    }

    private func stopAudio() {
        isPlaying = false
        tools.stopSpeakerTest()
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SpeakerLabDetailView()
    }
}
