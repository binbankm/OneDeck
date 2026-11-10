//
//  SeismometerDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Tri-axial micro-seismic vibration and waveform workspace.
//

import Charts
import SwiftUI

struct SeismometerDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                if !tools.isSeismicHardwareAvailable {
                    ToolNoticeBanner(
                        icon: "exclamationmark.triangle.fill",
                        message: L10n.Tools.motionHardwareUnavailable
                    )
                }

                // Dual KPI Hero Cards
                dualMetricsHero

                // Real-time Triaxial Waveform Chart
                waveformChart

                // Intensity Scale Reference Card
                intensityScaleCard

                // Reset Peak Action Button
                resetPeakButton
            }
            .frame(maxWidth: LayoutTheme.maxContentWidth)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.seismometer)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .seismometer)
            tools.startSeismometer()
        }
        .onDisappear {
            tools.stopSeismometer()
            tools.leaveDetailView()
        }
    }

    // MARK: - Dual Metrics Hero
    @ViewBuilder
    private var dualMetricsHero: some View {
        let intensityColor = tools.seismometer.intensity.readableColor(for: colorScheme)
        let safePeak = tools.seismometer.peakGal.isFinite ? tools.seismometer.peakGal : 0.0
        let safeLive = tools.seismometer.currentGal.isFinite ? tools.seismometer.currentGal : 0.0
        let peakText = String(format: "%.1f", safePeak)
        let liveText = L10n.Tools.liveGal(safeLive)

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        layout {
            // Live Acceleration Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.peakAcceleration)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(peakText)
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(intensityColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(liveText)
                    .font(Typography.captionMono)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
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
            .accessibilityLabel(L10n.Tools.peakAcceleration)
            .accessibilityValue("\(peakText) Gal, \(liveText)")

            // Intensity Level Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.seismicIntensityTitle)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(tools.seismometer.intensity.shortCode)
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(intensityColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(tools.seismometer.intensity.title)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
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
            .accessibilityLabel(L10n.Tools.seismicIntensityTitle)
            .accessibilityValue("\(tools.seismometer.intensity.shortCode), \(tools.seismometer.intensity.title)")
        }
    }

    // MARK: - Waveform Chart
    @ViewBuilder
    private var waveformChart: some View {
        let intensityColor = tools.seismometer.intensity.readableColor(for: colorScheme)
        let history = tools.seismometer.waveform.filter { $0.value.isFinite }
        let values = history.isEmpty ? [0.0] : history.map(\.value)
        let maxVal = max(5.0, (values.max() ?? 0.0) * 1.2)
        let safeDominantHz = tools.seismometer.dominantFrequencyHz.isFinite ? tools.seismometer.dominantFrequencyHz : 0.0
        let dominantHzText = String(format: "%.1f Hz", safeDominantHz)

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack {
                Text(L10n.Tools.triaxialWaveform)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(intensityColor)
                        .frame(width: 6, height: 6)
                        .accessibilityHidden(true)
                    Text(dominantHzText)
                        .font(Typography.captionMono)
                        .monospacedDigit()
                        .foregroundStyle(intensityColor)
                }
            }

            if history.isEmpty {
                BentoEmptyStateView(
                    icon: "waveform.path.ecg",
                    message: L10n.Tools.waitingForSamples,
                    showsProgress: tools.seismometer.isRecording,
                    height: 160
                )
            } else {
                Chart {
                    ForEach(history) { pt in
                        LineMark(
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Tools.chartSeismicAxis, pt.value)
                        )
                        .foregroundStyle(intensityColor)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)

                        AreaMark(
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Tools.chartSeismicAxis, pt.value)
                        )
                        .foregroundStyle(ChartTheme.areaGradient(for: intensityColor))
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
                                Text(String(format: "%.0f Gal", v))
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
        .accessibilityLabel(L10n.Tools.triaxialWaveform)
        .accessibilityValue("\(dominantHzText), \(tools.seismometer.intensity.title)")
    }

    // MARK: - Intensity Scale Reference Card
    @ViewBuilder
    private var intensityScaleCard: some View {
        let levels = SeismicIntensity.allCases

        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            Text(L10n.Tools.seismicIntensityTitle)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .padding(.bottom, SpacingTheme.micro)

            ForEach(Array(levels.enumerated()), id: \.element) { index, item in
                let thresholdText = String(format: "< %.1f Gal", item.maxGal)
                let rowLayout = dynamicTypeSize.isAccessibilitySize
                    ? AnyLayout(VStackLayout(alignment: .leading, spacing: SpacingTheme.micro))
                    : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

                rowLayout {
                    HStack(spacing: SpacingTheme.standard) {
                        Circle()
                            .fill(item.readableColor(for: colorScheme))
                            .frame(width: 6, height: 6)
                            .accessibilityHidden(true)

                        Text(item.shortCode)
                            .font(Typography.captionMono)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .frame(minWidth: 44, alignment: .leading)

                        Text(item.title)
                            .font(Typography.caption)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if !dynamicTypeSize.isAccessibilitySize {
                        Spacer(minLength: 0)
                    }

                    Text(thresholdText)
                        .font(Typography.captionMono)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                }
                .padding(.vertical, SpacingTheme.tight)
                .accessibilityElement(children: .combine)

                if index < levels.count - 1 {
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

    // MARK: - Reset Peak Action Button
    @ViewBuilder
    private var resetPeakButton: some View {
        Button {
            tools.resetSeismicPeak()
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(L10n.Tools.resetPeakLabel)
                    .font(Typography.headlineValue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(appState.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SeismometerDetailView()
    }
}
