//
//  OverviewCpuCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Real-time multi-core CPU load and cluster telemetry card.
//

import Charts
import SwiftUI

struct OverviewCpuCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            waveformSection
            coreLoadSection
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        HStack {
            OverviewSectionHeader(title: L10n.Overview.cpuMonitor, icon: "cpu.fill")

            Spacer()

            // Total CPU Load Percentage
            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                Text(String(format: "%.1f", system.totalCpuUsage))
                    .font(Typography.title1)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(appState.accentColor)

                Text("%")
                    .font(Typography.calloutLabel)
                    .fontWeight(.bold)
                    .foregroundStyle(appState.accentColor.opacity(0.8))
            }
        }
    }

    @ViewBuilder
    private var waveformSection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            HStack {
                Text(L10n.Overview.cpuHistoryChart)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)

                Spacer()

                Text(L10n.Overview.live30s)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
            }

            ZStack(alignment: .topLeading) {
                // Layer 1: Dashed Grid Lines (Spanning full width) & Far-Right Aligned Labels
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    let labelWidth: CGFloat = 28
                    let gridColor = ChartTheme.gridColor(for: colorScheme)
                    let lineEndX = max(0, w - labelWidth - SpacingTheme.tight)
                    let y100: CGFloat = 5
                    let y50: CGFloat = h * 0.5

                    // 100% Horizontal Grid Line
                    HorizontalDashedLine()
                        .stroke(gridColor, style: ChartTheme.gridStroke)
                        .frame(width: lineEndX, height: 1)
                        .position(x: lineEndX / 2, y: y100)

                    // 100% Percentage Label
                    Text("100%")
                        .font(ChartTheme.compactAxisLabelFont)
                        .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                        .frame(width: labelWidth, alignment: .trailing)
                        .position(x: w - labelWidth / 2, y: y100)

                    // 50% Horizontal Grid Line
                    HorizontalDashedLine()
                        .stroke(gridColor, style: ChartTheme.gridStroke)
                        .frame(width: lineEndX, height: 1)
                        .position(x: lineEndX / 2, y: y50)

                    // 50% Percentage Label
                    Text("50%")
                        .font(ChartTheme.compactAxisLabelFont)
                        .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                        .frame(width: labelWidth, alignment: .trailing)
                        .position(x: w - labelWidth / 2, y: y50)
                }

                // Layer 2: Real-time CPU Area & Line Waveform
                Chart {
                    ForEach(system.cpuHistory) { point in
                        LineMark(
                            x: .value("Time", point.timestamp),
                            y: .value("Load", point.value)
                        )
                        .interpolationMethod(.monotone)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(appState.accentColor)

                        AreaMark(
                            x: .value("Time", point.timestamp),
                            y: .value("Load", point.value)
                        )
                        .interpolationMethod(.monotone)
                        .foregroundStyle(ChartTheme.areaGradient(for: appState.accentColor))
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartYScale(domain: 0 ... 100)
                .padding(.trailing, ChartTheme.trailingMargin)
                .allowsHitTesting(false)
            }
            .frame(height: 54)
        }
    }

    @ViewBuilder
    private var coreLoadSection: some View {
        HStack(spacing: SpacingTheme.compact) {
            ForEach(Array(system.coreUsages.enumerated()), id: \.offset) { index, usage in
                let isPCore = index < system.hardwareSpecs.pCores
                let coreTag = isPCore ? "P\(index + 1)" : "E\(index - system.hardwareSpecs.pCores + 1)"

                VStack(spacing: SpacingTheme.tight) {
                    GeometryReader { geo in
                        ZStack(alignment: .bottom) {
                            // Background track
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.05))

                            // Dynamic level fill
                            let fillH = max(4, geo.size.height * CGFloat(usage / 100.0))
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            usage > 85 ? Color.orange : appState.accentColor,
                                            usage > 85 ? Color.orange.opacity(0.7) : appState.accentColor.opacity(0.6)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(height: fillH)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: usage)
                    }
                    .frame(height: 54)

                    Text(coreTag)
                        .font(Typography.badgeTag)
                        .fontDesign(.monospaced)
                        .foregroundStyle(isPCore ? appState.accentColor : Theme.textTertiary(for: colorScheme))
                        .lineLimit(1)

                    Text(String(format: "%.0f%%", usage))
                        .font(Typography.badgeTag)
                        .monospacedDigit()
                        .lineLimit(1)
                        .foregroundStyle(usage > 85 ? Color.orange : Theme.textSecondary(for: colorScheme))
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, SpacingTheme.tight)
    }
}

// MARK: - Preview
#Preview {
    OverviewCpuCard()
        .padding()
}
