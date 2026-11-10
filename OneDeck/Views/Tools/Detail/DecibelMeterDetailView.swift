//
//  DecibelMeterDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Acoustic sound pressure level (SPL) and noise spectrum workspace.
//

import Charts
import SwiftUI

struct DecibelMeterDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            let gaugeSize = max(150, min(230, geo.size.width - 64, geo.size.height * 0.36))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    // Top KPI Summary Cards (Peak, Avg, Floor)
                    kpiSummaryRow

                    if tools.isMicrophonePermissionDenied || tools.decibelStatus == .permissionDenied {
                        micPermissionDeniedBanner
                    } else if tools.decibelStatus == .hardwareUnavailable {
                        micHardwareUnavailableBanner
                    }

                    Spacer(minLength: 0)

                    // Center Decibel Circular Gauge
                    decibelGauge(size: gaugeSize)

                    Spacer(minLength: 0)

                    // Rolling Sound History Chart
                    historyChart

                    // Master Start / Stop Button
                    primaryToggleButton
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
                .frame(maxWidth: .infinity, minHeight: geo.size.height)
            }
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.decibelMeter)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .decibelMeter)
            tools.startDecibelMeter()
        }
        .onDisappear {
            tools.stopDecibelMeter()
            tools.leaveDetailView()
        }
    }

    @ViewBuilder
    private var micPermissionDeniedBanner: some View {
        VStack(spacing: SpacingTheme.compact) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "mic.slash.fill")
                    .foregroundStyle(Color.orange)
                Text(L10n.Tools.micPermissionDenied)
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
    private var micHardwareUnavailableBanner: some View {
        HStack(spacing: SpacingTheme.tight) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.orange)
            Text(L10n.Tools.microphoneHardwareUnavailable)
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

    // MARK: - KPI Summary Row
    @ViewBuilder
    private var kpiSummaryRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            let safePeak = tools.decibelMeter.peakDb.isFinite ? tools.decibelMeter.peakDb : 0.0
            let safeAvg = tools.decibelMeter.avgDb.isFinite ? tools.decibelMeter.avgDb : 0.0
            let safeMin = tools.decibelMeter.minDb.isFinite ? tools.decibelMeter.minDb : 0.0
            metricTile(title: L10n.Tools.peakNoise, value: String(format: "%.1f", safePeak), color: Color.red)
            metricTile(title: L10n.Tools.avgNoise, value: String(format: "%.1f", safeAvg), color: appState.accentColor)
            metricTile(title: L10n.Tools.minNoise, value: String(format: "%.1f", safeMin), color: Color.green)
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
        let db = tools.decibelMeter.currentDb.isFinite ? tools.decibelMeter.currentDb : 30.0
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
        let validHistory = tools.decibelMeter.history.filter { $0.value.isFinite }

        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
            Text(L10n.Tools.soundTimeline)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            if validHistory.isEmpty {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                    .frame(height: 70)
            } else {
                Chart {
                    ForEach(validHistory) { pt in
                        LineMark(
                            x: .value("Time", pt.timestamp),
                            y: .value("dB", pt.value)
                        )
                        .foregroundStyle(appState.accentColor)
                        .interpolationMethod(.monotone)
                    }
                }
                .chartYScale(domain: 30 ... 120)
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

    // MARK: - Primary Play/Stop Button
    @ViewBuilder
    private var primaryToggleButton: some View {
        let isRunning = tools.decibelMeter.isRecording

        Button {
            tools.toggleDecibelMeter()
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isRunning ? "stop.fill" : "mic.fill")
                    .font(IconTheme.actionButton)
                Text(isRunning ? L10n.Common.stop : L10n.Tools.startMeter)
                    .font(Typography.headlineValue)
            }
            .foregroundStyle(isRunning ? Color.white : Theme.contrastingForeground(for: appState.accentColor))
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
