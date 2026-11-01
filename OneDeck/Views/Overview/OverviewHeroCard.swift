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
        VStack(alignment: .leading, spacing: 12) {
            // Header Row: Marketing Name & Chip + Device Graphic Platter
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(system.marketingName)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    HStack(spacing: 5) {
                        Image(systemName: "cpu")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(appState.accentColor)

                        Text(system.chipName)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)

                        Text("•")
                            .font(.system(size: 10))
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))

                        Image(systemName: "clock")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(appState.accentColor)

                        Text(system.uptimeFormatted)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 8)

                ZStack {
                    Circle()
                        .fill(appState.accentColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: "iphone.gen3")
                        .font(.system(size: 22, weight: .semibold))
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
                    text: system.osVersion,
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
            .font(.system(size: 10, weight: isMonospaced ? .bold : .medium, design: isMonospaced ? .monospaced : .default))
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(bgColor)
            .foregroundStyle(textColor)
            .clipShape(Capsule())
    }

    @ViewBuilder
    private func hudMetricTile(icon: String, label: String, value: String, subtitle: String, highlight: Color) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(highlight)
                Text(label)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            Text(value)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .contentTransition(.numericText())
                .foregroundStyle(Theme.textPrimary(for: colorScheme))

            Text(subtitle)
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 9)
        .padding(.vertical, 8)
        .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

