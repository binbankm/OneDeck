//
//  OverviewHeroCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Device identity, hardware badges, and real-time HUD metrics card.
//

import SwiftUI

struct OverviewHeroCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            badgesRow
            Divider().opacity(0.25)
            hudRow
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(system.marketingName)
                    .font(Typography.heroSubValue)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "cpu.fill")
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

                    Image(systemName: "clock.fill")
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(appState.accentColor)

                    Text(system.uptimeFormatted)
                        .font(Typography.calloutLabel)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
            }

            Spacer(minLength: SpacingTheme.standard)

            ZStack {
                Circle()
                    .fill(appState.accentColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: UIDevice.current.userInterfaceIdiom == .pad ? "ipad.gen2" : "iphone.gen3")
                    .font(IconTheme.heroAvatar)
                    .foregroundStyle(appState.accentColor)
            }
        }
    }

    @ViewBuilder
    private var badgesRow: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: SpacingTheme.compact) {
                badge(
                    text: system.machineIdentifier,
                    textColor: appState.accentColor,
                    bgColor: appState.accentColor.opacity(0.12),
                    isMonospaced: true
                )

                badge(
                    text: system.osVersion,
                    textColor: Theme.textSecondary(for: colorScheme),
                    bgColor: Theme.chipBackground(for: colorScheme),
                    isMonospaced: true
                )

                badge(
                    text: system.salesTypeDescription,
                    textColor: Theme.textSecondary(for: colorScheme),
                    bgColor: Theme.chipBackground(for: colorScheme),
                    isMonospaced: false
                )
            }

            FlowLayout(spacing: SpacingTheme.compact, rowSpacing: SpacingTheme.tight) {
                badge(
                    text: system.machineIdentifier,
                    textColor: appState.accentColor,
                    bgColor: appState.accentColor.opacity(0.12),
                    isMonospaced: true
                )

                badge(
                    text: system.osVersion,
                    textColor: Theme.textSecondary(for: colorScheme),
                    bgColor: Theme.chipBackground(for: colorScheme),
                    isMonospaced: true
                )

                badge(
                    text: system.salesTypeDescription,
                    textColor: Theme.textSecondary(for: colorScheme),
                    bgColor: Theme.chipBackground(for: colorScheme),
                    isMonospaced: false
                )
            }
        }
    }

    @ViewBuilder
    private var hudRow: some View {
        let safeCpu = system.totalCpuUsage.isFinite ? system.totalCpuUsage : 0.0
        HStack(spacing: SpacingTheme.standard) {
            hudMetricTile(
                icon: "cpu.fill",
                label: "CPU",
                value: String(format: "%.0f%%", safeCpu),
                subtitle: "\(system.coreCount) " + L10n.Overview.hudCoresSuffix,
                highlight: safeCpu > 75 ? .orange : appState.accentColor
            )

            hudMetricTile(
                icon: "memorychip.fill",
                label: "RAM",
                value: system.activeMemory.formattedBytes,
                subtitle: L10n.Overview.hudRamActive,
                highlight: appState.accentColor
            )

            hudMetricTile(
                icon: "internaldrive.fill",
                label: L10n.Overview.hudStorageAvailable,
                value: system.availableDiskSpace.formattedBytes,
                subtitle: L10n.Overview.hudDiskFree,
                highlight: appState.accentColor
            )
        }
    }

    // MARK: - Tile & Badge Helpers
    @ViewBuilder
    private func badge(text: String, textColor: Color, bgColor: Color, isMonospaced: Bool) -> some View {
        Text(text)
            .font(isMonospaced ? Typography.badgeTagMono : Typography.badgeTag)
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .padding(.horizontal, SpacingTheme.standard)
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
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue("\(value), \(subtitle)")
    }
}

// MARK: - Preview
#Preview {
    OverviewHeroCard()
        .padding()
}
