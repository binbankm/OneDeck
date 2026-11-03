//
//  MetalDetectorDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Magnetic Flux & Ferromagnetic Stud / Wire Detector Fullscreen Workspace.
//

import SwiftUI
import Charts

struct MetalDetectorDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: SpacingTheme.cardStack) {
                // Top Vector Readouts
                vectorBreakdownRow

                Spacer()

                // Center Flux Meter Gauge
                magneticFluxGauge(size: max(120, min(geometry.size.width - 48, 250)))

                Spacer()

                // Live Oscilloscope Waveform
                fluxWaveformSection

                // Bottom Action Controls
                bottomControlsBar
            }
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.metalDetector)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView()
            tools.startMagnetometer(interval: 1.0 / 30.0)
        }
        .onDisappear {
            tools.leaveDetailView()
            tools.startMagnetometer(interval: 1.0 / 10.0)
        }
    }

    // MARK: - Vector Breakdown
    @ViewBuilder
    private var vectorBreakdownRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            axisCell(title: "Bx", value: String(format: "%+.0f", tools.metalDetector.xMicroTesla))
            axisCell(title: "By", value: String(format: "%+.0f", tools.metalDetector.yMicroTesla))
            axisCell(title: "Bz", value: String(format: "%+.0f", tools.metalDetector.zMicroTesla))
            axisCell(title: L10n.Tools.deltaLabel, value: String(format: "+%.0f", tools.metalDetector.deltaMicroTesla))
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
        let signal = tools.metalDetector.normalizedSignal
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
                Text(String(format: "%.0f", tools.metalDetector.totalMicroTesla))
                    .font(Typography.displayHero)
                    .monospacedDigit()
                    .foregroundStyle(alertColor)

                Text("µT")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                if tools.metalDetector.deltaMicroTesla > 15.0 {
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
        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
            HStack {
                Text(L10n.Tools.oscilloscope)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                Spacer()
                Text("\(L10n.Tools.baselineLabel): \(String(format: "%.0f", tools.metalDetector.baselineMicroTesla)) µT")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            if tools.metalDetector.history.isEmpty {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                    .frame(height: 70)
            } else {
                Chart {
                    ForEach(tools.metalDetector.history) { pt in
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
                .foregroundStyle(Color.black)
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

