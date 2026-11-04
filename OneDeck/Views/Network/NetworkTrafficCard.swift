//
//  NetworkTrafficCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Real-time network throughput sampler and sparkline chart card.
//

import Charts
import SwiftUI

struct NetworkTrafficCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @State private var showSpeedTestSheet: Bool = false

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            latestSpeedTestBanner
            instantSpeedCounters
            waveformSection
            Divider().opacity(0.3)
            cumulativeTotalsSection
        }
        .bentoCard(accent: appState.accentColor)
        .sheet(isPresented: $showSpeedTestSheet) {
            NetworkSpeedTestSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(title: L10n.Network.trafficTitle, icon: "arrow.up.arrow.down.circle.fill")

            Spacer()

            // Single Speed Test Trigger Button
            Button {
                Haptics.impact(.medium)
                showSpeedTestSheet = true
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "gauge.with.needle.fill")
                        .font(IconTheme.actionButton)

                    Text(L10n.Network.speedTestTitle)
                        .font(Typography.captionBold)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.tight)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
            }
        }
    }

    @ViewBuilder
    private var latestSpeedTestBanner: some View {
        if let last = net.latestSpeedTestRecord {
            Button {
                Haptics.selection()
                showSpeedTestSheet = true
            } label: {
                HStack(spacing: SpacingTheme.standard) {
                    Image(systemName: "gauge.with.needle.fill")
                        .font(IconTheme.actionButton)
                        .foregroundStyle(appState.accentColor)

                    Text(L10n.Network.lastSpeedTest)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .fixedSize()

                    let ratingText = L10n.Network.speedTestRatingText(for: last.downloadMbps)
                    if !ratingText.isEmpty {
                        Text(ratingText)
                            .font(Typography.badgeTag)
                            .foregroundStyle(appState.accentColor)
                            .lineLimit(1)
                    }

                    Spacer(minLength: SpacingTheme.tight)

                    HStack(spacing: SpacingTheme.compact) {
                        Text("↓\(String(format: "%.1f", last.downloadMbps))M")
                            .font(Typography.badgeTagMono)
                            .foregroundStyle(appState.accentColor)
                            .lineLimit(1)
                            .fixedSize()

                        Text("↑\(String(format: "%.1f", last.uploadMbps))M")
                            .font(Typography.badgeTagMono)
                            .foregroundStyle(ChartTheme.uploadColor)
                            .lineLimit(1)
                            .fixedSize()

                        Text("\(String(format: "%.0f", last.pingMs))ms")
                            .font(Typography.badgeTagMonoMedium)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)
                            .fixedSize()

                        Image(systemName: "chevron.right")
                            .font(IconTheme.badgeInline)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    }
                }
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.standard)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .fill(colorScheme == .dark ? appState.accentColor.opacity(0.08) : Theme.cardBackground(for: colorScheme).opacity(0.8))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .stroke(colorScheme == .dark ? appState.accentColor.opacity(0.2) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var instantSpeedCounters: some View {
        HStack(spacing: SpacingTheme.rowStandard) {
            let down = formatRate(net.downloadSpeedBps)
            speedBlock(
                direction: "arrow.down.circle.fill",
                color: appState.accentColor,
                label: L10n.Network.downloadSpeed,
                value: down.value,
                unit: down.unit
            )

            let up = formatRate(net.uploadSpeedBps)
            speedBlock(
                direction: "arrow.up.circle.fill",
                color: ChartTheme.uploadColor,
                label: L10n.Network.uploadSpeed,
                value: up.value,
                unit: up.unit
            )
        }
    }

    @ViewBuilder
    private var waveformSection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            if net.trafficHistory.isEmpty {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
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
                        .foregroundStyle(ChartTheme.uploadColor)
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
    }

    @ViewBuilder
    private var cumulativeTotalsSection: some View {
        HStack {
            HStack(spacing: SpacingTheme.compact) {
                Image(systemName: "arrow.down.circle.fill")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(appState.accentColor)

                Text(L10n.Network.totalIn)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                Text(formatTotalBytes(net.totalBytesIn))
                    .font(Typography.calloutMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            Spacer()

            HStack(spacing: SpacingTheme.compact) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(ChartTheme.uploadColor)

                Text(L10n.Network.totalOut)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                Text(formatTotalBytes(net.totalBytesOut))
                    .font(Typography.calloutMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }
        }
    }

    // MARK: - Helpers
    @ViewBuilder
    private func speedBlock(direction: String, color: Color, label: String, value: String, unit: String) -> some View {
        HStack(spacing: SpacingTheme.standard) {
            Image(systemName: direction)
                .font(IconTheme.sectionHeader)
                .foregroundStyle(color)
                .frame(width: 22, height: 22, alignment: .center)

            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(label)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)

                HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                    Text(value)
                        .font(Typography.headlineValue)
                        .fontDesign(.monospaced)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Text(unit)
                        .font(Typography.badgeTag)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    private func formatRate(_ bps: Double) -> (value: String, unit: String) {
        let safeBps = (bps.isFinite && bps >= 0) ? bps : 0.0
        if safeBps >= 1024 * 1024 {
            let mb = safeBps / (1024.0 * 1024.0)
            return (String(format: "%.1f", mb), "MB/s")
        } else if safeBps >= 1024 {
            let kb = safeBps / 1024.0
            return (String(format: "%.0f", kb), "KB/s")
        } else {
            return (String(format: "%.0f", safeBps), "B/s")
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

// MARK: - Preview
#Preview {
    NetworkTrafficCard()
        .padding()
}
