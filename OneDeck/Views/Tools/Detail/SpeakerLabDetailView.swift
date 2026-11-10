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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - State
    @State private var activeFrequency: Double = 1000.0

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

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
            .frame(maxWidth: LayoutTheme.maxContentWidth)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.speakerLab)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .speakerLab)
        }
        .onDisappear {
            tools.stopSpeakerTest()
            tools.leaveDetailView()
        }
    }

    // MARK: - Visual Speaker Diagram
    @ViewBuilder
    private var speakerDiagramCard: some View {
        let isPlaying = tools.isSpeakerTesting
        let activeChannel = tools.speakerChannel
        let isLeftActive = isPlaying && (activeChannel == .left || activeChannel == .stereo)
        let isRightActive = isPlaying && (activeChannel == .right || activeChannel == .stereo)

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.cardStack))

        layout {
            speakerDiagramTile(
                title: L10n.Tools.leftSpeaker,
                isActive: isLeftActive
            )

            speakerDiagramTile(
                title: L10n.Tools.rightSpeaker,
                isActive: isRightActive
            )
        }
        .bentoCard(accent: appState.accentColor)
    }

    @ViewBuilder
    private func speakerDiagramTile(title: String, isActive: Bool) -> some View {
        VStack(spacing: SpacingTheme.micro) {
            Image(systemName: "speaker.wave.3.fill")
                .font(IconTheme.prominentAction)
                .foregroundStyle(isActive ? accentFg : Theme.textTertiary(for: colorScheme))
                .accessibilityHidden(true)

            Text(title)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SpacingTheme.rowStandard)
        .padding(.horizontal, SpacingTheme.tight)
        .background(Theme.tileBackground(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .stroke(isActive ? accentFg.opacity(0.45) : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }

    // MARK: - Channel Isolation Section
    @ViewBuilder
    private var channelIsolationSection: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.compact))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.compact))

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.speakerLab,
                icon: "arrow.left.and.right.square.fill",
                subtitle: L10n.Tools.stereoSeparation
            )

            layout {
                channelButton(title: L10n.Tools.leftOnly, channel: .left)
                channelButton(title: L10n.Tools.dualSpeaker, channel: .stereo)
                channelButton(title: L10n.Tools.rightOnly, channel: .right)
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    @ViewBuilder
    private func channelButton(title: String, channel: SpeakerChannel) -> some View {
        let isSelected = tools.speakerChannel == channel && tools.isSpeakerTesting

        Button {
            tools.playSpeakerTest(channel: channel, frequency: activeFrequency)
        } label: {
            Text(title)
                .font(Typography.badgeTagMono)
                .foregroundStyle(isSelected ? Theme.contrastingForeground(for: appState.accentColor) : Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                .padding(.horizontal, SpacingTheme.compact)
                .background(isSelected ? appState.accentColor : Theme.tileBackground(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                        .stroke(isSelected ? appState.accentColor : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityAddTraits(isSelected ? .isSelected : [])
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
                    let isSelected = abs(activeFrequency - item.freq) < 1.0

                    Button {
                        activeFrequency = item.freq
                        if tools.isSpeakerTesting {
                            tools.playSpeakerTest(channel: tools.speakerChannel, frequency: activeFrequency)
                        } else {
                            Haptics.selection()
                        }
                    } label: {
                        HStack {
                            Text(item.title)
                                .font(Typography.captionMono)
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))

                            Spacer()

                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(IconTheme.badgeInline)
                                    .foregroundStyle(accentFg)
                                    .accessibilityHidden(true)
                            }
                        }
                        .padding(.horizontal, SpacingTheme.rowStandard)
                        .frame(minHeight: LayoutTheme.minTapTarget)
                        .background(Theme.tileBackground(for: colorScheme))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .stroke(isSelected ? accentFg : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Primary Toggle Button
    @ViewBuilder
    private var primaryToggleButton: some View {
        let isPlaying = tools.isSpeakerTesting
        let buttonBg = isPlaying ? Theme.readableRed(for: colorScheme) : appState.accentColor

        Button {
            if isPlaying {
                Haptics.selection()
                tools.stopSpeakerTest()
            } else {
                tools.playSpeakerTest(channel: tools.speakerChannel, frequency: activeFrequency)
            }
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(isPlaying ? L10n.Tools.stopTone : L10n.Tools.playChannelTest)
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
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SpeakerLabDetailView()
    }
}
