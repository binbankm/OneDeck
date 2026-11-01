//
//  BatteryView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Battery Tab: Cycle Count, Real Capacity, Live Wattage & Fast Charge Protocol.
//

import SwiftUI

struct BatteryView: View {
    @Bindable var appState = AppState.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 16) {
                        // MARK: - Hero Battery Status
                        VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(L10n.Battery.chargingStatus)
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                Text(L10n.Battery.charging)
                                    .font(.system(.title2, design: .rounded, weight: .bold))
                                    .foregroundStyle(appState.accentColor)
                            }
                            Spacer()
                            // Live Wattage Badge
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("21.8 W")
                                    .font(.system(.title, design: .rounded, weight: .bold))
                                    .monospacedDigit()
                                    .foregroundStyle(appState.accentColor)
                                Text("USB-PD 27W 快充")
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(appState.accentColor.opacity(0.15))
                                    .foregroundStyle(appState.accentColor)
                                    .clipShape(Capsule())
                            }
                        }

                        // Big Level Bar
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.05))
                                .frame(height: 28)
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [appState.accentColor, appState.accentColor.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 220, height: 28)
                                .overlay(alignment: .trailing) {
                                    Text("78%")
                                        .font(.system(size: 13, weight: .bold, design: .rounded))
                                        .foregroundStyle(.black)
                                        .padding(.trailing, 10)
                                }
                        }
                    }
                    .bentoCard(accent: appState.accentColor)

                    // MARK: - Health & Cycle Count 2x2 Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Label(L10n.Battery.cycleCount, systemImage: "arrow.triangle.2.circlepath")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Text("184")
                                    .font(.system(.title, design: .rounded, weight: .bold))
                                    .monospacedDigit()
                                    .foregroundStyle(appState.accentColor)
                                Text(L10n.Battery.cyclesUnit)
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bentoCard(accent: appState.accentColor)

                        VStack(alignment: .leading, spacing: 6) {
                            Label(L10n.Battery.health, systemImage: "heart.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            Text("98.4%")
                                .font(.system(.title, design: .rounded, weight: .bold))
                                .monospacedDigit()
                                .foregroundStyle(appState.accentColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bentoCard(accent: appState.accentColor)

                        VStack(alignment: .leading, spacing: 6) {
                            Label(L10n.Battery.designCapacity, systemImage: "bolt.fill")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            Text("3274 mAh")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .monospacedDigit()
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bentoCard(accent: appState.accentColor)

                        VStack(alignment: .leading, spacing: 6) {
                            Label(L10n.Battery.currentMaxCapacity, systemImage: "battery.100.bolt")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            Text("3220 mAh")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .monospacedDigit()
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bentoCard(accent: appState.accentColor)
                    }

                    // MARK: - Live Telemetry Metrics
                    VStack(alignment: .leading, spacing: 14) {
                        Label(L10n.Battery.livePower, systemImage: "gauge.with.dots.needle.bottom.50percent")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(appState.accentColor)

                        HStack {
                            telemetryColumn(title: L10n.Battery.voltage, value: "4,185 mV")
                            Spacer()
                            telemetryColumn(title: L10n.Battery.current, value: "+2,450 mA")
                            Spacer()
                            telemetryColumn(title: L10n.Battery.batteryTemp, value: "31.5 °C")
                        }
                    }
                    .bentoCard(accent: appState.accentColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(width: geometry.size.width)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Battery.title)
        }
    }

    @ViewBuilder
    private func telemetryColumn(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
            Text(value)
                .font(.system(.subheadline, design: .monospaced, weight: .semibold))
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
    }
}

