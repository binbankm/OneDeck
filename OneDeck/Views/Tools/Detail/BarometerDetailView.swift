//
//  BarometerDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Atmospheric barometer, altimeter, and vertical speed detail workspace.
//

import Charts
import CoreMotion
import SwiftUI

struct BarometerDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    private var isBarometerAvailable: Bool {
        CMAltimeter.isRelativeAltitudeAvailable()
    }

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                if !isBarometerAvailable {
                    hardwareUnavailableBanner
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
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
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
        HStack(spacing: SpacingTheme.standard) {
            // Pressure Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.atmosphericPressure)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                let safePressure = tools.barometer.pressureHpa.isFinite ? tools.barometer.pressureHpa : 1013.25
                Text(String(format: "%.1f", safePressure))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(appState.accentColor)
                    .lineLimit(1)

                Text("hPa")
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )

            // Relative Altitude Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.relativeElevation)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                let safeAlt = tools.barometer.relativeAltitudeMeters.isFinite ? tools.barometer.relativeAltitudeMeters : 0.0
                let safeVSpd = tools.barometer.verticalSpeedMps.isFinite ? tools.barometer.verticalSpeedMps : 0.0
                Text(String(format: "%+.1f m", safeAlt))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(safeAlt >= 0 ? Color.green : Color.orange)
                    .lineLimit(1)

                Text(String(format: "%@: %+.1f m/s", L10n.Tools.verticalSpeed, safeVSpd))
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
        }
    }

    // MARK: - Pressure History Chart
    @ViewBuilder
    private var pressureHistoryChart: some View {
        let history = tools.barometer.history
        let currentP = tools.barometer.pressureHpa
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
                    Text(trendTitle)
                        .font(Typography.captionBold)
                }
                .foregroundStyle(trendColor)
            }

            if history.isEmpty {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                    .frame(height: 160)
            } else {
                Chart {
                    ForEach(history) { pt in
                        AreaMark(
                            x: .value("Time", pt.timestamp),
                            yStart: .value("Baseline", yMin),
                            yEnd: .value("hPa", pt.value)
                        )
                        .foregroundStyle(ChartTheme.areaGradient(for: appState.accentColor))
                        .interpolationMethod(.monotone)

                        LineMark(
                            x: .value("Time", pt.timestamp),
                            y: .value("hPa", pt.value)
                        )
                        .foregroundStyle(appState.accentColor)
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
            }
        }
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    // MARK: - Environmental ISA Reference Card
    @ViewBuilder
    private var isaAtmosphereCard: some View {
        HStack(spacing: SpacingTheme.standard) {
            Image(systemName: "gauge.with.needle.fill")
                .font(IconTheme.actionButton)
                .foregroundStyle(appState.accentColor)

            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                HStack {
                    Text(L10n.Tools.isaSeaLevelStandard)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Spacer()

                    Text("1013.25 hPa")
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Text(trendWeatherDescription)
                    .font(Typography.badgeTag)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
        .padding(.horizontal, SpacingTheme.rowStandard)
        .padding(.vertical, SpacingTheme.row)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    // MARK: - Bottom Controls Bar
    @ViewBuilder
    private var bottomControlsBar: some View {
        HStack(spacing: SpacingTheme.standard) {
            Button {
                tools.resetBarometerAltitude()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(IconTheme.actionButton)
                    Text(L10n.Tools.resetAltitude)
                        .font(Typography.captionBold)
                }
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(appState.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .buttonStyle(.plain)
        }
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
        case .rising: return Color.green
        case .steady: return appState.accentColor
        case .falling: return Color.orange
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

    @ViewBuilder
    private var hardwareUnavailableBanner: some View {
        HStack(spacing: SpacingTheme.tight) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.orange)
            Text(L10n.Tools.barometerHardwareUnavailable)
                .font(Typography.caption)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .multilineTextAlignment(.leading)
        }
        .padding(SpacingTheme.cardInternal)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .stroke(Color.orange.opacity(0.4), lineWidth: 0.8)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        BarometerDetailView()
    }
}
