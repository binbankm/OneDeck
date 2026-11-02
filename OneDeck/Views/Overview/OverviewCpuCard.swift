//
//  OverviewCpuCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  CPU Telemetry: 30s Rolling Waveform, Multi-Core Distribution & Dynamic Level Meters.
//

import SwiftUI
import Charts

struct OverviewCpuCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var system = SystemService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Row
            HStack {
                OverviewSectionHeader(title: L10n.Overview.cpuMonitor, icon: "cpu.fill")

                Spacer()

                // Total CPU Load Percentage
                HStack(alignment: .firstTextBaseline, spacing: 1) {
                    Text(String(format: "%.1f", system.totalCpuUsage))
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .foregroundStyle(appState.accentColor)

                    Text("%")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(appState.accentColor.opacity(0.8))
                }
            }

            // Real-Time Waveform Chart
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(L10n.Overview.cpuHistoryChart)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)

                    Spacer()

                    Text(L10n.Overview.live30s)
                        .font(.system(size: 10, design: .monospaced))
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
                        let lineEndX = max(0, w - labelWidth - 4)
                        let y100: CGFloat = 5
                        let y50: CGFloat = h * 0.5

                        // 100% Horizontal Grid Line
                        HorizontalDashedLine()
                            .stroke(gridColor, style: ChartTheme.gridStroke)
                            .frame(width: lineEndX, height: 1)
                            .position(x: lineEndX / 2, y: y100)

                        // 100% Percentage Label (Far Right Aligned, flush with card header "30s Rolling")
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

                        // 50% Percentage Label (Far Right Aligned, exactly matching 100% right edge)
                        Text("50%")
                            .font(ChartTheme.compactAxisLabelFont)
                            .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                            .frame(width: labelWidth, alignment: .trailing)
                            .position(x: w - labelWidth / 2, y: y50)
                    }

                    // Layer 2: Real-time CPU Area & Line Waveform
                    // Inset on trailing by 32pt so the waveform stops safely before 100% and 50% labels
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
                    .chartYScale(domain: 0...100)
                    .padding(.trailing, 32)
                    .allowsHitTesting(false)
                }
                .frame(height: 54)
            }

            // Discrete Core Load Columns (Refined Geometric Level Meters)
            HStack(spacing: 6) {
                ForEach(Array(system.coreUsages.enumerated()), id: \.offset) { index, usage in
                    let isPCore = index < system.hardwareSpecs.pCores
                    let coreTag = isPCore ? "P\(index + 1)" : "E\(index - system.hardwareSpecs.pCores + 1)"

                    VStack(spacing: 4) {
                        GeometryReader { geo in
                            ZStack(alignment: .bottom) {
                                // Background track
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
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
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: usage)
                        }
                        .frame(height: 54)

                        Text(coreTag)
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundStyle(isPCore ? appState.accentColor : Theme.textTertiary(for: colorScheme))
                            .lineLimit(1)

                        Text(String(format: "%.0f%%", usage))
                            .font(.system(size: 9, weight: .semibold, design: .rounded))
                            .monospacedDigit()
                            .lineLimit(1)
                            .foregroundStyle(usage > 85 ? Color.orange : Theme.textSecondary(for: colorScheme))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 4)
        }
        .bentoCard(accent: appState.accentColor)
    }
}

