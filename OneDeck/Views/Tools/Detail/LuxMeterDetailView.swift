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
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                if tools.luxStatus == .permissionDenied || tools.isCameraPermissionDenied {
                    luxPermissionDeniedBanner
                } else if tools.luxStatus == .hardwareUnavailable {
                    luxHardwareUnavailableBanner
                }

                // Dual KPI Hero Cards
                dualMetricsHero

                // Rolling Lux Trend Chart
                luxTrendChart

                // Photometric Standard Benchmarks
                benchmarkStandardsCard
            }
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
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

    @ViewBuilder
    private var luxPermissionDeniedBanner: some View {
        VStack(spacing: SpacingTheme.compact) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "camera.fill")
                    .foregroundStyle(Color.orange)
                Text(L10n.Tools.luxCameraPermissionDenied)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .multilineTextAlignment(.leading)
            }

            Button {
                tools.openAppSettings()
            } label: {
                Text(L10n.Tools.openSettings)
                    .font(Typography.captionBold)
                    .padding(.horizontal, SpacingTheme.standard)
                    .padding(.vertical, SpacingTheme.tight)
                    .background(Color.orange)
                    .foregroundStyle(Color.white)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
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

    @ViewBuilder
    private var luxHardwareUnavailableBanner: some View {
        HStack(spacing: SpacingTheme.tight) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.orange)
            Text(L10n.Tools.cameraHardwareUnavailable)
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

    // MARK: - Dual Metrics Hero
    @ViewBuilder
    private var dualMetricsHero: some View {
        let yellowAccent = Theme.readableYellow(for: colorScheme)

        HStack(spacing: SpacingTheme.standard) {
            // Lux Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.illuminanceTitle)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                let safeLux = tools.luxMeter.lux.isFinite ? tools.luxMeter.lux : 0.0
                Text(String(format: "%.0f", safeLux))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(yellowAccent)
                    .lineLimit(1)

                let safeEv = tools.luxMeter.ev.isFinite ? tools.luxMeter.ev : 0.0
                Text(String(format: "%@: %.1f", L10n.Tools.exposureValueTitle, safeEv))
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

            // Foot-Candles Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.footCandlesTitle)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                let safeFc = tools.luxMeter.footCandles.isFinite ? tools.luxMeter.footCandles : 0.0
                Text(String(format: "%.1f", safeFc))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(yellowAccent)
                    .lineLimit(1)

                Text(tools.luxMeter.environmentDescription.isEmpty ? "--" : tools.luxMeter.environmentDescription)
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
                    Text(String(format: "%.0f Lux", safeCurrentLux))
                        .font(Typography.captionMono)
                        .foregroundStyle(yellowAccent)
                }
            }

            if history.isEmpty {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                    .frame(height: 160)
            } else {
                Chart {
                    ForEach(history) { pt in
                        LineMark(
                            x: .value("Time", pt.timestamp),
                            y: .value("Lux", pt.value)
                        )
                        .foregroundStyle(yellowAccent)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)

                        AreaMark(
                            x: .value("Time", pt.timestamp),
                            y: .value("Lux", pt.value)
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

            ForEach(benchmarks, id: \.0) { item in
                HStack(spacing: SpacingTheme.standard) {
                    Image(systemName: item.2)
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(Theme.readableYellow(for: colorScheme))
                        .frame(width: 20)

                    Text(item.0)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Spacer()

                    Text(item.1)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
                .padding(.vertical, SpacingTheme.micro)
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
}

// MARK: - Preview
#Preview {
    NavigationStack {
        LuxMeterDetailView()
    }
}
