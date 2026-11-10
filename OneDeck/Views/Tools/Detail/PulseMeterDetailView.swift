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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    if tools.isCameraPermissionDenied || tools.pulseStatus == .permissionDenied {
                        ToolPermissionDeniedBanner(
                            icon: "camera.fill",
                            message: L10n.Tools.pulseCameraPermissionDenied,
                            onOpenSettings: tools.openAppSettings
                        )
                    } else if tools.pulseStatus == .hardwareUnavailable {
                        ToolNoticeBanner(
                            icon: "exclamationmark.triangle.fill",
                            message: L10n.Tools.cameraHardwareUnavailable
                        )
                    }

                    // Dual Top KPI Hero Cards
                    dualMetricsHero

                    // Real-Time PPG Blood Volume Pulse Waveform
                    pulseWaveformChart

                    // Finger Placement & Quality Guidance
                    guidanceStatusCard

                    Spacer(minLength: SpacingTheme.standard)

                    // Bottom Action Button (Start / Stop)
                    actionButton
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .frame(maxWidth: .infinity, minHeight: geo.size.height)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
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
                        .foregroundStyle(tools.isPulseTorchOn ? Theme.readableYellow(for: colorScheme) : Theme.textTertiary(for: colorScheme))
                }
                .accessibilityLabel(L10n.Tools.macroIllumination)
                .accessibilityAddTraits(tools.isPulseTorchOn ? .isSelected : [])
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
        let redAccent = Theme.readableRed(for: colorScheme)
        let orangeAccent = Theme.readableOrange(for: colorScheme)
        let greenAccent = Theme.readableGreen(for: colorScheme)

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        let bpmText = tools.pulseMeter.bpm > 0 ? "\(tools.pulseMeter.bpm)" : (tools.pulseMeter.isFingerDetected ? "···" : "--")
        let safeHrv = tools.pulseMeter.hrvMs.isFinite ? tools.pulseMeter.hrvMs : 0.0
        let hrvText = safeHrv > 0 ? String(format: "%.1f", safeHrv) : (tools.pulseMeter.isFingerDetected ? "···" : "--")

        layout {
            // Instant BPM Card
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.heartRateBpm)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(bpmText)
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(tools.pulseMeter.bpm > 0 ? redAccent : (tools.pulseMeter.isFingerDetected ? orangeAccent : Theme.textTertiary(for: colorScheme)))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text("BPM")
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
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
            .accessibilityLabel(L10n.Tools.heartRateBpm)
            .accessibilityValue(tools.pulseMeter.bpm > 0 ? "\(bpmText) BPM" : L10n.Tools.fingerNotDetected)

            // HRV (RMSSD) Card
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.heartRateVariability)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(hrvText)
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(safeHrv > 0 ? greenAccent : (tools.pulseMeter.isFingerDetected ? orangeAccent : Theme.textTertiary(for: colorScheme)))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text("ms (RMSSD)")
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
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
            .accessibilityLabel(L10n.Tools.heartRateVariability)
            .accessibilityValue(safeHrv > 0 ? "\(hrvText) ms" : L10n.Tools.fingerNotDetected)
        }
    }

    // MARK: - Waveform Chart
    @ViewBuilder
    private var pulseWaveformChart: some View {
        let history = tools.pulseMeter.waveformHistory.filter { $0.value.isFinite }
        let redAccent = Theme.readableRed(for: colorScheme)
        let fingerStatus = tools.pulseMeter.isFingerDetected ? L10n.Tools.fingerDetected : L10n.Tools.fingerNotDetected

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack {
                Text(L10n.Tools.pulseWaveform)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(tools.pulseMeter.isFingerDetected ? redAccent : Theme.textTertiary(for: colorScheme))
                        .symbolEffect(.pulse, isActive: tools.pulseMeter.isFingerDetected)
                        .accessibilityHidden(true)

                    Text(fingerStatus)
                        .font(Typography.captionBold)
                        .foregroundStyle(tools.pulseMeter.isFingerDetected ? redAccent : Theme.textTertiary(for: colorScheme))
                }
            }

            if history.count < 3 {
                BentoEmptyStateView(
                    icon: "heart.fill",
                    message: L10n.Tools.coverCameraTip,
                    showsProgress: tools.pulseMeter.isMeasuring && !tools.pulseMeter.isFingerDetected,
                    height: 160
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
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            yStart: .value(L10n.Tools.chartBaselineAxis, yMin),
                            yEnd: .value(L10n.Tools.chartAbsorptionAxis, pt.value)
                        )
                        .foregroundStyle(ChartTheme.areaGradient(for: redAccent))
                        .interpolationMethod(.catmullRom)

                        LineMark(
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Tools.chartAbsorptionAxis, pt.value)
                        )
                        .foregroundStyle(redAccent)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartYScale(domain: yMin ... yMax)
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
        .accessibilityLabel(L10n.Tools.pulseWaveform)
        .accessibilityValue(fingerStatus)
    }

    // MARK: - Guidance Card
    @ViewBuilder
    private var guidanceStatusCard: some View {
        let statusColor = tools.pulseMeter.isFingerDetected
            ? (tools.pulseMeter.bpm > 0 ? Theme.readableGreen(for: colorScheme) : Theme.readableOrange(for: colorScheme))
            : Theme.textSecondary(for: colorScheme)

        HStack(spacing: SpacingTheme.standard) {
            Image(systemName: tools.isPulseTorchOn ? "flashlight.on.fill" : "flashlight.off.fill")
                .font(IconTheme.actionButton)
                .foregroundStyle(tools.isPulseTorchOn ? Theme.readableYellow(for: colorScheme) : Theme.textTertiary(for: colorScheme))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(L10n.Tools.coverCameraTip)
                    .font(Typography.captionBold)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)

                Text(tools.pulseMeter.isFingerDetected ? (tools.pulseMeter.bpm > 0 ? L10n.Tools.pulseSteadyTip : L10n.Tools.pulseAcquiring) : L10n.Tools.pulseHoldStillTip)
                    .font(Typography.badgeTag)
                    .foregroundStyle(statusColor)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, SpacingTheme.rowStandard)
        .padding(.vertical, SpacingTheme.row)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
    }

    // MARK: - Action Button
    @ViewBuilder
    private var actionButton: some View {
        let isMeasuring = tools.pulseMeter.isMeasuring
        let buttonBg = isMeasuring ? Theme.readableRed(for: colorScheme) : appState.accentColor

        Button {
            Haptics.selection()
            if isMeasuring {
                tools.stopPulseMeasurement()
            } else {
                tools.startPulseMeasurement()
            }
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: isMeasuring ? "stop.fill" : "play.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(isMeasuring ? L10n.Tools.turnOff : L10n.Tools.startMeter)
                    .font(Typography.headlineValue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(Theme.contrastingForeground(for: buttonBg))
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(buttonBg)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
    }
}

#Preview {
    NavigationStack {
        PulseMeterDetailView()
    }
}
