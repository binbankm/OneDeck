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
        HStack {
            OverviewSectionHeader(title: L10n.Overview.networkTraffic, icon: "chart.line.uptrend.xyaxis.circle.fill")

            Spacer()

            let isCellular = (net.linkType == .cellular)
            let badgeColor = isCellular ? Color.orange : appState.accentColor

            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(badgeColor)
                    .frame(width: 6, height: 6)

                Text(net.activeInterfaceSummary)
                    .font(Typography.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(badgeColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.micro)
            .background(badgeColor.opacity(0.12))
            .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private var dualBentoBoxes: some View {
        HStack(spacing: SpacingTheme.row) {
            // Download Speed Bento Box
            OverviewMetricBentoBox(
                isDownload: true,
                label: L10n.Overview.downloadSpeed,
                rateValue: system.downloadRate.value,
                rateUnit: system.downloadRate.unit,
                history: system.downloadHistory,
                color: appState.accentColor,
                sessionTotal: system.sessionDownloadTotalFormatted
            )

            // Upload Speed Bento Box
            OverviewMetricBentoBox(
                isDownload: false,
                label: L10n.Overview.uploadSpeed,
                rateValue: system.uploadRate.value,
                rateUnit: system.uploadRate.unit,
                history: system.uploadHistory,
                color: colorScheme == .dark ? ChartTheme.uploadColor : Theme.readableCyan(for: colorScheme),
                sessionTotal: system.sessionUploadTotalFormatted
            )
        }
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

    private var boxBackground: Color {
        colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03)
    }

    private var boxBorder: Color {
        colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            headerRow
            speedRow
            sparklineArea
            sessionTotalRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(SpacingTheme.rowStandard)
        .background(boxBackground)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.prominent, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.prominent, style: .continuous)
                .stroke(boxBorder, lineWidth: 0.5)
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
                .frame(width: 22, height: 22, alignment: .center)

            Text(label)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private var speedRow: some View {
        HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
            Text(rateValue)
                .font(Typography.title1)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))

            Text(rateUnit)
                .font(Typography.calloutLabel)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private var sparklineArea: some View {
        ZStack(alignment: .bottom) {
            if history.count > 1 {
                OverviewSparklineView(history: history, color: color)
            } else {
                Rectangle()
                    .fill(color.opacity(0.2))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(height: 32)
    }

    @ViewBuilder
    private var sessionTotalRow: some View {
        HStack(spacing: SpacingTheme.tight) {
            Text("\(L10n.Overview.sessionTotal):")
                .font(Typography.badgeTag)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Text(sessionTotal)
                .font(Typography.badgeTag)
                .fontDesign(.monospaced)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
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
                    x: .value("Time", point.timestamp),
                    y: .value("Speed", point.value)
                )
                .interpolationMethod(.monotone)
                .lineStyle(StrokeStyle(lineWidth: ChartTheme.sparklineWidth, lineCap: .round, lineJoin: .round))
                .foregroundStyle(color)

                AreaMark(
                    x: .value("Time", point.timestamp),
                    y: .value("Speed", point.value)
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
