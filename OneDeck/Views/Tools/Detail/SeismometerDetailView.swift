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
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                // Dual KPI Hero Cards
                dualMetricsHero

                // Real-time Triaxial Waveform Chart
                waveformChart

                // Intensity Scale Reference Card
                intensityScaleCard

                // Reset Peak Action Button
                resetPeakButton
            }
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
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
        HStack(spacing: SpacingTheme.standard) {
            // Live Acceleration Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.peakAcceleration)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(String(format: "%.1f", tools.seismometer.peakGal))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(tools.seismometer.intensity.color)
                    .lineLimit(1)

                Text(String(format: "Live: %.1f Gal", tools.seismometer.currentGal))
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

            // Intensity Level Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.seismicIntensityTitle)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(tools.seismometer.intensity.shortCode)
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(tools.seismometer.intensity.color)
                    .lineLimit(1)

                Text(tools.seismometer.intensity.title)
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
        }
    }

    // MARK: - Waveform Chart
    @ViewBuilder
    private var waveformChart: some View {
        let history = tools.seismometer.waveform
        let values = history.isEmpty ? [0.0] : history.map(\.value)
        let maxVal = max(5.0, (values.max() ?? 0.0) * 1.2)

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack {
                Text(L10n.Tools.triaxialWaveform)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(tools.seismometer.intensity.color)
                        .frame(width: 6, height: 6)
                    Text(String(format: "%.1f Hz", tools.seismometer.dominantFrequencyHz))
                        .font(Typography.captionMono)
                        .foregroundStyle(tools.seismometer.intensity.color)
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
                            x: .value("Index", idx),
                            y: .value("Gal", pt.value)
                        )
                        .foregroundStyle(tools.seismometer.intensity.color)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)

                        AreaMark(
                            x: .value("Index", idx),
                            y: .value("Gal", pt.value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [tools.seismometer.intensity.color.opacity(0.35), tools.seismometer.intensity.color.opacity(0.0)],
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
                                Text(String(format: "%.0f Gal", v))
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

    // MARK: - Intensity Scale Reference Card
    @ViewBuilder
    private var intensityScaleCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            Text(L10n.Tools.seismicIntensityTitle)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            ForEach(SeismicIntensity.allCases, id: \.self) { item in
                HStack(spacing: SpacingTheme.standard) {
                    Circle()
                        .fill(item.color)
                        .frame(width: 6, height: 6)

                    Text(item.shortCode)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .frame(width: 44, alignment: .leading)

                    Text(item.titleZh)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                    Spacer()

                    Text(String(format: "< %.1f Gal", item.maxGal))
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
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

    // MARK: - Reset Peak Action Button
    @ViewBuilder
    private var resetPeakButton: some View {
        Button {
            tools.resetSeismicPeak()
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(IconTheme.actionButton)
                Text(L10n.Tools.resetPeakLabel)
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

// MARK: - Preview
#Preview {
    NavigationStack {
        SeismometerDetailView()
    }
}
