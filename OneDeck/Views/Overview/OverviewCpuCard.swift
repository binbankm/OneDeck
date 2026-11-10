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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    private var safeTotalCpu: Double {
        min(100.0, max(0.0, system.totalCpuUsage.isFinite ? system.totalCpuUsage : 0.0))
    }

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
                Text(String(format: "%.1f", safeTotalCpu))
                    .font(Typography.title1)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(accentFg)

                Text("%")
                    .font(Typography.calloutBold)
                    .foregroundStyle(accentFg.opacity(0.85))
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Overview.cpuTotalUsage)
            .accessibilityValue(String(format: "%.1f%%", safeTotalCpu))
        }
    }

    @ViewBuilder
    private var waveformSection: some View {
        let validHistory = system.cpuHistory.filter { $0.value.isFinite }

        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            HStack {
                Text(L10n.Overview.cpuHistoryChart)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer()

                Text(L10n.Overview.live30s)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            if validHistory.count > 1 {
                ZStack(alignment: .topLeading) {
                    // Layer 1: Dashed Grid Lines (Spanning full width) & Far-Right Aligned Labels
                    VStack(spacing: SpacingTheme.none) {
                        HStack(spacing: SpacingTheme.tight) {
                            HorizontalDashedLine()
                                .stroke(ChartTheme.gridColor(for: colorScheme), style: ChartTheme.gridStroke)
                                .frame(height: 1)

                            Text("100%")
                                .font(ChartTheme.compactAxisLabelFont)
                                .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                                .frame(width: ChartTheme.trailingMargin - SpacingTheme.tight, alignment: .trailing)
                        }
                        .padding(.top, SpacingTheme.tight)

                        Spacer()

                        HStack(spacing: SpacingTheme.tight) {
                            HorizontalDashedLine()
                                .stroke(ChartTheme.gridColor(for: colorScheme), style: ChartTheme.gridStroke)
                                .frame(height: 1)

                            Text("50%")
                                .font(ChartTheme.compactAxisLabelFont)
                                .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                                .frame(width: ChartTheme.trailingMargin - SpacingTheme.tight, alignment: .trailing)
                        }

                        Spacer()
                    }

                    // Layer 2: Real-time CPU Area & Line Waveform
                    Chart {
                        ForEach(validHistory) { point in
                            LineMark(
                                x: .value(L10n.Overview.chartTimeAxis, point.timestamp),
                                y: .value(L10n.Overview.chartLoadAxis, point.value)
                            )
                            .interpolationMethod(.monotone)
                            .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                            .foregroundStyle(appState.accentColor)

                            AreaMark(
                                x: .value(L10n.Overview.chartTimeAxis, point.timestamp),
                                y: .value(L10n.Overview.chartLoadAxis, point.value)
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
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(L10n.Overview.cpuHistoryChart)
                .accessibilityValue(String(format: "%.1f%%", safeTotalCpu))
            } else {
                BentoEmptyStateView(
                    icon: "waveform.path.ecg",
                    message: L10n.Overview.cpuHistoryChart,
                    showsProgress: true,
                    height: 54
                )
            }
        }
    }

    @ViewBuilder
    private var coreLoadSection: some View {
        let cores = Array(system.coreUsages.enumerated())
        if cores.count > 6 || dynamicTypeSize.isAccessibilitySize {
            let minColWidth: CGFloat = dynamicTypeSize.isAccessibilitySize ? 52 : 34
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: minColWidth), spacing: SpacingTheme.compact)],
                spacing: SpacingTheme.compact
            ) {
                ForEach(cores, id: \.offset) { index, usage in
                    coreBarItem(index: index, usage: usage)
                }
            }
            .padding(.top, SpacingTheme.tight)
        } else {
            HStack(spacing: SpacingTheme.compact) {
                ForEach(cores, id: \.offset) { index, usage in
                    coreBarItem(index: index, usage: usage)
                }
            }
            .padding(.top, SpacingTheme.tight)
        }
    }

    @ViewBuilder
    private func coreBarItem(index: Int, usage: Double) -> some View {
        let isPCore = index < system.hardwareSpecs.pCores
        let coreTag = isPCore ? "P\(index + 1)" : "E\(index - system.hardwareSpecs.pCores + 1)"
        let clampedUsage = min(100.0, max(0.0, usage.isFinite ? usage : 0.0))
        let isHighLoad = clampedUsage > 85
        let orangeFg = Theme.readableOrange(for: colorScheme)

        VStack(spacing: SpacingTheme.tight) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(Theme.chipBackground(for: colorScheme))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                if clampedUsage > 0 {
                    let fillH = max(3, 54.0 * CGFloat(clampedUsage / 100.0))
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    isHighLoad ? Color.orange : appState.accentColor,
                                    isHighLoad ? Color.orange.opacity(0.7) : appState.accentColor.opacity(0.6)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: fillH)
                }
            }
            .frame(height: 54)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            .animation(.easeInOut(duration: 0.3), value: clampedUsage)

            Text(coreTag)
                .font(Typography.badgeTagMono)
                .foregroundStyle(isPCore ? accentFg : Theme.textTertiary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(String(format: "%.0f%%", clampedUsage))
                .font(Typography.badgeTag)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .foregroundStyle(isHighLoad ? orangeFg : Theme.textSecondary(for: colorScheme))
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(coreTag)
        .accessibilityValue(String(format: "%.0f%%", clampedUsage))
    }
}

// MARK: - Preview
#Preview {
    OverviewCpuCard()
        .padding()
}
