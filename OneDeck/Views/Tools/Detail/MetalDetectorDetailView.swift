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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    private var isMagnetometerAvailable: Bool {
        tools.isMagnetometerAvailable
    }

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            let gaugeSize = max(150, min(230, geo.size.width - 64, geo.size.height * 0.36))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    if !isMagnetometerAvailable {
                        ToolNoticeBanner(
                            icon: "exclamationmark.triangle.fill",
                            message: L10n.Tools.magnetometerHardwareUnavailable
                        )
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
                .frame(maxWidth: LayoutTheme.maxContentWidth, minHeight: geo.size.height)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
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

    // MARK: - Vector Breakdown
    @ViewBuilder
    private var vectorBreakdownRow: some View {
        let safeX = tools.metalDetector.xMicroTesla.isFinite ? tools.metalDetector.xMicroTesla : 0.0
        let safeY = tools.metalDetector.yMicroTesla.isFinite ? tools.metalDetector.yMicroTesla : 0.0
        let safeZ = tools.metalDetector.zMicroTesla.isFinite ? tools.metalDetector.zMicroTesla : 0.0
        let safeDelta = tools.metalDetector.deltaMicroTesla.isFinite ? tools.metalDetector.deltaMicroTesla : 0.0
        let colCount = dynamicTypeSize.isAccessibilitySize ? 2 : 4
        let columns = Array(repeating: GridItem(.flexible(), spacing: SpacingTheme.standard), count: colCount)

        LazyVGrid(columns: columns, spacing: SpacingTheme.standard) {
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
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            Text("\(value) µT")
                .font(Typography.captionMono)
                .monospacedDigit()
                .foregroundStyle(accentFg)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
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
        .accessibilityValue("\(value) µT")
    }

    // MARK: - Magnetic Flux Gauge
    @ViewBuilder
    private func magneticFluxGauge(size: CGFloat) -> some View {
        let rawSignal = tools.metalDetector.normalizedSignal.isFinite ? tools.metalDetector.normalizedSignal : 0.0
        let signal = min(1.0, max(0.0, rawSignal))
        let safeTotal = tools.metalDetector.totalMicroTesla.isFinite ? tools.metalDetector.totalMicroTesla : 0.0
        let safeDelta = tools.metalDetector.deltaMicroTesla.isFinite ? tools.metalDetector.deltaMicroTesla : 0.0
        let alertColor = signal > 0.6
            ? Theme.readableRed(for: colorScheme)
            : (signal > 0.3 ? Theme.readableOrange(for: colorScheme) : accentFg)
        let totalText = String(format: "%.0f", safeTotal)

        ZStack {
            // Background Gauge Track (240-degree arc)
            Circle()
                .trim(from: 0.15, to: 0.85)
                .stroke(Theme.tileBorder(for: colorScheme), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(90))
                .frame(width: size, height: size)

            // Dynamic Signal Fill Arc
            Circle()
                .trim(from: 0.15, to: 0.15 + (0.70 * CGFloat(signal)))
                .stroke(
                    AngularGradient(
                        colors: [accentFg, alertColor],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(90))
                .frame(width: size, height: size)
                .animation(.easeOut(duration: 0.15), value: signal)

            // Center Reading
            VStack(spacing: SpacingTheme.micro) {
                Text(totalText)
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Tools.metalDetector)
        .accessibilityValue(safeDelta > 15.0 ? "\(totalText) µT, \(L10n.Tools.metalDetected)" : "\(totalText) µT")
    }

    // MARK: - Oscilloscope Waveform
    @ViewBuilder
    private var fluxWaveformSection: some View {
        let validHistory = tools.metalDetector.history.filter { $0.value.isFinite }
        let safeBaseline = tools.metalDetector.baselineMicroTesla.isFinite ? tools.metalDetector.baselineMicroTesla : 45.0
        let baselineString = "\(L10n.Tools.baselineLabel): \(String(format: "%.0f", safeBaseline)) µT"

        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            HStack {
                Text(L10n.Tools.oscilloscope)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                Spacer()
                Text(baselineString)
                    .font(Typography.badgeTagMono)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            if validHistory.isEmpty {
                BentoEmptyStateView(
                    icon: "waveform.path.ecg",
                    message: L10n.Tools.waitingForSamples,
                    showsProgress: tools.isMagnetometerActive,
                    height: 84
                )
            } else {
                Chart {
                    ForEach(validHistory) { pt in
                        LineMark(
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Tools.chartFluxAxis, pt.value)
                        )
                        .foregroundStyle(accentFg)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)

                        AreaMark(
                            x: .value(L10n.Tools.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Tools.chartFluxAxis, pt.value)
                        )
                        .foregroundStyle(ChartTheme.areaGradient(for: accentFg))
                        .interpolationMethod(.monotone)
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(height: 84)
                .accessibilityHidden(true)
            }
        }
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
        .accessibilityLabel(L10n.Tools.oscilloscope)
        .accessibilityValue(validHistory.isEmpty ? L10n.Tools.waitingForSamples : baselineString)
    }

    // MARK: - Bottom Controls Bar
    @ViewBuilder
    private var bottomControlsBar: some View {
        let orangeAccent = Theme.readableOrange(for: colorScheme)
        let isGeigerActive = tools.metalDetector.isGeigerAudioActive

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        layout {
            // Calibrate Baseline Button
            Button {
                tools.calibrateMetalDetectorBaseline()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "circle.circle.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                    Text(L10n.Tools.calibrate)
                        .font(Typography.captionBold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
                .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                .background(appState.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())

            // Geiger Click Sound Toggle Button
            Button {
                tools.toggleGeigerAudio()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: isGeigerActive ? "speaker.wave.3.fill" : "speaker.slash.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                    Text(L10n.Tools.geigerTick)
                        .font(Typography.captionBold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                .foregroundStyle(isGeigerActive ? orangeAccent : Theme.textPrimary(for: colorScheme))
                .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(isGeigerActive ? orangeAccent.opacity(0.14) : Theme.tileBackground(for: colorScheme))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(isGeigerActive ? orangeAccent.opacity(0.45) : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())
            .accessibilityAddTraits(isGeigerActive ? .isSelected : [])
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        MetalDetectorDetailView()
    }
}
