//
//  ToolsSpiritLevelCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Spirit Level Bento Launcher Card with live mini-reticle.
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
                miniReticleSection
                footerMetricRow
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

            // Status Badge
            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(tools.spiritLevel.isLevel ? Color.green : appState.accentColor)
                    .frame(width: 6, height: 6)

                Text(tools.spiritLevel.isLevel ? "0.0°" : String(format: "%.1f°", tools.spiritLevel.tiltDegrees))
                    .font(Typography.captionMono)
                    .foregroundStyle(tools.spiritLevel.isLevel ? Color.green : appState.accentColor)
                    .lineLimit(1)
            }
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.micro)
            .background((tools.spiritLevel.isLevel ? Color.green : appState.accentColor).opacity(0.12))
            .clipShape(Capsule())

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Mini Reticle Section
    @ViewBuilder
    private var miniReticleSection: some View {
        let isLevel = tools.spiritLevel.isLevel
        let activeColor = isLevel ? Color.green : appState.accentColor
        let rollClamped = max(-30.0, min(30.0, tools.spiritLevel.rollDegrees))
        let pitchClamped = max(-30.0, min(30.0, tools.spiritLevel.pitchDegrees))
        let offsetX = (rollClamped / 30.0) * 36.0
        let offsetY = (pitchClamped / 30.0) * 36.0

        HStack {
            Spacer()

            ZStack {
                Circle()
                    .strokeBorder(Theme.cardBorder(for: colorScheme), lineWidth: 1.5)
                    .frame(width: 100, height: 100)
                    .background(
                        Circle().fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
                    )

                Circle()
                    .strokeBorder(activeColor.opacity(isLevel ? 0.8 : 0.3), lineWidth: 1)
                    .frame(width: 36, height: 36)

                // Spirit Bubble
                Circle()
                    .fill(activeColor)
                    .frame(width: 26, height: 26)
                    .shadow(color: activeColor.opacity(isLevel ? 0.6 : 0.2), radius: 6)
                    .offset(x: isLevel ? 0 : offsetX, y: isLevel ? 0 : offsetY)
                    .animation(.spring(response: 0.25, dampingFraction: 0.75), value: tools.spiritLevel.tiltDegrees)
            }

            Spacer()
        }
        .padding(.vertical, SpacingTheme.micro)
    }

    // MARK: - Footer Metrics
    @ViewBuilder
    private var footerMetricRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            metricItem(title: L10n.Tools.rollAxis, value: String(format: "%+.1f°", tools.spiritLevel.rollDegrees))
            Spacer()
            metricItem(title: L10n.Tools.pitchAxis, value: String(format: "%+.1f°", tools.spiritLevel.pitchDegrees))
            Spacer()
            metricItem(title: L10n.Tools.slope, value: String(format: "%.1f%%", tools.spiritLevel.slopePercent))
        }
        .padding(.horizontal, SpacingTheme.compact)
    }

    @ViewBuilder
    private func metricItem(title: String, value: String) -> some View {
        VStack(spacing: SpacingTheme.micro) {
            Text(title)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
            Text(value)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsSpiritLevelCard()
        .padding()
}

