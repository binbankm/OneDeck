//
//  BatteryHeroCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Hero Battery Telemetry Deck: Dynamic Level Capsule, Live State Pill, ETA & Energy Reserves.
//

import SwiftUI

struct BatteryHeroCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var battery = BatteryService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Row: Unified Section Header & Fast Charge Protocol Pill
            HStack(alignment: .center) {
                OverviewSectionHeader(title: L10n.Battery.batteryStatus, icon: "battery.100.bolt")

                Spacer()

                // State & Protocol Capsule
                HStack(spacing: 5) {
                    if battery.batteryState == .charging {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(activeStatusColor)
                    } else if battery.isLowPowerMode {
                        Image(systemName: "bolt.batteryblock.fill")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.yellow)
                    }

                    Text(battery.chargingProtocolName)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(activeStatusColor)
                        .lineLimit(1)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(activeStatusColor.opacity(0.14))
                .clipShape(Capsule())
            }

            // Big Metric & Level Progress Gauge
            VStack(spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(battery.batteryLevelPercent)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .foregroundStyle(activeStatusColor)

                    Text("%")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(activeStatusColor.opacity(0.85))

                    Spacer()

                    // Available Energy vs Total Capacity
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(L10n.Battery.remainingEnergy)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))

                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(battery.currentRemainingMah)")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))

                            Text("/ \(battery.effectiveDesignCapacityMah) mAh")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        }
                    }
                }

                // Dynamic Smooth Capsule Gauge
                GeometryReader { geo in
                    let w = geo.size.width
                    let fillW = max(10, w * CGFloat(battery.batteryLevel))

                    ZStack(alignment: .leading) {
                        // Background track
                        Capsule()
                            .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.06))

                        // Dynamic charge fill with gradient
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
                HStack(spacing: 5) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    Text(battery.etaCountdownString)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)

                    Spacer()

                    if battery.isLowPowerMode {
                        Text(L10n.Battery.protocolLowPower)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(.yellow)
                    }
                }
                .padding(.top, 2)
            }
        }
        .bentoCard(accent: activeStatusColor)
    }

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

