//
//  BatteryHeroCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Battery level gauge, charging state pill, and power throughput card.
//

import SwiftUI

struct BatteryHeroCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            gaugeSection
        }
        .bentoCard(accent: activeStatusColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            OverviewSectionHeader(title: L10n.Battery.batteryStatus, icon: "battery.100.bolt")
                .layoutPriority(1)

            Spacer(minLength: SpacingTheme.compact)

            // State & Protocol Capsule
            HStack(spacing: SpacingTheme.tight) {
                if battery.isPluggedIn {
                    Image(systemName: "bolt.fill")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(activeStatusColor)
                        .accessibilityHidden(true)
                } else if battery.isLowPowerMode {
                    Image(systemName: "battery.100.bolt")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(Theme.readableYellow(for: colorScheme))
                        .accessibilityHidden(true)
                }

                Text(battery.chargingProtocolName)
                    .font(Typography.captionBold)
                    .foregroundStyle(activeStatusColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.tight)
            .background(activeStatusColor.opacity(0.14))
            .clipShape(Capsule())
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(L10n.Battery.chargerProtocol): \(battery.chargingProtocolName)")
        }
    }

    @ViewBuilder
    private var gaugeSection: some View {
        let clampedLevel = min(1.0, max(0.0, battery.batteryLevel.isFinite ? Double(battery.batteryLevel) : 0.0))

        VStack(alignment: .leading, spacing: SpacingTheme.row) {
            Group {
                if dynamicTypeSize.isAccessibilitySize {
                    VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                        batteryPercentReadout
                        remainingCapacityReadout(alignment: .leading)
                    }
                } else {
                    HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.standard) {
                        batteryPercentReadout
                        Spacer(minLength: SpacingTheme.compact)
                        remainingCapacityReadout(alignment: .trailing)
                    }
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Battery.batteryStatus)
            .accessibilityValue(
                battery.isBatteryLevelAvailable
                    ? "\(battery.batteryLevelPercent)%, \(battery.currentRemainingMah) / \(battery.effectiveDesignCapacityMah) mAh"
                    : L10n.Battery.unavailableReading
            )

            // Non-distorting Smooth Capsule Gauge
            GeometryReader { geo in
                let fillWidth = max(0, geo.size.width * clampedLevel)
                let minVisibleWidth = min(geo.size.width, max(18, fillWidth))

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Theme.chipBackground(for: colorScheme))

                    if battery.isBatteryLevelAvailable && clampedLevel > 0 {
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        activeStatusColor,
                                        activeStatusColor.opacity(0.78)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.18), lineWidth: 0.5)
                            )
                            .frame(width: minVisibleWidth)
                    }
                }
            }
            .frame(height: 18)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: battery.batteryLevel)
            .accessibilityHidden(true)

            // ETA & Live Power Sub-row
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    etaRow
                    wattageRow
                }
                .padding(.top, SpacingTheme.micro)
            } else {
                HStack(spacing: SpacingTheme.tight) {
                    etaRow
                    Spacer(minLength: SpacingTheme.compact)
                    wattageRow
                }
                .padding(.top, SpacingTheme.micro)
            }
        }
    }

    @ViewBuilder
    private var batteryPercentReadout: some View {
        HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
            Text(battery.isBatteryLevelAvailable ? "\(battery.batteryLevelPercent)" : "--")
                .font(Typography.displayHero)
                .monospacedDigit()
                .contentTransition(.numericText())
                .foregroundStyle(activeStatusColor)

            if battery.isBatteryLevelAvailable {
                Text("%")
                    .font(Typography.title1)
                    .foregroundStyle(activeStatusColor.opacity(0.85))
            } else {
                Text(L10n.Battery.unavailableReading)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .padding(.leading, SpacingTheme.tight)
            }
        }
    }

    @ViewBuilder
    private func remainingCapacityReadout(alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: SpacingTheme.micro) {
            Text(L10n.Battery.remainingEnergy)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                Text(battery.isBatteryLevelAvailable ? "\(battery.currentRemainingMah)" : "--")
                    .font(Typography.headlineValue)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Text("/ \(battery.effectiveDesignCapacityMah) mAh")
                    .font(Typography.calloutLabel)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
        }
    }

    @ViewBuilder
    private var etaRow: some View {
        HStack(spacing: SpacingTheme.tight) {
            Image(systemName: "clock.fill")
                .font(IconTheme.tileLeading)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .accessibilityHidden(true)

            Text(battery.etaCountdownString)
                .font(Typography.calloutLabel)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var wattageRow: some View {
        let wattValue = String(format: "%+.1f W", battery.liveWattage.isFinite ? battery.liveWattage : 0.0)

        HStack(spacing: SpacingTheme.tight) {
            Image(systemName: battery.isPluggedIn ? "bolt.fill" : "bolt.badge.automatic.fill")
                .font(IconTheme.badgeInline)
                .foregroundStyle(activeStatusColor)
                .accessibilityHidden(true)

            Text(wattValue)
                .font(Typography.captionMono)
                .monospacedDigit()
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Battery.livePowerTitle)
        .accessibilityValue(wattValue)
    }

    // MARK: - Dynamic Status Color
    private var activeStatusColor: Color {
        if battery.isPluggedIn {
            return Theme.readableAccent(appState.accentColor, for: colorScheme)
        }
        if battery.isLowPowerMode {
            return Theme.readableYellow(for: colorScheme)
        }
        if battery.isBatteryLevelAvailable && battery.batteryLevel <= 0.20 {
            return Theme.readableRed(for: colorScheme)
        }
        return Theme.readableAccent(appState.accentColor, for: colorScheme)
    }
}

// MARK: - Preview
#Preview {
    BatteryHeroCard()
        .padding()
}
