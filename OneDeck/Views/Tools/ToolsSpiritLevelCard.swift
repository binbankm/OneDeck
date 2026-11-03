//
//  ToolsSpiritLevelCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Spirit Level Bento Launcher Card - Clean 2-row Bento standard.
//

import SwiftUI

struct ToolsSpiritLevelCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: SpiritLevelDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: tools.spiritLevel.isLevel ? Color.green : appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.spiritLevel,
                icon: "angle",
                subtitle: L10n.Tools.spiritLevelSub
            )

            Spacer()

            // Status Value Readout
            Text(tools.spiritLevel.isLevel ? "0.0°" : String(format: "%.1f°", tools.spiritLevel.tiltDegrees))
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(tools.spiritLevel.isLevel ? Color.green : appState.accentColor)
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
                    .fill(tools.spiritLevel.isLevel ? Color.green : appState.accentColor)
                    .frame(width: 6, height: 6)

                Text(tools.spiritLevel.isLevel ? L10n.Tools.levelBalanced : String(format: "%@ %+.1f°", L10n.Tools.rollAxis, tools.spiritLevel.rollDegrees))
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            Text(String(format: "%@ %+.1f° · %@ %.1f%%", L10n.Tools.pitchAxis, tools.spiritLevel.pitchDegrees, L10n.Tools.slope, tools.spiritLevel.slopePercent))
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsSpiritLevelCard()
        .padding()
}
