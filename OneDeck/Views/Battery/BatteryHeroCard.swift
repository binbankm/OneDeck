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
                    Image(systemName: "battery.100.bolt")
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

            // Dynamic Smooth Capsule Gauge (GPU Accelerated Transform)
            let clampedLevel = min(1.0, max(0.0, battery.batteryLevel.isFinite ? Double(battery.batteryLevel) : 0.0))

            Capsule()
                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06))
                .overlay(alignment: .leading) {
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
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.15), lineWidth: 0.5)
                        )
                        .scaleEffect(x: max(0.02, CGFloat(clampedLevel)), y: 1.0, anchor: .leading)
                }
                .clipShape(Capsule())
                .frame(height: 18)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: battery.batteryLevel)

            // ETA & Live Power Sub-row
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "clock.fill")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                Text(battery.etaCountdownString)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: SpacingTheme.compact)

                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: battery.batteryState == .charging ? "bolt.fill" : "bolt.badge.automatic.fill")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(activeStatusColor)
                    Text(String(format: "%+.1f W", battery.liveWattage))
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
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
