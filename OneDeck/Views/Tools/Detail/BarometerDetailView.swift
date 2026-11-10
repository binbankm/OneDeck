//
//  BarometerDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Atmospheric barometer, altimeter, and vertical speed detail workspace.
//

import Charts
import SwiftUI

struct BarometerDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    private var isBarometerAvailable: Bool {
        tools.isBarometerAvailable
    }

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                if !isBarometerAvailable {
                    ToolNoticeBanner(
                        icon: "exclamationmark.triangle.fill",
                        message: L10n.Tools.barometerHardwareUnavailable
                    )
                }

                // Dual Top KPI Hero Cards
                dualMetricsHero

                // Rolling Atmospheric Pressure Trend Chart
                pressureHistoryChart

                // Environmental ISA Reference & Weather Estimation Card
                isaAtmosphereCard

                // Bottom Reset Altitude Action Bar
                bottomControlsBar
            }
            .frame(maxWidth: LayoutTheme.maxContentWidth)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.barometer)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .barometer)
            tools.startBarometer()
        }
        .onDisappear {
            tools.stopBarometer()
            tools.leaveDetailView()
        }
    }

    // MARK: - Dual Metrics Hero
    @ViewBuilder
    private var dualMetricsHero: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        layout {
            // Pressure Tile
            let safePressure = tools.barometer.pressureHpa.isFinite ? tools.barometer.pressureHpa : 1013.25
            let formattedPressure = String(format: "%.1f", safePressure)

            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.atmosphericPressure)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(formattedPressure)
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(accentFg)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text("hPa")
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.tileBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Tools.atmosphericPressure)
            .accessibilityValue("\(formattedPressure) hPa")

            // Relative Altitude Tile
            let safeAlt = tools.barometer.relativeAltitudeMeters.isFinite ? tools.barometer.relativeAltitudeMeters : 0.0
            let safeVSpd = tools.barometer.verticalSpeedMps.isFinite ? tools.barometer.verticalSpeedMps : 0.0
            let formattedAlt = String(format: "%+.1f m", safeAlt)
            let formattedVSpd = String(format: "%@: %+.1f m/s", L10n.Tools.verticalSpeed, safeVSpd)

            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.relativeElevation)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(formattedAlt)
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(safeAlt >= 0 ? Theme.readableGreen(for: colorScheme) : Theme.readableOrange(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(formattedVSpd)
                    .font(Typography.captionMono)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.tileBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Tools.relativeElevation)
            .accessibilityValue("\(formattedAlt), \(formattedVSpd)")
        }
    }

    // MARK: - Pressure History Chart
    @ViewBuilder
    private var pressureHistoryChart: some View {
        let history = tools.barometer.history.filter { $0.value.isFinite }
        let rawCurrentP = tools.barometer.pressureHpa
        let currentP = rawCurrentP.isFinite ? rawCurrentP : 1013.25
        let values = history.isEmpty ? [currentP] : history.map(\.value)
        let minVal = values.min() ?? currentP
        let maxVal = values.max() ?? currentP
        // Minimum span of 1.8 hPa gives a clear, sensitive, responsive wave curve
        let span = max(1.8, maxVal - minVal)
        let mid = (minVal + maxVal) / 2.0
        let yMin = mid - (span / 2.0)
        let yMax = mid + (span / 2.0)

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack {
                Text(L10n.Tools.barometricTendency)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: trendIcon)
                        .accessibilityHidden(true)
                    Text(trendTitle)
                        .font(Typography.captionBold)
                }
                .foregroundStyle(trendColor)
            }

            if history.isEmpty {
                BentoEmptyStateView(
                    icon: "gauge.with.needle.fill",
                    message: L10n.Tools.waitingForSamples,
                    showsProgress: tools.isBarometerActive,
                    height: 160
                )
            } else {
                Chart {
                    ForEach(history) { pt in
                        AreaMark(
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            yStart: .value(L10n.Tools.chartBaselineAxis, yMin),
                            yEnd: .value(L10n.Tools.chartPressureAxis, pt.value)
                        )
                        .foregroundStyle(ChartTheme.areaGradient(for: accentFg))
                        .interpolationMethod(.monotone)

                        LineMark(
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Tools.chartPressureAxis, pt.value)
                        )
                        .foregroundStyle(accentFg)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)
                    }
                }
                .chartXAxis(.hidden)
                .chartYScale(domain: yMin ... yMax)
                .chartYAxis {
                    AxisMarks(position: .trailing, values: [yMin, mid, yMax]) { val in
                        AxisGridLine(stroke: ChartTheme.gridStroke)
                            .foregroundStyle(ChartTheme.gridColor(for: colorScheme))
                        AxisValueLabel {
                            if let hpa = val.as(Double.self) {
                                Text(String(format: "%.1f", hpa))
                                    .font(ChartTheme.axisLabelFont)
                                    .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                            }
                        }
                    }
                }
                .frame(height: 160)
                .accessibilityHidden(true)
            }
        }
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Tools.barometricTendency)
        .accessibilityValue("\(trendTitle), \(String(format: "%.1f", currentP)) hPa")
    }

    // MARK: - Environmental ISA Reference Card
    @ViewBuilder
    private var isaAtmosphereCard: some View {
        HStack(alignment: .top, spacing: SpacingTheme.standard) {
            Image(systemName: "gauge.with.needle.fill")
                .font(IconTheme.actionButton)
                .foregroundStyle(accentFg)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                HStack {
                    Text(L10n.Tools.isaSeaLevelStandard)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: SpacingTheme.compact)

                    Text("1013.25 hPa")
                        .font(Typography.badgeTagMono)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Text(trendWeatherDescription)
                    .font(Typography.badgeTag)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, SpacingTheme.rowStandard)
        .padding(.vertical, SpacingTheme.row)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
    }

    // MARK: - Bottom Controls Bar
    @ViewBuilder
    private var bottomControlsBar: some View {
        Button {
            tools.resetBarometerAltitude()
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(L10n.Tools.resetAltitude)
                    .font(Typography.captionBold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
            .background(appState.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
    }

    // MARK: - Trend Helpers
    private var trendIcon: String {
        switch tools.barometer.trend {
        case .rising: return "arrow.up.right"
        case .steady: return "arrow.right"
        case .falling: return "arrow.down.right"
        }
    }

    private var trendTitle: String {
        switch tools.barometer.trend {
        case .rising: return L10n.Tools.pressureRising
        case .steady: return L10n.Tools.pressureSteady
        case .falling: return L10n.Tools.pressureFalling
        }
    }

    private var trendColor: Color {
        switch tools.barometer.trend {
        case .rising: return Theme.readableGreen(for: colorScheme)
        case .steady: return accentFg
        case .falling: return Theme.readableOrange(for: colorScheme)
        }
    }

    private var trendWeatherDescription: String {
        switch tools.barometer.trend {
        case .rising:
            return L10n.Tools.pressureRisingDesc
        case .steady:
            return L10n.Tools.pressureSteadyDesc
        case .falling:
            return L10n.Tools.pressureFallingDesc
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        BarometerDetailView()
    }
}
