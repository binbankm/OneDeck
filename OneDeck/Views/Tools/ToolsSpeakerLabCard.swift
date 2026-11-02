//
//  ToolsSpeakerLabCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Bento Card launcher for Stereo Speaker & Audio Phase Diagnostics.
//

import SwiftUI

struct ToolsSpeakerLabCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: SpeakerLabDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                // Top Header Row
                headerRow

                // Middle Status Row
                middleStatusRow
            }
            .bentoCard(accent: appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header Row
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.speakerLab,
                icon: "speaker.wave.2.fill",
                subtitle: L10n.Tools.speakerLabSub
            )

            Spacer()

            Text(L10n.Tools.dualSpeaker)
                .font(Typography.captionMono)
                .foregroundStyle(appState.accentColor)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Middle Status Row
    @ViewBuilder
    private var middleStatusRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            HStack(spacing: SpacingTheme.compact) {
                Circle()
                    .fill(appState.accentColor)
                    .frame(width: 6, height: 6)

                Text(L10n.Tools.stereoSeparation)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            Spacer()

            Text(L10n.Tools.leftSpeaker + " · " + L10n.Tools.rightSpeaker)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsSpeakerLabCard()
        .padding()
}
