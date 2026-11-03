//
//  ToolsToneGeneratorCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  20Hz-20kHz Pure Tone Generator Bento Launcher Card.
//

import SwiftUI

struct ToolsToneGeneratorCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: ToneGeneratorDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: tools.toneGenerator.isPlaying ? Color.red : appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.toneGenerator,
                icon: "waveform.circle.fill",
                subtitle: L10n.Tools.toneGeneratorSub
            )

            Spacer()

            Text("\(Int(tools.toneGenerator.frequencyHz)) Hz")
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(tools.toneGenerator.isPlaying ? Color.red : appState.accentColor)
                .lineLimit(1)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Middle Status Row
    @ViewBuilder
    private var middleStatusRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(tools.toneGenerator.isPlaying ? Color.red : Theme.textTertiary(for: colorScheme))
                    .frame(width: 6, height: 6)

                Text(L10n.Tools.waveformTitle(tools.toneGenerator.waveform))
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(tools.toneGenerator.isPlaying ? L10n.Tools.soundPlaying : L10n.Tools.frequencyBandTitle(tools.toneGenerator.frequencyHz))
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsToneGeneratorCard()
        .padding()
}
