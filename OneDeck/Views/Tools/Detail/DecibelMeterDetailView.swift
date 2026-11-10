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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            let gaugeSize = max(150, min(230, geo.size.width - 64, geo.size.height * 0.36))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    // Top KPI Summary Cards (Peak, Avg, Floor)
                    kpiSummaryRow

                    if tools.isMicrophonePermissionDenied || tools.decibelStatus == .permissionDenied {
                        ToolPermissionDeniedBanner(
                            icon: "mic.slash.fill",
                            message: L10n.Tools.micPermissionDenied,
                            onOpenSettings: tools.openAppSettings
                        )
                    } else if tools.decibelStatus == .hardwareUnavailable {
                        ToolNoticeBanner(
                            icon: "exclamationmark.triangle.fill",
                            message: L10n.Tools.microphoneHardwareUnavailable
                        )
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
                .frame(maxWidth: LayoutTheme.maxContentWidth, minHeight: geo.size.height)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
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

    // MARK: - KPI Summary Row
    @ViewBuilder
    private var kpiSummaryRow: some View {
        let safePeak = tools.decibelMeter.peakDb.isFinite ? tools.decibelMeter.peakDb : 0.0
        let safeAvg = tools.decibelMeter.avgDb.isFinite ? tools.decibelMeter.avgDb : 0.0
        let safeMin = tools.decibelMeter.minDb.isFinite ? tools.decibelMeter.minDb : 0.0

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        layout {
            metricTile(title: L10n.Tools.peakNoise, value: String(format: "%.1f", safePeak), color: Theme.readableRed(for: colorScheme))
            metricTile(title: L10n.Tools.avgNoise, value: String(format: "%.1f", safeAvg), color: accentFg)
            metricTile(title: L10n.Tools.minNoise, value: String(format: "%.1f", safeMin), color: Theme.readableGreen(for: colorScheme))
        }
    }

    @ViewBuilder
    private func metricTile(title: String, value: String, color: Color) -> some View {
        VStack(spacing: SpacingTheme.micro) {
            Text(title)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                Text(value)
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .foregroundStyle(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text("dB")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SpacingTheme.compact)
        .padding(.horizontal, SpacingTheme.tight)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue("\(value) dB")
    }

    // MARK: - Center Decibel Gauge
    @ViewBuilder
    private func decibelGauge(size: CGFloat) -> some View {
        let db = tools.decibelMeter.currentDb.isFinite ? tools.decibelMeter.currentDb : 30.0
        let ratio = max(0.0, min(1.0, (db - 30.0) / 90.0))
        let activeColor = ratingColor(for: db)
        let dbString = String(format: "%.1f", db)
        let rating = ratingTitle(for: db)

        ZStack {
            // Background Track
            Circle()
                .trim(from: 0.15, to: 0.85)
                .stroke(Theme.tileBorder(for: colorScheme), style: StrokeStyle(lineWidth: 14, lineCap: .round))
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
                Text(dbString)
                    .font(Typography.displayHero)
                    .monospacedDigit()
                    .foregroundStyle(activeColor)

                Text("dB SPL")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                Text(rating)
                    .font(Typography.badgeTag)
                    .foregroundStyle(activeColor)
                    .padding(.horizontal, SpacingTheme.standard)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(activeColor.opacity(0.14))
                    .clipShape(Capsule())
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Tools.decibelMeter)
        .accessibilityValue("\(dbString) dB SPL, \(rating)")
    }

    // MARK: - History Chart
    @ViewBuilder
    private var historyChart: some View {
        let validHistory = tools.decibelMeter.history.filter { $0.value.isFinite }
        let safeAvg = tools.decibelMeter.avgDb.isFinite ? tools.decibelMeter.avgDb : 0.0

        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            Text(L10n.Tools.soundTimeline)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            if validHistory.isEmpty {
                BentoEmptyStateView(
                    icon: "waveform",
                    message: L10n.Tools.waitingForSamples,
                    showsProgress: tools.decibelMeter.isRecording,
                    height: 84
                )
            } else {
                Chart {
                    ForEach(validHistory) { pt in
                        LineMark(
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Tools.chartDecibelAxis, pt.value)
                        )
                        .foregroundStyle(accentFg)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)
                    }
                }
                .chartYScale(domain: 30 ... 120)
                .chartXAxis(.hidden)
                .chartYAxis {
                    AxisMarks(position: .leading, values: [40, 70, 90]) { val in
                        AxisGridLine(stroke: ChartTheme.gridStroke)
                            .foregroundStyle(ChartTheme.gridColor(for: colorScheme))
                        AxisValueLabel {
                            if let v = val.as(Int.self) {
                                Text("\(v)")
                                    .font(ChartTheme.compactAxisLabelFont)
                                    .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                            }
                        }
                    }
                }
                .frame(height: 84)
                .accessibilityHidden(true)
            }
        }
        .bentoCard(accent: appState.accentColor)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Tools.soundTimeline)
        .accessibilityValue(validHistory.isEmpty ? L10n.Tools.waitingForSamples : String(format: "%.1f dB", safeAvg))
    }

    // MARK: - Primary Play/Stop Button
    @ViewBuilder
    private var primaryToggleButton: some View {
        let isRunning = tools.decibelMeter.isRecording
        let buttonBg = isRunning ? Theme.readableRed(for: colorScheme) : appState.accentColor

        Button {
            tools.toggleDecibelMeter()
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isRunning ? "stop.fill" : "mic.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(isRunning ? L10n.Common.stop : L10n.Tools.startMeter)
                    .font(Typography.headlineValue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(Theme.contrastingForeground(for: buttonBg))
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                    .fill(buttonBg)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
    }

    // MARK: - Rating Helpers
    private func ratingColor(for db: Double) -> Color {
        if db < 45 { return Theme.readableGreen(for: colorScheme) }
        if db < 70 { return accentFg }
        if db < 85 { return Theme.readableOrange(for: colorScheme) }
        return Theme.readableRed(for: colorScheme)
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
