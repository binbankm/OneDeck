//
//  NetworkTrafficCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Real-Time Traffic Card: Real-Time Throughput Sampler, Charts Waveform & Speed Test Sheet.
//

import SwiftUI
import Charts

struct NetworkTrafficCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var net = NetworkService.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var showSpeedTestSheet: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // MARK: - Header
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(appState.accentColor.opacity(0.12))
                        .frame(width: 30, height: 30)

                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(appState.accentColor)
                }

                Text(L10n.Network.trafficTitle)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Spacer()

                // Single Speed Test Trigger Button
                Button {
                    Haptics.impact(.medium)
                    showSpeedTestSheet = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                            .font(.system(size: 11, weight: .semibold))

                        Text(L10n.Network.speedTestTitle)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .foregroundStyle(appState.accentColor)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(appState.accentColor.opacity(0.12))
                    .clipShape(Capsule())
                }
            }

            // MARK: - Completed Test Summary Banner (Tap to view details in sheet)
            if let last = net.latestSpeedTestRecord {
                Button {
                    Haptics.selection()
                    showSpeedTestSheet = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "gauge.with.dots.needle.67percent")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(appState.accentColor)

                        Text(L10n.Network.lastSpeedTest)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)
                            .fixedSize()

                        if !last.rating.isEmpty {
                            Text(last.rating)
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                .foregroundStyle(appState.accentColor)
                                .lineLimit(1)
                        }

                        Spacer(minLength: 4)

                        HStack(spacing: 6) {
                            Text("↓\(String(format: "%.1f", last.downloadMbps))M")
                                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                .foregroundStyle(appState.accentColor)
                                .lineLimit(1)
                                .fixedSize()

                            Text("↑\(String(format: "%.1f", last.uploadMbps))M")
                                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                .foregroundStyle(Color.mint)
                                .lineLimit(1)
                                .fixedSize()

                            Text("\(String(format: "%.0f", last.pingMs))ms")
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                .lineLimit(1)
                                .fixedSize()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(appState.accentColor.opacity(0.06))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(appState.accentColor.opacity(0.18), lineWidth: 0.8)
                    )
                }
                .buttonStyle(.plain)
            }

            // MARK: - Instant Speed Counters
            HStack(spacing: 12) {
                // Download
                let down = formatRate(net.downloadSpeedBps)
                speedBlock(
                    direction: "arrow.down",
                    color: appState.accentColor,
                    label: L10n.Network.downloadSpeed,
                    value: down.value,
                    unit: down.unit
                )

                // Upload
                let up = formatRate(net.uploadSpeedBps)
                speedBlock(
                    direction: "arrow.up",
                    color: Color.mint,
                    label: L10n.Network.uploadSpeed,
                    value: up.value,
                    unit: up.unit
                )
            }

            // MARK: - Swift Charts Real-time Throughput Waveform
            VStack(alignment: .leading, spacing: 4) {
                if net.trafficHistory.isEmpty {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                        .frame(height: 100)
                } else {
                    Chart {
                        ForEach(net.trafficHistory) { pt in
                            LineMark(
                                x: .value("Time", pt.timestamp),
                                y: .value("Rate", pt.downBps / 1024.0),
                                series: .value("Direction", "Down")
                            )
                            .foregroundStyle(appState.accentColor)
                            .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.monotone)

                            AreaMark(
                                x: .value("Time", pt.timestamp),
                                y: .value("Rate", pt.downBps / 1024.0)
                            )
                            .foregroundStyle(ChartTheme.areaGradient(for: appState.accentColor))
                            .interpolationMethod(.monotone)

                            LineMark(
                                x: .value("Time", pt.timestamp),
                                y: .value("Rate", pt.upBps / 1024.0),
                                series: .value("Direction", "Up")
                            )
                            .foregroundStyle(Color.mint)
                            .lineStyle(StrokeStyle(lineWidth: ChartTheme.subLineWidth, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.monotone)
                        }
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis {
                        AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) { val in
                            AxisGridLine(stroke: ChartTheme.gridStroke)
                                .foregroundStyle(ChartTheme.gridColor(for: colorScheme))
                            AxisValueLabel {
                                if let kb = val.as(Double.self) {
                                    if kb >= 1024 {
                                        Text(String(format: "%.1fM", kb / 1024.0))
                                            .font(ChartTheme.axisLabelFont)
                                            .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                                    } else {
                                        Text(String(format: "%.0fK", kb))
                                            .font(ChartTheme.axisLabelFont)
                                            .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 100)
                }
            }

            Divider().opacity(0.3)

            // MARK: - Cumulative Session Totals
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.down.to.line.compact")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(appState.accentColor)

                    Text(L10n.Network.totalIn)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                    Text(formatTotalBytes(net.totalBytesIn))
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.to.line.compact")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.mint)

                    Text(L10n.Network.totalOut)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                    Text(formatTotalBytes(net.totalBytesOut))
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
        .sheet(isPresented: $showSpeedTestSheet) {
            NetworkSpeedTestSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Subviews & Helpers

    @ViewBuilder
    private func speedBlock(direction: String, color: Color, label: String, value: String, unit: String) -> some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 28, height: 28)

                Image(systemName: direction)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(value)
                        .font(.system(size: 17, weight: .bold, design: .monospaced))
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Text(unit)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    private func formatRate(_ bps: Double) -> (value: String, unit: String) {
        if bps >= 1024 * 1024 {
            let mb = bps / (1024.0 * 1024.0)
            return (String(format: "%.1f", mb), "MB/s")
        } else if bps >= 1024 {
            let kb = bps / 1024.0
            return (String(format: "%.0f", kb), "KB/s")
        } else {
            return (String(format: "%.0f", max(0, bps)), "B/s")
        }
    }

    private func formatTotalBytes(_ bytes: UInt64) -> String {
        let b = Double(bytes)
        if b >= 1024 * 1024 * 1024 {
            return String(format: "%.2f GB", b / (1024.0 * 1024.0 * 1024.0))
        } else if b >= 1024 * 1024 {
            return String(format: "%.1f MB", b / (1024.0 * 1024.0))
        } else if b >= 1024 {
            return String(format: "%.0f KB", b / 1024.0)
        } else {
            return "\(bytes) B"
        }
    }
}
