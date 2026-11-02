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
                HStack(spacing: 6) {
                    OverviewSectionHeader(title: L10n.Battery.livePowerTitle, icon: "bolt.badge.automatic.fill")

                    if battery.isHardwareDirectWattage {
                        HStack(spacing: 3) {
                            Image(systemName: "cpu")
                                .font(.system(size: 8))
                            Text(L10n.Battery.hardwareDirectTag)
                                .font(.system(size: 9, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(.green)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.12))
                        .clipShape(Capsule())
                    } else if battery.batteryState == .charging {
                        HStack(spacing: 3) {
                            Image(systemName: "waveform.path.badge.plus")
                                .font(.system(size: 8))
                            Text(L10n.Battery.modelEstimatedTag)
                                .font(.system(size: 9, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(powerColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(powerColor.opacity(0.12))
                        .clipShape(Capsule())
                    }
                }

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
                let topLabelText = String(format: dynamicMaxY >= 10 ? "%.0fW" : "%.1fW", dynamicMaxY)
                let midLabelText = String(format: (dynamicMaxY / 2.0) >= 10 ? "%.0fW" : "%.1fW", dynamicMaxY / 2.0)

                ZStack(alignment: .topLeading) {
                    // Layer 1: Dashed Grid Lines (Spanning full width) & Far-Right Aligned Wattage Labels
                    GeometryReader { geo in
                        let w = geo.size.width
                        let h = geo.size.height
                        let labelWidth: CGFloat = 28
                        let gridColor = ChartTheme.gridColor(for: colorScheme)
                        let lineEndX = max(0, w - labelWidth - 4)
                        let y100: CGFloat = 5
                        let y50: CGFloat = h * 0.5

                        // Max Wattage Horizontal Grid Line
                        HorizontalDashedLine()
                            .stroke(gridColor, style: ChartTheme.gridStroke)
                            .frame(width: lineEndX, height: 1)
                            .position(x: lineEndX / 2, y: y100)

                        // Max Wattage Label (Far Right Aligned, flush with card header "30s Rolling")
                        Text(topLabelText)
                            .font(ChartTheme.compactAxisLabelFont)
                            .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                            .frame(width: labelWidth, alignment: .trailing)
                            .position(x: w - labelWidth / 2, y: y100)

                        // Mid Wattage Horizontal Grid Line
                        HorizontalDashedLine()
                            .stroke(gridColor, style: ChartTheme.gridStroke)
                            .frame(width: lineEndX, height: 1)
                            .position(x: lineEndX / 2, y: y50)

                        // Mid Wattage Label (Far Right Aligned, exactly matching top label right edge)
                        Text(midLabelText)
                            .font(ChartTheme.compactAxisLabelFont)
                            .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                            .frame(width: labelWidth, alignment: .trailing)
                            .position(x: w - labelWidth / 2, y: y50)
                    }

                    // Layer 2: Real-time Power Area & Line Waveform
                    // Inset on trailing by 32pt so the waveform stops safely before wattage labels
                    Chart {
                        ForEach(battery.powerHistory) { point in
                            LineMark(
                                x: .value("Time", point.timestamp),
                                y: .value("Power", point.value)
                            )
                            .interpolationMethod(.monotone)
                            .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                            .foregroundStyle(powerColor)

                            AreaMark(
                                x: .value("Time", point.timestamp),
                                y: .value("Power", point.value)
                            )
                            .interpolationMethod(.monotone)
                            .foregroundStyle(ChartTheme.areaGradient(for: powerColor))
                        }
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .chartYScale(domain: 0...dynamicMaxY)
                    .padding(.trailing, 32)
                    .allowsHitTesting(false)
                }
                .frame(height: 54)
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

            // Hardware Adapter Telemetry Banner (When charging with known adapter watts)
            if let rated = battery.adapterWatts, battery.batteryState == .charging {
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "powerplug.fill")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(powerColor)

                        Text("\(L10n.Battery.chargerRatedPower): \(rated)W")
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text("\(L10n.Battery.pathLoss): \(String(format: "%.1fW", battery.pathLossWatts))")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(powerColor.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(powerColor.opacity(0.18), lineWidth: 0.8)
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

