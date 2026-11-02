//
//  OverviewHeroCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Hero Device Deck: Marketing Identity, Hardware Badges & 3-Metric Quick HUD.
//

import SwiftUI

struct OverviewHeroCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var system = SystemService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            // Header Row: Marketing Name & Chip + Device Graphic Platter
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(system.marketingName)
                        .font(Typography.heroSubValue)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: "cpu")
                            .font(IconTheme.tileLeading)
                            .foregroundStyle(appState.accentColor)

                        Text(system.chipNameClean)
                            .font(Typography.calloutLabel)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)

                        Text("•")
                            .font(Typography.badgeTag)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))

                        Image(systemName: "clock")
                            .font(IconTheme.tileLeading)
                            .foregroundStyle(appState.accentColor)

                        Text(system.uptimeFormatted)
                            .font(Typography.calloutLabel)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }

                Spacer(minLength: 8)

                ZStack {
                    Circle()
                        .fill(appState.accentColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: "iphone.gen3")
                        .font(IconTheme.heroAvatar)
                        .foregroundStyle(appState.accentColor)
                }
            }

            // Dedicated Micro-Badges Row (Zero Horizontal Overflow)
            HStack(spacing: 6) {
                badge(
                    text: system.machineIdentifier,
                    textColor: appState.accentColor,
                    bgColor: appState.accentColor.opacity(0.16),
                    isMonospaced: true
                )

                badge(
                    text: system.osVersionWithBuild,
                    textColor: Theme.textSecondary(for: colorScheme),
                    bgColor: colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.05),
                    isMonospaced: true
                )

                badge(
                    text: system.salesTypeDescription,
                    textColor: Theme.textTertiary(for: colorScheme),
                    bgColor: colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.03),
                    isMonospaced: false
                )

                Spacer(minLength: 0)
            }

            Divider().opacity(0.25)

            // 3-Metric Quick HUD (CPU / RAM / Disk Free)
            HStack(spacing: 8) {
                hudMetricTile(
                    icon: "cpu",
                    label: "CPU",
                    value: String(format: "%.0f%%", system.totalCpuUsage),
                    subtitle: "\(system.coreCount) " + L10n.Overview.hudCoresSuffix,
                    highlight: system.totalCpuUsage > 75 ? .orange : appState.accentColor
                )

                hudMetricTile(
                    icon: "memorychip",
                    label: "RAM",
                    value: system.activeMemory.formattedBytes,
                    subtitle: L10n.Overview.hudRamActive,
                    highlight: appState.accentColor
                )

                hudMetricTile(
                    icon: "internaldrive",
                    label: L10n.Overview.hudStorageAvailable,
                    value: system.availableDiskSpace.formattedBytes,
                    subtitle: L10n.Overview.hudDiskFree,
                    highlight: appState.accentColor
                )
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private func badge(text: String, textColor: Color, bgColor: Color, isMonospaced: Bool) -> some View {
        Text(text)
            .font(isMonospaced ? Typography.badgeTagMono : Typography.badgeTag)
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .padding(.horizontal, 8)
            .padding(.vertical, SpacingTheme.micro)
            .background(bgColor)
            .foregroundStyle(textColor)
            .clipShape(Capsule())
    }

    @ViewBuilder
    private func hudMetricTile(icon: String, label: String, value: String, subtitle: String, highlight: Color) -> some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: icon)
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(highlight)
                Text(label)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            Text(value)
                .font(Typography.bodyValue)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .contentTransition(.numericText())
                .foregroundStyle(Theme.textPrimary(for: colorScheme))

            Text(subtitle)
                .font(Typography.badgeTag)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
    }
}

