//
//  BatteryLivePowerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Real-time wattage chart, voltage, and electrical current flow card.
//

import Charts
import SwiftUI

struct BatteryLivePowerCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            waveformSection
            matrixSection
            adapterBannerSection
        }
        .bentoCard(accent: powerColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        HStack {
            HStack(spacing: SpacingTheme.compact) {
                OverviewSectionHeader(title: L10n.Battery.livePowerTitle, icon: "bolt.badge.automatic.fill")

                if battery.isHardwareDirectWattage {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: "cpu.fill")
                            .font(IconTheme.badgeInline)
                        Text(L10n.Battery.hardwareDirectTag)
                            .font(Typography.badgeTag)
                    }
                    .foregroundStyle(.green)
                    .padding(.horizontal, SpacingTheme.compact)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(Color.green.opacity(0.12))
                    .clipShape(Capsule())
                } else if battery.batteryState == .charging {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: "bolt.fill")
                            .font(IconTheme.badgeInline)
                        Text(L10n.Battery.modelEstimatedTag)
                            .font(Typography.badgeTag)
                    }
                    .foregroundStyle(powerColor)
                    .padding(.horizontal, SpacingTheme.compact)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(powerColor.opacity(0.12))
                    .clipShape(Capsule())
                }
            }

            Spacer()

            // Live Wattage Value
            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                Text(String(format: "%.1f", abs(battery.liveWattage)))
                    .font(Typography.title2)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(powerColor)

                Text("W")
                    .font(Typography.calloutBold)
                    .foregroundStyle(powerColor.opacity(0.85))
            }
        }
    }

    @ViewBuilder
    private var waveformSection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            HStack {
                Text(battery.batteryState == .charging ? L10n.Battery.chargeWaveform : L10n.Battery.dischargeWaveform)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)

                Spacer()

                Text(L10n.Overview.live30s)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
            }

            let maxObserved = battery.powerHistory.map(\.value).max() ?? 2.5
            let dynamicMaxY = max(2.5, maxObserved * 1.25)
            let topLabelText = String(format: dynamicMaxY >= 10 ? "%.0fW" : "%.1fW", dynamicMaxY)
            let midLabelText = String(format: (dynamicMaxY / 2.0) >= 10 ? "%.0fW" : "%.1fW", dynamicMaxY / 2.0)

            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    let labelWidth: CGFloat = 28
                    let gridColor = ChartTheme.gridColor(for: colorScheme)
                    let lineEndX = max(0, w - labelWidth - SpacingTheme.tight)
                    let y100: CGFloat = 5
                    let y50: CGFloat = h * 0.5

                    // Max Wattage Horizontal Grid Line
                    HorizontalDashedLine()
                        .stroke(gridColor, style: ChartTheme.gridStroke)
                        .frame(width: lineEndX, height: 1)
                        .position(x: lineEndX / 2, y: y100)

                    // Max Wattage Label
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

                    // Mid Wattage Label
                    Text(midLabelText)
                        .font(ChartTheme.compactAxisLabelFont)
                        .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                        .frame(width: labelWidth, alignment: .trailing)
                        .position(x: w - labelWidth / 2, y: y50)
                }

                // Power Waveform Chart
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
                .chartYScale(domain: 0 ... dynamicMaxY)
                .padding(.trailing, ChartTheme.trailingMargin)
                .allowsHitTesting(false)
            }
            .frame(height: 54)
        }
    }

    @ViewBuilder
    private var matrixSection: some View {
        HStack(spacing: SpacingTheme.standard) {
            electricalTile(
                icon: "gauge.with.needle.fill",
                label: L10n.Battery.voltage,
                value: "\(battery.liveVoltageMv)",
                unit: "mV"
            )

            electricalTile(
                icon: "waveform.path.ecg.rectangle.fill",
                label: L10n.Battery.current,
                value: (battery.liveCurrentMa >= 0 ? "+" : "") + "\(battery.liveCurrentMa)",
                unit: "mA"
            )

            electricalTile(
                icon: "thermometer.sun.fill",
                label: L10n.Battery.batteryTemp,
                value: String(format: "%.1f", battery.batteryTemperature),
                unit: "°C"
            )
        }
    }

    @ViewBuilder
    private var adapterBannerSection: some View {
        if let rated = battery.adapterWatts, battery.batteryState == .charging {
            HStack(spacing: SpacingTheme.standard) {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "powerplug.fill")
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(powerColor)

                    Text("\(L10n.Battery.chargerRatedPower): \(rated)W")
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }

                Spacer()

                HStack(spacing: SpacingTheme.tight) {
                    Text("\(L10n.Battery.pathLoss): \(String(format: "%.1fW", battery.pathLossWatts))")
                        .font(Typography.badgeTag)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.compact)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(powerColor.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(powerColor.opacity(0.18), lineWidth: 0.8)
            )
        }
    }

    // MARK: - Tile Helper
    @ViewBuilder
    private func electricalTile(icon: String, label: String, value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: icon)
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(powerColor)

                Text(label)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                Text(value)
                    .font(Typography.bodyValue)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .contentTransition(.numericText())
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(unit)
                    .font(Typography.badgeTag)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
    }

    // MARK: - Dynamic State Color
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

// MARK: - Preview
#Preview {
    BatteryLivePowerCard()
        .padding()
}
