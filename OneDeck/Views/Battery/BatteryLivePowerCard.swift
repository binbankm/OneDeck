//
//  BatteryLivePowerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Live Electrical Telemetry: Real-time Wattage, 30s Rolling Waveform, Voltage & Current Flow.
//

import SwiftUI
import Charts

struct BatteryLivePowerCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var battery = BatteryService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Row
            HStack {
                OverviewSectionHeader(title: L10n.Battery.livePowerTitle, icon: "bolt.badge.automatic.fill")

                Spacer()

                // Live Wattage Value
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(String(format: "%.1f", abs(battery.liveWattage)))
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .foregroundStyle(powerColor)

                    Text("W")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(powerColor.opacity(0.85))
                }
            }

            // Rolling 30s Power Waveform
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(battery.batteryState == .charging ? L10n.Battery.chargeWaveform : L10n.Battery.dischargeWaveform)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)

                    Spacer()

                    Text(L10n.Overview.live30s)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        .lineLimit(1)
                }

                let maxObserved = battery.powerHistory.map(\.value).max() ?? 2.5
                let dynamicMaxY = max(2.5, maxObserved * 1.25)

                Chart {
                    ForEach(battery.powerHistory) { point in
                        LineMark(
                            x: .value("Time", point.timestamp),
                            y: .value("Power", point.value)
                        )
                        .interpolationMethod(.monotone)
                        .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(powerColor)

                        AreaMark(
                            x: .value("Time", point.timestamp),
                            y: .value("Power", point.value)
                        )
                        .interpolationMethod(.monotone)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    powerColor.opacity(0.24),
                                    powerColor.opacity(0.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartYScale(domain: 0...dynamicMaxY)
                .frame(height: 54)
                .allowsHitTesting(false)
            }

            // 3-Column Electrical Matrix
            HStack(spacing: 8) {
                electricalTile(
                    icon: "speedometer",
                    label: L10n.Battery.voltage,
                    value: "\(battery.liveVoltageMv)",
                    unit: "mV"
                )

                electricalTile(
                    icon: "waveform.path.ecg",
                    label: L10n.Battery.current,
                    value: (battery.liveCurrentMa >= 0 ? "+" : "") + "\(battery.liveCurrentMa)",
                    unit: "mA"
                )

                electricalTile(
                    icon: "thermometer.medium",
                    label: L10n.Battery.batteryTemp,
                    value: String(format: "%.1f", battery.batteryTemperature),
                    unit: "°C"
                )
            }
        }
        .bentoCard(accent: powerColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private func electricalTile(icon: String, label: String, value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(powerColor)

                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .monospacedDigit()
                    .lineLimit(1)
                    .contentTransition(.numericText())
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(unit)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 9)
        .padding(.vertical, 7)
        .background(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var powerColor: Color {
        if battery.batteryState == .charging {
            return appState.accentColor
        }
        if battery.isLowPowerMode {
            return .yellow
        }
        return appState.accentColor
    }
}

