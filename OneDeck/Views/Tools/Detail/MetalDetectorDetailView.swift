//
//  MetalDetectorDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Magnetic flux density and metal detector workspace.
//

import Charts
import SwiftUI

struct MetalDetectorDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    private var isMagnetometerAvailable: Bool {
        tools.isMagnetometerAvailable
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            let gaugeSize = max(150, min(230, geo.size.width - 64, geo.size.height * 0.36))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    if !isMagnetometerAvailable {
                        hardwareUnavailableBanner
                    }

                    // Top Vector Readouts
                    vectorBreakdownRow

                    Spacer(minLength: 0)

                    // Center Flux Meter Gauge
                    magneticFluxGauge(size: gaugeSize)

                    Spacer(minLength: 0)

                    // Live Oscilloscope Waveform
                    fluxWaveformSection

                    // Bottom Action Controls
                    bottomControlsBar
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
                .frame(maxWidth: .infinity, minHeight: geo.size.height)
            }
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.metalDetector)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .metalDetector)
            tools.startMagnetometer(interval: 1.0 / 30.0)
        }
        .onDisappear {
            tools.stopMagnetometer()
            tools.leaveDetailView()
        }
    }

    @ViewBuilder
    private var hardwareUnavailableBanner: some View {
        HStack(spacing: SpacingTheme.tight) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color.orange)
            Text(L10n.Tools.magnetometerHardwareUnavailable)
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

    // MARK: - Vector Breakdown
    @ViewBuilder
    private var vectorBreakdownRow: some View {
        let safeX = tools.metalDetector.xMicroTesla.isFinite ? tools.metalDetector.xMicroTesla : 0.0
        let safeY = tools.metalDetector.yMicroTesla.isFinite ? tools.metalDetector.yMicroTesla : 0.0
        let safeZ = tools.metalDetector.zMicroTesla.isFinite ? tools.metalDetector.zMicroTesla : 0.0
        let safeDelta = tools.metalDetector.deltaMicroTesla.isFinite ? tools.metalDetector.deltaMicroTesla : 0.0

        HStack(spacing: SpacingTheme.standard) {
            axisCell(title: "Bx", value: String(format: "%+.0f", safeX))
            axisCell(title: "By", value: String(format: "%+.0f", safeY))
            axisCell(title: "Bz", value: String(format: "%+.0f", safeZ))
            axisCell(title: L10n.Tools.deltaLabel, value: String(format: "+%.0f", safeDelta))
        }
    }

    @ViewBuilder
    private func axisCell(title: String, value: String) -> some View {
        VStack(spacing: SpacingTheme.micro) {
            Text(title)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
            Text("\(value) µT")
                .font(Typography.captionMono)
                .foregroundStyle(appState.accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
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

    // MARK: - Magnetic Flux Gauge
    @ViewBuilder
    private func magneticFluxGauge(size: CGFloat) -> some View {
        let rawSignal = tools.metalDetector.normalizedSignal.isFinite ? tools.metalDetector.normalizedSignal : 0.0
        let signal = min(1.0, max(0.0, rawSignal))
        let safeTotal = tools.metalDetector.totalMicroTesla.isFinite ? tools.metalDetector.totalMicroTesla : 0.0
        let safeDelta = tools.metalDetector.deltaMicroTesla.isFinite ? tools.metalDetector.deltaMicroTesla : 0.0
        let alertColor = signal > 0.6 ? Color.red : (signal > 0.3 ? Color.orange : appState.accentColor)

        ZStack {
            // Background Gauge Track (240-degree arc)
            Circle()
                .trim(from: 0.15, to: 0.85)
                .stroke(Theme.cardBorder(for: colorScheme), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(90))
                .frame(width: size, height: size)

            // Dynamic Signal Fill Arc
            Circle()
                .trim(from: 0.15, to: 0.15 + (0.70 * CGFloat(signal)))
                .stroke(
                    AngularGradient(
                        colors: [appState.accentColor, alertColor],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(90))
                .frame(width: size, height: size)
                .animation(.easeOut(duration: 0.15), value: signal)

            // Center Reading
            VStack(spacing: SpacingTheme.micro) {
                Text(String(format: "%.0f", safeTotal))
                    .font(Typography.displayHero)
                    .monospacedDigit()
                    .foregroundStyle(alertColor)

                Text("µT")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                if safeDelta > 15.0 {
                    Text(L10n.Tools.metalDetected)
                        .font(Typography.microAxis)
                        .foregroundStyle(alertColor)
                        .padding(.horizontal, SpacingTheme.standard)
                        .padding(.vertical, SpacingTheme.micro)
                        .background(alertColor.opacity(0.14))
                        .clipShape(Capsule())
                }
            }
        }
        .frame(width: size, height: size)
    }

    // MARK: - Oscilloscope Waveform
    @ViewBuilder
    private var fluxWaveformSection: some View {
        let validHistory = tools.metalDetector.history.filter { $0.value.isFinite }
        let safeBaseline = tools.metalDetector.baselineMicroTesla.isFinite ? tools.metalDetector.baselineMicroTesla : 45.0

        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
            HStack {
                Text(L10n.Tools.oscilloscope)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                Spacer()
                Text("\(L10n.Tools.baselineLabel): \(String(format: "%.0f", safeBaseline)) µT")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            if validHistory.isEmpty {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                    .frame(height: 70)
            } else {
                Chart {
                    ForEach(validHistory) { pt in
                        LineMark(
                            x: .value("Time", pt.timestamp),
                            y: .value("Flux", pt.value)
                        )
                        .foregroundStyle(appState.accentColor)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)

                        AreaMark(
                            x: .value("Time", pt.timestamp),
                            y: .value("Flux", pt.value)
                        )
                        .foregroundStyle(ChartTheme.areaGradient(for: appState.accentColor))
                        .interpolationMethod(.monotone)
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(height: 70)
            }
        }
        .padding(.horizontal, SpacingTheme.rowStandard)
        .padding(.vertical, SpacingTheme.compact)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    // MARK: - Bottom Controls Bar
    @ViewBuilder
    private var bottomControlsBar: some View {
        HStack(spacing: SpacingTheme.standard) {
            // Calibrate Baseline Button
            Button {
                tools.calibrateMetalDetectorBaseline()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "circle.circle.fill")
                        .font(IconTheme.actionButton)
                    Text(L10n.Tools.calibrate)
                        .font(Typography.captionBold)
                }
                .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(appState.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .buttonStyle(.plain)

            // Geiger Click Sound Toggle Button
            Button {
                tools.toggleGeigerAudio()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: tools.metalDetector.isGeigerAudioActive ? "speaker.wave.3.fill" : "speaker.slash.fill")
                        .font(IconTheme.actionButton)
                    Text(L10n.Tools.geigerTick)
                        .font(Typography.captionBold)
                }
                .foregroundStyle(tools.metalDetector.isGeigerAudioActive ? Color.orange : Theme.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(tools.metalDetector.isGeigerAudioActive ? Color.orange.opacity(0.14) : Theme.cardBackground(for: colorScheme).opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(tools.metalDetector.isGeigerAudioActive ? Color.orange.opacity(0.4) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        MetalDetectorDetailView()
    }
}
