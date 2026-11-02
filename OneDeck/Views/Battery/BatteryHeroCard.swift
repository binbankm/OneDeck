//
//  BatteryHeroCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Hero Battery Telemetry Deck: Dynamic Level Capsule, Live State Pill, ETA & Energy Reserves.
//

import SwiftUI

struct BatteryHeroCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
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
        HStack(alignment: .center) {
            OverviewSectionHeader(title: L10n.Battery.batteryStatus, icon: "battery.100.bolt")

            Spacer()

            // State & Protocol Capsule
            HStack(spacing: SpacingTheme.tight) {
                if battery.batteryState == .charging {
                    Image(systemName: "bolt.fill")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(activeStatusColor)
                } else if battery.isLowPowerMode {
                    Image(systemName: "bolt.batteryblock.fill")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(.yellow)
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
        }
    }

    @ViewBuilder
    private var gaugeSection: some View {
        VStack(spacing: SpacingTheme.row) {
            HStack(alignment: .firstTextBaseline) {
                Text("\(battery.batteryLevelPercent)")
                    .font(Typography.displayHero)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(activeStatusColor)

                Text("%")
                    .font(Typography.title1)
                    .foregroundStyle(activeStatusColor.opacity(0.85))

                Spacer()

                // Available Energy vs Total Capacity
                VStack(alignment: .trailing, spacing: SpacingTheme.micro) {
                    Text(L10n.Battery.remainingEnergy)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                    HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                        Text("\(battery.currentRemainingMah)")
                            .font(Typography.headlineValue)
                            .monospacedDigit()
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))

                        Text("/ \(battery.effectiveDesignCapacityMah) mAh")
                            .font(Typography.calloutLabel)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    }
                }
            }

            // Dynamic Smooth Capsule Gauge
            GeometryReader { geo in
                let w = geo.size.width
                let fillW = max(10, w * CGFloat(battery.batteryLevel))

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    activeStatusColor,
                                    activeStatusColor.opacity(0.75)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: fillW)
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                        )
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: battery.batteryLevel)
            }
            .frame(height: 18)

            // ETA Status Sub-row
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                Text(battery.etaCountdownString)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)

                Spacer()

                if battery.isLowPowerMode {
                    Text(L10n.Battery.protocolLowPower)
                        .font(Typography.captionBold)
                        .foregroundStyle(.yellow)
                }
            }
            .padding(.top, SpacingTheme.micro)
        }
    }

    // MARK: - Dynamic Status Color
    private var activeStatusColor: Color {
        if battery.isLowPowerMode {
            return .yellow
        }
        if battery.batteryLevel <= 0.20 && battery.batteryState != .charging {
            return .red
        }
        if battery.batteryState == .charging {
            return appState.accentColor
        }
        return appState.accentColor
    }
}

// MARK: - Preview
#Preview {
    BatteryHeroCard()
        .padding()
}
