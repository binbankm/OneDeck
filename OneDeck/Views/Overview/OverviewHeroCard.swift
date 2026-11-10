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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            badgesRow
            BentoHairlineDivider()
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
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)

                FlowLayout(spacing: SpacingTheme.compact, rowSpacing: SpacingTheme.micro) {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: "cpu.fill")
                            .font(IconTheme.tileLeading)
                            .foregroundStyle(accentFg)
                            .accessibilityHidden(true)

                        Text(system.chipNameClean)
                            .font(Typography.calloutLabel)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }

                    Text("•")
                        .font(Typography.badgeTag)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        .accessibilityHidden(true)

                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: "clock.fill")
                            .font(IconTheme.tileLeading)
                            .foregroundStyle(accentFg)
                            .accessibilityHidden(true)

                        Text(system.uptimeFormatted)
                            .font(Typography.calloutLabel)
                            .monospacedDigit()
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(L10n.Overview.chip): \(system.chipNameClean), \(L10n.Overview.uptime): \(system.uptimeFormatted)")
            }

            Spacer(minLength: SpacingTheme.standard)

            ZStack {
                Circle()
                    .fill(appState.accentColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: UIDevice.current.userInterfaceIdiom == .pad ? "ipad.gen2" : "iphone.gen3")
                    .font(IconTheme.heroAvatar)
                    .foregroundStyle(accentFg)
            }
            .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private var badgesRow: some View {
        FlowLayout(spacing: SpacingTheme.compact, rowSpacing: SpacingTheme.tight) {
            badge(
                text: system.machineIdentifier,
                textColor: accentFg,
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

    @ViewBuilder
    private var hudRow: some View {
        let safeCpu = system.totalCpuUsage.isFinite ? system.totalCpuUsage : 0.0
        let cpuHighlight = safeCpu > 75 ? Theme.readableOrange(for: colorScheme) : accentFg
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        layout {
            hudMetricTile(
                icon: "cpu.fill",
                label: L10n.Overview.hudCpu,
                value: String(format: "%.0f%%", safeCpu),
                subtitle: L10n.Overview.hudCores(count: system.coreCount),
                highlight: cpuHighlight
            )

            hudMetricTile(
                icon: "memorychip.fill",
                label: L10n.Overview.memory,
                value: system.activeMemory.formattedBytes,
                subtitle: L10n.Overview.hudRamActive,
                highlight: accentFg
            )

            hudMetricTile(
                icon: "internaldrive.fill",
                label: L10n.Overview.hudStorageAvailable,
                value: system.availableDiskSpace.formattedBytes,
                subtitle: L10n.Overview.hudDiskFree,
                highlight: accentFg
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
            .padding(.vertical, SpacingTheme.tight)
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
                    .accessibilityHidden(true)
                Text(label)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
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
        .background(Theme.tileBackground(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
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
