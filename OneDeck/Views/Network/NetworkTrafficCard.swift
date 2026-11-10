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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @State private var showSpeedTestSheet: Bool = false

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    private var uploadAccentColor: Color {
        colorScheme == .dark ? ChartTheme.uploadColor : Theme.readableCyan(for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            latestSpeedTestBanner
            instantSpeedCounters
            waveformSection
            BentoHairlineDivider()
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
        let speedTestButton = Button {
            Haptics.impact(.medium)
            showSpeedTestSheet = true
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "gauge.with.needle.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)

                Text(L10n.Network.speedTestTitle)
                    .font(Typography.captionBold)
                    .lineLimit(1)
            }
            .foregroundStyle(accentFg)
            .padding(.horizontal, SpacingTheme.row)
            .frame(minHeight: LayoutTheme.minTapTarget)
            .background(appState.accentColor.opacity(0.12))
            .clipShape(Capsule())
            .contentShape(Capsule())
        }
        .buttonStyle(BentoCardButtonStyle())

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                BentoSectionHeader(title: L10n.Network.trafficTitle, icon: "arrow.up.arrow.down.circle.fill")
                speedTestButton
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                BentoSectionHeader(title: L10n.Network.trafficTitle, icon: "arrow.up.arrow.down.circle.fill")
                Spacer(minLength: SpacingTheme.compact)
                speedTestButton
            }
        }
    }

    @ViewBuilder
    private var latestSpeedTestBanner: some View {
        if let last = net.latestSpeedTestRecord {
            let safeDown = last.downloadMbps.isFinite ? last.downloadMbps : 0.0
            let safeUp = last.uploadMbps.isFinite ? last.uploadMbps : 0.0
            let safePing = last.pingMs.isFinite ? last.pingMs : 0.0
            let ratingText = L10n.Network.speedTestRatingText(for: last.downloadMbps)

            let titleGroup = HStack(spacing: SpacingTheme.standard) {
                Image(systemName: "gauge.with.needle.fill")
                    .font(IconTheme.actionButton)
                    .foregroundStyle(accentFg)
                    .accessibilityHidden(true)

                Text(L10n.Network.lastSpeedTest)
                    .font(Typography.captionBold)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                if !ratingText.isEmpty {
                    Text(ratingText)
                        .font(Typography.badgeTag)
                        .foregroundStyle(accentFg)
                        .lineLimit(1)
                }
            }

            let metricsGroup = HStack(spacing: SpacingTheme.compact) {
                Text("↓\(String(format: "%.1f", safeDown))M")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(accentFg)
                    .lineLimit(1)

                Text(safeUp > 0 ? "↑\(String(format: "%.1f", safeUp))M" : "↑--")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(uploadAccentColor)
                    .lineLimit(1)

                Text("\(String(format: "%.0f", safePing))ms")
                    .font(Typography.badgeTagMonoMedium)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)

                Image(systemName: "chevron.right")
                    .font(IconTheme.badgeInline)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .accessibilityHidden(true)
            }

            Button {
                Haptics.selection()
                showSpeedTestSheet = true
            } label: {
                Group {
                    if dynamicTypeSize.isAccessibilitySize {
                        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                            titleGroup
                            metricsGroup
                        }
                    } else {
                        HStack(spacing: SpacingTheme.standard) {
                            titleGroup
                            Spacer(minLength: SpacingTheme.tight)
                            metricsGroup
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget, alignment: .leading)
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.standard)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .fill(colorScheme == .dark ? appState.accentColor.opacity(0.08) : Theme.tileBackground(for: colorScheme))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .stroke(colorScheme == .dark ? accentFg.opacity(0.24) : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(L10n.Network.lastSpeedTest), \(ratingText)")
            .accessibilityValue(
                "\(L10n.Network.downloadSpeed) \(String(format: "%.1f", safeDown)) Mbps, " +
                "\(L10n.Network.uploadSpeed) \(safeUp > 0 ? String(format: "%.1f Mbps", safeUp) : L10n.Common.notAvailable)"
            )
            .accessibilityHint(L10n.Network.speedTestTitle)
        }
    }

    @ViewBuilder
    private var instantSpeedCounters: some View {
        let down = formatRate(net.downloadSpeedBps)
        let up = formatRate(net.uploadSpeedBps)
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.rowStandard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.rowStandard))

        layout {
            speedBlock(
                direction: "arrow.down.circle.fill",
                color: accentFg,
                label: L10n.Network.downloadSpeed,
                value: down.value,
                unit: down.unit
            )

            speedBlock(
                direction: "arrow.up.circle.fill",
                color: uploadAccentColor,
                label: L10n.Network.uploadSpeed,
                value: up.value,
                unit: up.unit
            )
        }
    }

    @ViewBuilder
    private var waveformSection: some View {
        let validHistory = net.trafficHistory.filter { $0.downBps.isFinite && $0.upBps.isFinite }
        let down = formatRate(net.downloadSpeedBps)
        let up = formatRate(net.uploadSpeedBps)

        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            if validHistory.isEmpty {
                BentoEmptyStateView(
                    icon: "waveform.path.ecg",
                    message: L10n.Network.waitingForSamples,
                    showsProgress: true,
                    height: 100
                )
            } else {
                Chart {
                    ForEach(validHistory) { pt in
                        LineMark(
                            x: .value(L10n.Network.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Network.chartRateAxis, pt.downBps / 1024.0),
                            series: .value(L10n.Network.chartDirectionAxis, L10n.Network.downloadSpeed)
                        )
                        .foregroundStyle(accentFg)
                        .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.monotone)

                        AreaMark(
                            x: .value(L10n.Network.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Network.chartRateAxis, pt.downBps / 1024.0)
                        )
                        .foregroundStyle(ChartTheme.areaGradient(for: appState.accentColor))
                        .interpolationMethod(.monotone)

                        LineMark(
                            x: .value(L10n.Network.chartTimeAxis, pt.timestamp),
                            y: .value(L10n.Network.chartRateAxis, pt.upBps / 1024.0),
                            series: .value(L10n.Network.chartDirectionAxis, L10n.Network.uploadSpeed)
                        )
                        .foregroundStyle(uploadAccentColor)
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
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(L10n.Network.trafficTitle)
                .accessibilityValue("\(L10n.Network.downloadSpeed) \(down.value) \(down.unit), \(L10n.Network.uploadSpeed) \(up.value) \(up.unit)")
            }
        }
    }

    @ViewBuilder
    private var cumulativeTotalsSection: some View {
        let totalInStr = formatTotalBytes(net.totalBytesIn)
        let totalOutStr = formatTotalBytes(net.totalBytesOut)

        let inBlock = HStack(spacing: SpacingTheme.compact) {
            Image(systemName: "arrow.down.circle.fill")
                .font(IconTheme.tileLeading)
                .foregroundStyle(accentFg)
                .accessibilityHidden(true)

            Text(L10n.Network.totalIn)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            Text(totalInStr)
                .font(Typography.calloutMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Network.totalIn)
        .accessibilityValue(totalInStr)

        let outBlock = HStack(spacing: SpacingTheme.compact) {
            Image(systemName: "arrow.up.circle.fill")
                .font(IconTheme.tileLeading)
                .foregroundStyle(uploadAccentColor)
                .accessibilityHidden(true)

            Text(L10n.Network.totalOut)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            Text(totalOutStr)
                .font(Typography.calloutMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Network.totalOut)
        .accessibilityValue(totalOutStr)

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                inBlock
                outBlock
            }
        } else {
            HStack {
                inBlock
                Spacer(minLength: SpacingTheme.compact)
                outBlock
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
                .accessibilityHidden(true)

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
        .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue("\(value) \(unit)")
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
