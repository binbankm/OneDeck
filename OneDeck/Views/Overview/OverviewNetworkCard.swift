//
//  OverviewNetworkCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Real-time network throughput and interface summary card.
//

import Charts
import SwiftUI

struct OverviewNetworkCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerRow
            dualBentoBoxes
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            OverviewSectionHeader(title: L10n.Overview.networkTraffic, icon: "chart.line.uptrend.xyaxis.circle.fill")
                .layoutPriority(1)

            Spacer(minLength: SpacingTheme.compact)

            let isCellular = (net.linkType == .cellular)
            let badgeColor = isCellular
                ? Theme.readableOrange(for: colorScheme)
                : Theme.readableAccent(appState.accentColor, for: colorScheme)

            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(badgeColor)
                    .frame(width: 6, height: 6)
                    .accessibilityHidden(true)

                Text(net.activeInterfaceSummary)
                    .font(Typography.captionBold)
                    .foregroundStyle(badgeColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.micro)
            .background(badgeColor.opacity(0.12))
            .clipShape(Capsule())
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(L10n.Overview.activeInterface): \(net.activeInterfaceSummary)")
        }
    }

    @ViewBuilder
    private var dualBentoBoxes: some View {
        let downloadColor = Theme.readableAccent(appState.accentColor, for: colorScheme)
        let uploadColor = colorScheme == .dark ? ChartTheme.uploadColor : Theme.readableCyan(for: colorScheme)

        if dynamicTypeSize.isAccessibilitySize {
            VStack(spacing: SpacingTheme.row) {
                downloadBentoBox(color: downloadColor)
                uploadBentoBox(color: uploadColor)
            }
        } else {
            HStack(spacing: SpacingTheme.row) {
                downloadBentoBox(color: downloadColor)
                uploadBentoBox(color: uploadColor)
            }
        }
    }

    @ViewBuilder
    private func downloadBentoBox(color: Color) -> some View {
        OverviewMetricBentoBox(
            isDownload: true,
            label: L10n.Overview.downloadSpeed,
            rateValue: system.downloadRate.value,
            rateUnit: system.downloadRate.unit,
            history: system.downloadHistory,
            color: color,
            sessionTotal: system.sessionDownloadTotalFormatted
        )
    }

    @ViewBuilder
    private func uploadBentoBox(color: Color) -> some View {
        OverviewMetricBentoBox(
            isDownload: false,
            label: L10n.Overview.uploadSpeed,
            rateValue: system.uploadRate.value,
            rateUnit: system.uploadRate.unit,
            history: system.uploadHistory,
            color: color,
            sessionTotal: system.sessionUploadTotalFormatted
        )
    }
}

// MARK: - Subviews
private struct OverviewMetricBentoBox: View {
    let isDownload: Bool
    let label: String
    let rateValue: String
    let rateUnit: String
    let history: [MetricPoint]
    let color: Color
    let sessionTotal: String
    @Environment(\.colorScheme) private var colorScheme
    @ScaledMetric(relativeTo: .subheadline) private var directionIconSize: CGFloat = 22

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            headerRow
            speedRow
            sparklineArea
            sessionTotalRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(SpacingTheme.rowStandard)
        .background(Theme.tileBackground(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.prominent, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.prominent, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue("\(rateValue) \(rateUnit), \(L10n.Overview.sessionTotal) \(sessionTotal)")
    }

    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.compact) {
            Image(systemName: isDownload ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                .font(IconTheme.sectionHeader)
                .foregroundStyle(color)
                .frame(width: directionIconSize, height: directionIconSize, alignment: .center)
                .accessibilityHidden(true)

            Text(label)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
    }

    @ViewBuilder
    private var speedRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
            Text(rateValue)
                .font(Typography.title1)
                .monospacedDigit()
                .contentTransition(.numericText())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))

            Text(rateUnit)
                .font(Typography.calloutLabel)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .fixedSize(horizontal: true, vertical: false)
        }
    }

    @ViewBuilder
    private var sparklineArea: some View {
        let finiteHistory = history.filter { $0.value.isFinite }

        ZStack(alignment: .bottom) {
            if finiteHistory.count > 1 {
                OverviewSparklineView(history: finiteHistory, color: color)
            } else {
                Rectangle()
                    .fill(color.opacity(0.22))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(height: 32)
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var sessionTotalRow: some View {
        HStack(spacing: SpacingTheme.tight) {
            Text(L10n.Overview.sessionTotal)
                .font(Typography.badgeTag)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer(minLength: SpacingTheme.tight)

            Text(sessionTotal)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

// MARK: - Standalone Sparkline View
private struct OverviewSparklineView: View {
    let history: [MetricPoint]
    let color: Color

    var body: some View {
        Chart {
            ForEach(history) { point in
                LineMark(
                    x: .value(L10n.Overview.chartTimeAxis, point.timestamp),
                    y: .value(L10n.Overview.chartSpeedAxis, point.value)
                )
                .interpolationMethod(.monotone)
                .lineStyle(StrokeStyle(lineWidth: ChartTheme.sparklineWidth, lineCap: .round, lineJoin: .round))
                .foregroundStyle(color)

                AreaMark(
                    x: .value(L10n.Overview.chartTimeAxis, point.timestamp),
                    y: .value(L10n.Overview.chartSpeedAxis, point.value)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(ChartTheme.areaGradient(for: color))
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .allowsHitTesting(false)
    }
}

// MARK: - Preview
#Preview {
    OverviewNetworkCard()
        .padding()
}
