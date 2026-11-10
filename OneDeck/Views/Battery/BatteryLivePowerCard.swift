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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

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
        let green = Theme.readableGreen(for: colorScheme)
        let wattString = String(format: "%.1f", battery.liveWattage.isFinite ? abs(battery.liveWattage) : 0.0)

        let titleAndBadge = HStack(spacing: SpacingTheme.compact) {
            OverviewSectionHeader(title: L10n.Battery.livePowerTitle, icon: "bolt.badge.automatic.fill")

            if battery.isHardwareDirectWattage {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "cpu.fill")
                        .font(IconTheme.badgeInline)
                        .accessibilityHidden(true)
                    Text(L10n.Battery.hardwareDirectTag)
                        .font(Typography.badgeTag)
                        .lineLimit(1)
                }
                .foregroundStyle(green)
                .padding(.horizontal, SpacingTheme.compact)
                .padding(.vertical, SpacingTheme.micro)
                .background(green.opacity(0.12))
                .clipShape(Capsule())
                .accessibilityElement(children: .combine)
            } else if battery.isPluggedIn {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "bolt.fill")
                        .font(IconTheme.badgeInline)
                        .accessibilityHidden(true)
                    Text(L10n.Battery.modelEstimatedTag)
                        .font(Typography.badgeTag)
                        .lineLimit(1)
                }
                .foregroundStyle(powerColor)
                .padding(.horizontal, SpacingTheme.compact)
                .padding(.vertical, SpacingTheme.micro)
                .background(powerColor.opacity(0.12))
                .clipShape(Capsule())
                .accessibilityElement(children: .combine)
            }
        }

        let wattageReadout = HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
            Text(wattString)
                .font(Typography.title2)
                .monospacedDigit()
                .contentTransition(.numericText())
                .foregroundStyle(powerColor)

            Text("W")
                .font(Typography.calloutBold)
                .foregroundStyle(powerColor.opacity(0.85))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Battery.wattage)
        .accessibilityValue("\(wattString) W")

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                titleAndBadge
                wattageReadout
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                titleAndBadge
                Spacer(minLength: SpacingTheme.compact)
                wattageReadout
            }
        }
    }

    @ViewBuilder
    private var waveformSection: some View {
        let validHistory = battery.powerHistory.filter { $0.value.isFinite }
        let waveformTitle = battery.isPluggedIn ? L10n.Battery.chargeWaveform : L10n.Battery.dischargeWaveform

        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            HStack(spacing: SpacingTheme.compact) {
                Text(waveformTitle)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: SpacingTheme.compact)

                Text(L10n.Overview.live30s)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
            }

            if validHistory.count < 2 {
                BentoEmptyStateView(
                    icon: "waveform.path.ecg",
                    message: L10n.Battery.waitingForPowerSample,
                    showsProgress: true,
                    height: 64
                )
            } else {
                let maxObserved = validHistory.reduce(2.5) { max($0, $1.value) }
                let dynamicMaxY = max(2.5, maxObserved * 1.25)
                let topLabelText = String(format: dynamicMaxY >= 10 ? "%.0fW" : "%.1fW", dynamicMaxY)
                let midLabelText = String(format: (dynamicMaxY / 2.0) >= 10 ? "%.0fW" : "%.1fW", dynamicMaxY / 2.0)
                let wattValue = String(format: "%.1f W", battery.liveWattage.isFinite ? abs(battery.liveWattage) : 0.0)

                ZStack(alignment: .topLeading) {
                    VStack(spacing: 0) {
                        HStack(spacing: SpacingTheme.tight) {
                            HorizontalDashedLine()
                                .stroke(ChartTheme.gridColor(for: colorScheme), style: ChartTheme.gridStroke)
                                .frame(height: 1)

                            Text(topLabelText)
                                .font(ChartTheme.compactAxisLabelFont)
                                .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                                .frame(width: 28, alignment: .trailing)
                        }
                        .padding(.top, 5)

                        Spacer()

                        HStack(spacing: SpacingTheme.tight) {
                            HorizontalDashedLine()
                                .stroke(ChartTheme.gridColor(for: colorScheme), style: ChartTheme.gridStroke)
                                .frame(height: 1)

                            Text(midLabelText)
                                .font(ChartTheme.compactAxisLabelFont)
                                .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                                .frame(width: 28, alignment: .trailing)
                        }

                        Spacer()
                    }

                    Chart {
                        ForEach(validHistory) { point in
                            LineMark(
                                x: .value(L10n.Overview.chartTimeAxis, point.timestamp),
                                y: .value(L10n.Battery.livePowerTitle, point.value)
                            )
                            .interpolationMethod(.monotone)
                            .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                            .foregroundStyle(powerColor)

                            AreaMark(
                                x: .value(L10n.Overview.chartTimeAxis, point.timestamp),
                                y: .value(L10n.Battery.livePowerTitle, point.value)
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
                .frame(height: 64)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(waveformTitle)
                .accessibilityValue(wattValue)
            }
        }
    }

    @ViewBuilder
    private var matrixSection: some View {
        let voltageTile = electricalTile(
            icon: "gauge.with.needle.fill",
            label: L10n.Battery.voltage,
            value: "\(battery.liveVoltageMv)",
            unit: "mV"
        )
        let currentTile = electricalTile(
            icon: "waveform.path.ecg.rectangle.fill",
            label: L10n.Battery.current,
            value: (battery.liveCurrentMa >= 0 ? "+" : "") + "\(battery.liveCurrentMa)",
            unit: "mA"
        )
        let tempTile = electricalTile(
            icon: "thermometer.sun.fill",
            label: L10n.Battery.batteryTemp,
            value: String(format: "%.1f", battery.batteryTemperature.isFinite ? battery.batteryTemperature : 0.0),
            unit: "°C"
        )

        if dynamicTypeSize.isAccessibilitySize {
            VStack(spacing: SpacingTheme.standard) {
                voltageTile
                currentTile
                tempTile
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                voltageTile
                currentTile
                tempTile
            }
        }
    }

    @ViewBuilder
    private var adapterBannerSection: some View {
        if let rated = battery.adapterWatts, battery.isPluggedIn {
            FlowLayout(spacing: SpacingTheme.standard) {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "powerplug.fill")
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(powerColor)
                        .accessibilityHidden(true)

                    Text("\(L10n.Battery.chargerRatedPower): \(rated)W")
                        .font(Typography.captionBold)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }

                if battery.pathLossWatts > 0 {
                    Text("\(L10n.Battery.pathLoss): \(String(format: "%.1fW", battery.pathLossWatts))")
                        .font(Typography.badgeTag)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.compact)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(powerColor.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(powerColor.opacity(0.22), lineWidth: 0.8)
            )
            .accessibilityElement(children: .combine)
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
                    .accessibilityHidden(true)

                Text(label)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
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
                    .lineLimit(1)
            }
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
        .accessibilityValue("\(value) \(unit)")
    }

    // MARK: - Dynamic State Color
    private var powerColor: Color {
        if battery.isPluggedIn {
            return readableAccent
        }
        if battery.isLowPowerMode {
            return Theme.readableYellow(for: colorScheme)
        }
        return readableAccent
    }
}

// MARK: - Preview
#Preview {
    BatteryLivePowerCard()
        .padding()
}
