//
//  DecibelMeterDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Precision Acoustic Sound Pressure Level (SPL) & Noise Spectrum Workspace.
//

import SwiftUI
import Charts

struct DecibelMeterDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: SpacingTheme.cardStack) {
                // Top KPI Summary Cards (Peak, Avg, Floor)
                kpiSummaryRow

                Spacer()

                // Center Decibel Circular Gauge
                decibelGauge(size: max(120, min(geometry.size.width - 48, 250)))

                Spacer()

                // Rolling Sound History Chart
                historyChart

                // Master Start / Stop Button
                masterToggleButton
            }
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.decibelMeter)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView()
            tools.startDecibelMeter()
        }
        .onDisappear {
            tools.leaveDetailView()
            tools.stopDecibelMeter()
        }
    }

    // MARK: - KPI Summary Row
    @ViewBuilder
    private var kpiSummaryRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            metricTile(title: L10n.Tools.peakNoise, value: String(format: "%.1f", tools.decibelMeter.peakDb), color: Color.red)
            metricTile(title: L10n.Tools.avgNoise, value: String(format: "%.1f", tools.decibelMeter.avgDb), color: appState.accentColor)
            metricTile(title: L10n.Tools.minNoise, value: String(format: "%.1f", tools.decibelMeter.minDb), color: Color.green)
        }
    }

    @ViewBuilder
    private func metricTile(title: String, value: String, color: Color) -> some View {
        VStack(spacing: SpacingTheme.micro) {
            Text(title)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                Text(value)
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(color)
                Text("dB")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SpacingTheme.compact)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    // MARK: - Center Decibel Gauge
    @ViewBuilder
    private func decibelGauge(size: CGFloat) -> some View {
        let db = tools.decibelMeter.currentDb
        let ratio = max(0.0, min(1.0, (db - 30.0) / 90.0))
        let activeColor = ratingColor(for: db)

        ZStack {
            // Background Track
            Circle()
                .trim(from: 0.15, to: 0.85)
                .stroke(Theme.cardBorder(for: colorScheme), style: StrokeStyle(lineWidth: 14, lineCap: .round))
                .rotationEffect(.degrees(90))
                .frame(width: size, height: size)

            // Dynamic Meter Arc
            Circle()
                .trim(from: 0.15, to: 0.15 + (ratio * 0.70))
                .stroke(activeColor, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                .rotationEffect(.degrees(90))
                .frame(width: size, height: size)
                .animation(.easeOut(duration: 0.12), value: ratio)

            // Center Text
            VStack(spacing: SpacingTheme.micro) {
                Text(String(format: "%.1f", db))
                    .font(Typography.displayHero)
                    .monospacedDigit()
                    .foregroundStyle(activeColor)

                Text("dB SPL")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                Text(ratingTitle(for: db))
                    .font(Typography.badgeTag)
                    .foregroundStyle(activeColor)
                    .padding(.horizontal, SpacingTheme.standard)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(activeColor.opacity(0.14))
                    .clipShape(Capsule())
            }
        }
        .frame(width: size, height: size)
    }

    // MARK: - History Chart
    @ViewBuilder
    private var historyChart: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
            Text(L10n.Tools.soundTimeline)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            if tools.decibelMeter.history.isEmpty {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                    .frame(height: 70)
            } else {
                Chart {
                    ForEach(tools.decibelMeter.history) { pt in
                        LineMark(
                            x: .value("Time", pt.timestamp),
                            y: .value("dB", pt.value)
                        )
                        .foregroundStyle(appState.accentColor)
                        .interpolationMethod(.monotone)
                    }
                }
                .chartYScale(domain: 30...120)
                .chartXAxis(.hidden)
                .chartYAxis {
                    AxisMarks(position: .leading, values: [40, 70, 90]) { val in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [3, 3]))
                            .foregroundStyle(Color.gray.opacity(0.2))
                        AxisValueLabel {
                            if let v = val.as(Int.self) {
                                Text("\(v)")
                                    .font(ChartTheme.compactAxisLabelFont)
                                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                            }
                        }
                    }
                }
                .frame(height: 70)
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Master Play/Stop Button
    @ViewBuilder
    private var masterToggleButton: some View {
        let isRunning = tools.decibelMeter.isRecording

        Button {
            tools.toggleDecibelMeter()
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isRunning ? "stop.fill" : "mic.fill")
                    .font(IconTheme.actionButton)
                Text(isRunning ? L10n.Tools.stopEject : L10n.Tools.startMeter)
                    .font(Typography.headlineValue)
            }
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                    .fill(isRunning ? Color.red : appState.accentColor)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Rating Helpers
    private func ratingColor(for db: Double) -> Color {
        if db < 45 { return Color.green }
        if db < 70 { return appState.accentColor }
        if db < 85 { return Color.orange }
        return Color.red
    }

    private func ratingTitle(for db: Double) -> String {
        L10n.Tools.noiseLevelTitle(for: db)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        DecibelMeterDetailView()
    }
}
