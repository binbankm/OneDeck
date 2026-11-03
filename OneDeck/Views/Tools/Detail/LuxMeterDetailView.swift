//
//  LuxMeterDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Ambient Illuminance & Foot-Candles Fullscreen Workspace.
//

import SwiftUI
import Charts

struct LuxMeterDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
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
            tools.enterDetailView()
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
        HStack(spacing: SpacingTheme.standard) {
            // Lux Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.illuminanceTitle)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(String(format: "%.0f", tools.luxMeter.lux))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(Color.yellow)
                    .lineLimit(1)

                Text(String(format: "%@: %.1f", L10n.Tools.exposureValueTitle, tools.luxMeter.ev))
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

                Text(String(format: "%.1f", tools.luxMeter.footCandles))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(Color.yellow)
                    .lineLimit(1)

                Text(tools.luxMeter.environmentDescription)
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
        let history = tools.luxMeter.history
        let values = history.isEmpty ? [tools.luxMeter.lux] : history.map(\.value)
        let maxVal = max(100.0, (values.max() ?? 100.0) * 1.25)

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack {
                Text(L10n.Tools.luxTrend)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 6, height: 6)
                    Text(String(format: "%.0f Lux", tools.luxMeter.lux))
                        .font(Typography.captionMono)
                        .foregroundStyle(Color.yellow)
                }
            }

            if history.isEmpty {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                    .frame(height: 160)
            } else {
                Chart {
                    ForEach(Array(history.enumerated()), id: \.offset) { idx, pt in
                        LineMark(
                            x: .value("Time", pt.timestamp),
                            y: .value("Lux", pt.value)
                        )
                        .foregroundStyle(Color.yellow)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)

                        AreaMark(
                            x: .value("Time", pt.timestamp),
                            y: .value("Lux", pt.value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.yellow.opacity(0.35), Color.yellow.opacity(0.0)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.monotone)
                    }
                }
                .chartXAxis(.hidden)
                .chartYScale(domain: 0...maxVal)
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
                        .foregroundStyle(Color.yellow)
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

