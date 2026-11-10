//
//  LuxMeterDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Optical illuminance and ambient lux meter workspace.
//

import Charts
import SwiftUI

struct LuxMeterDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                if tools.luxStatus == .permissionDenied || tools.isCameraPermissionDenied {
                    ToolPermissionDeniedBanner(
                        icon: "camera.fill",
                        message: L10n.Tools.luxCameraPermissionDenied,
                        onOpenSettings: tools.openAppSettings
                    )
                } else if tools.luxStatus == .hardwareUnavailable {
                    ToolNoticeBanner(
                        icon: "exclamationmark.triangle.fill",
                        message: L10n.Tools.cameraHardwareUnavailable
                    )
                }

                // Dual KPI Hero Cards
                dualMetricsHero

                // Rolling Lux Trend Chart
                luxTrendChart

                // Photometric Standard Benchmarks
                benchmarkStandardsCard
            }
            .frame(maxWidth: LayoutTheme.maxContentWidth)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.luxMeter)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .luxMeter)
            tools.startLuxMeter()
        }
        .onDisappear {
            tools.stopLuxMeter()
            tools.leaveDetailView()
        }
    }

    // MARK: - Dual Metrics Hero
    @ViewBuilder
    private var dualMetricsHero: some View {
        let yellowAccent = Theme.readableYellow(for: colorScheme)
        let safeLux = tools.luxMeter.lux.isFinite ? tools.luxMeter.lux : 0.0
        let safeEv = tools.luxMeter.ev.isFinite ? tools.luxMeter.ev : 0.0
        let safeFc = tools.luxMeter.footCandles.isFinite ? tools.luxMeter.footCandles : 0.0
        let luxString = String(format: "%.0f", safeLux)
        let evString = String(format: "%@: %.1f", L10n.Tools.exposureValueTitle, safeEv)
        let fcString = String(format: "%.1f", safeFc)
        let envString = tools.luxMeter.environmentDescription.isEmpty ? "--" : tools.luxMeter.environmentDescription

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        layout {
            // Lux Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.illuminanceTitle)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(luxString)
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(yellowAccent)
                    .lineLimit(1)

                Text(evString)
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
            .accessibilityLabel(L10n.Tools.illuminanceTitle)
            .accessibilityValue("\(luxString) Lux, \(evString)")

            // Foot-Candles Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.footCandlesTitle)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(fcString)
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .foregroundStyle(yellowAccent)
                    .lineLimit(1)

                Text(envString)
                    .font(Typography.captionMono)
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
            .accessibilityLabel(L10n.Tools.footCandlesTitle)
            .accessibilityValue("\(fcString) fc, \(envString)")
        }
    }

    // MARK: - Lux Trend Chart
    @ViewBuilder
    private var luxTrendChart: some View {
        let yellowAccent = Theme.readableYellow(for: colorScheme)
        let history = tools.luxMeter.history.filter { $0.value.isFinite }
        let safeCurrentLux = tools.luxMeter.lux.isFinite ? tools.luxMeter.lux : 0.0
        let values = history.isEmpty ? [safeCurrentLux] : history.map(\.value)
        let maxVal = max(100.0, (values.max() ?? 100.0) * 1.25)

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack {
                Text(L10n.Tools.luxTrend)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(yellowAccent)
                        .frame(width: 6, height: 6)
                        .accessibilityHidden(true)
                    Text(String(format: "%.0f Lux", safeCurrentLux))
                        .font(Typography.captionMono)
                        .monospacedDigit()
                        .foregroundStyle(yellowAccent)
                }
            }

            if history.isEmpty {
                BentoEmptyStateView(
                    icon: "sun.max.fill",
                    message: L10n.Tools.waitingForSamples,
                    showsProgress: tools.luxMeter.isSampling,
                    height: 160
                )
            } else {
                Chart {
                    ForEach(history) { pt in
                        LineMark(
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Tools.chartLuxAxis, pt.value)
                        )
                        .foregroundStyle(yellowAccent)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)

                        AreaMark(
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Tools.chartLuxAxis, pt.value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [yellowAccent.opacity(0.35), yellowAccent.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.monotone)
                    }
                }
                .chartXAxis(.hidden)
                .chartYScale(domain: 0 ... maxVal)
                .chartYAxis {
                    AxisMarks(position: .trailing, values: [0, maxVal / 2.0, maxVal]) { val in
                        AxisGridLine(stroke: ChartTheme.gridStroke)
                            .foregroundStyle(ChartTheme.gridColor(for: colorScheme))
                        AxisValueLabel {
                            if let v = val.as(Double.self) {
                                Text(String(format: "%.0f", v))
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
        .accessibilityLabel(L10n.Tools.luxTrend)
        .accessibilityValue(history.isEmpty ? L10n.Tools.waitingForSamples : String(format: "%.0f Lux", safeCurrentLux))
    }

    // MARK: - Benchmark Standards Card
    @ViewBuilder
    private var benchmarkStandardsCard: some View {
        let benchmarks: [(String, String, String)] = [
            (L10n.Tools.nightHallway, "10 - 50 Lux", "moon.fill"),
            (L10n.Tools.indoorLiving, "100 - 300 Lux", "lamp.floor.fill"),
            (L10n.Tools.officeReading, "300 - 750 Lux", "book.fill"),
            (L10n.Tools.precisionInspect, "1000 - 3000 Lux", "wrench.and.screwdriver.fill"),
            (L10n.Tools.daylightSunny, "10000+ Lux", "sun.max.fill")
        ]

        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            Text(L10n.Tools.benchmarksTitle)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            ForEach(Array(benchmarks.enumerated()), id: \.offset) { idx, item in
                Group {
                    if dynamicTypeSize.isAccessibilitySize {
                        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                            Text(item.0)
                                .font(Typography.caption)
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            Text(item.1)
                                .font(Typography.captionMono)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        }
                    } else {
                        HStack(spacing: SpacingTheme.standard) {
                            Image(systemName: item.2)
                                .font(IconTheme.badgeInline)
                                .foregroundStyle(Theme.readableYellow(for: colorScheme))
                                .frame(width: 20)
                                .accessibilityHidden(true)

                            Text(item.0)
                                .font(Typography.caption)
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))

                            Spacer(minLength: SpacingTheme.compact)

                            Text(item.1)
                                .font(Typography.captionMono)
                                .monospacedDigit()
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        }
                    }
                }
                .padding(.vertical, SpacingTheme.tight)
                .accessibilityElement(children: .combine)

                if idx < benchmarks.count - 1 {
                    BentoHairlineDivider()
                }
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
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        LuxMeterDetailView()
    }
}
