//
//  PulseMeterDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Camera optical PPG heart rate and pulse waveform workspace.
//

import Charts
import SwiftUI

struct PulseMeterDetailView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    var body: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // Dual Top KPI Hero Cards
            dualMetricsHero

            // Real-Time PPG Blood Volume Pulse Waveform
            pulseWaveformChart

            // Finger Placement & Quality Guidance
            guidanceStatusCard

            Spacer()

            // Bottom Action Button (Start / Stop)
            actionButton
        }
        .padding(.horizontal, SpacingTheme.cardStack)
        .padding(.vertical, SpacingTheme.rowStandard)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.pulseMeter)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Haptics.selection()
                    tools.togglePulseTorch()
                } label: {
                    Image(systemName: tools.isPulseTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                        .foregroundStyle(tools.isPulseTorchOn ? Color.yellow : Theme.textTertiary(for: colorScheme))
                }
            }
        }
        .onAppear {
            tools.enterDetailView(tool: .pulseMeter)
            tools.startPulseMeasurement()
        }
        .onDisappear {
            tools.stopPulseMeasurement()
            tools.leaveDetailView()
        }
    }

    // MARK: - Dual Metrics Hero
    @ViewBuilder
    private var dualMetricsHero: some View {
        HStack(spacing: SpacingTheme.standard) {
            // Instant BPM Card
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.heartRateBpm)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(tools.pulseMeter.bpm > 0 ? "\(tools.pulseMeter.bpm)" : (tools.pulseMeter.isFingerDetected ? "···" : "--"))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(tools.pulseMeter.bpm > 0 ? Color.red : (tools.pulseMeter.isFingerDetected ? Color.orange : Theme.textTertiary(for: colorScheme)))
                    .lineLimit(1)

                Text("BPM")
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

            // HRV (RMSSD) Card
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.heartRateVariability)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(tools.pulseMeter.hrvMs > 0 ? String(format: "%.1f", tools.pulseMeter.hrvMs) : (tools.pulseMeter.isFingerDetected ? "···" : "--"))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(tools.pulseMeter.hrvMs > 0 ? Color.green : (tools.pulseMeter.isFingerDetected ? Color.orange : Theme.textTertiary(for: colorScheme)))
                    .lineLimit(1)

                Text("ms (RMSSD)")
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
    private var pulseWaveformChart: some View {
        let history = tools.pulseMeter.waveformHistory

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack {
                Text(L10n.Tools.pulseWaveform)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(tools.pulseMeter.isFingerDetected ? Color.red : Theme.textTertiary(for: colorScheme))
                        .symbolEffect(.pulse, isActive: tools.pulseMeter.isFingerDetected)

                    Text(tools.pulseMeter.isFingerDetected ? L10n.Tools.fingerDetected : L10n.Tools.fingerNotDetected)
                        .font(Typography.captionBold)
                        .foregroundStyle(tools.pulseMeter.isFingerDetected ? Color.red : Theme.textTertiary(for: colorScheme))
                }
            }

            if history.count < 3 {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                    .frame(height: 160)
                    .overlay(
                        Text(L10n.Tools.coverCameraTip)
                            .font(Typography.badgeTag)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    )
            } else {
                let values = history.map(\.value)
                let minV = values.min() ?? -1.0
                let maxV = values.max() ?? 1.0
                let span = max(1.0, maxV - minV)
                let yMin = minV - span * 0.1
                let yMax = maxV + span * 0.1

                Chart {
                    ForEach(history) { pt in
                        AreaMark(
                            x: .value("Time", pt.timestamp),
                            yStart: .value("Baseline", yMin),
                            yEnd: .value("Absorption", pt.value)
                        )
                        .foregroundStyle(ChartTheme.areaGradient(for: Color.red))
                        .interpolationMethod(.catmullRom)

                        LineMark(
                            x: .value("Time", pt.timestamp),
                            y: .value("Absorption", pt.value)
                        )
                        .foregroundStyle(Color.red)
                        .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartYScale(domain: yMin ... yMax)
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

    // MARK: - Guidance Card
    @ViewBuilder
    private var guidanceStatusCard: some View {
        HStack(spacing: SpacingTheme.standard) {
            Image(systemName: tools.isPulseTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                .font(IconTheme.actionButton)
                .foregroundStyle(tools.isPulseTorchOn ? Color.yellow : Theme.textTertiary(for: colorScheme))

            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(L10n.Tools.coverCameraTip)
                    .font(Typography.captionBold)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(tools.pulseMeter.isFingerDetected ? (tools.pulseMeter.bpm > 0 ? L10n.Tools.pulseSteadyTip : L10n.Tools.pulseAcquiring) : L10n.Tools.pulseHoldStillTip)
                    .font(Typography.badgeTag)
                    .foregroundStyle(tools.pulseMeter.isFingerDetected ? (tools.pulseMeter.bpm > 0 ? Color.green : Color.orange) : Theme.textSecondary(for: colorScheme))
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

    // MARK: - Action Button
    @ViewBuilder
    private var actionButton: some View {
        Button {
            Haptics.selection()
            if tools.pulseMeter.isMeasuring {
                tools.stopPulseMeasurement()
            } else {
                tools.startPulseMeasurement()
            }
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: tools.pulseMeter.isMeasuring ? "stop.fill" : "play.fill")
                    .font(IconTheme.actionButton)
                Text(tools.pulseMeter.isMeasuring ? L10n.Tools.turnOff : L10n.Tools.startMeter)
                    .font(Typography.captionBold)
            }
            .foregroundStyle(Color.black)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(tools.pulseMeter.isMeasuring ? Color.red : appState.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        PulseMeterDetailView()
    }
}
