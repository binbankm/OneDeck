//
//  OverviewNetworkCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Telemetry: Download/Upload Bento Boxes, Dynamic Sparklines & Session Counters.
//

import SwiftUI
import Charts

struct OverviewNetworkCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var system = SystemService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Row
            HStack {
                OverviewSectionHeader(title: L10n.Overview.networkTraffic, icon: "arrow.up.arrow.down.circle.fill")

                Spacer()

                HStack(spacing: 5) {
                    Circle()
                        .fill(appState.accentColor)
                        .frame(width: 6, height: 6)

                    Text(system.activeInterfaceName)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(appState.accentColor)
                        .lineLimit(1)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 3.5)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
            }

            // Dual Bento Boxes: Download & Upload
            HStack(spacing: 10) {
                // Download Speed Bento Box
                networkMetricBentoBox(
                    isDownload: true,
                    label: L10n.Overview.downloadSpeed,
                    rate: system.downloadRate,
                    history: system.downloadHistory,
                    color: appState.accentColor,
                    sessionTotal: system.sessionDownloadTotalFormatted
                )

                // Upload Speed Bento Box
                networkMetricBentoBox(
                    isDownload: false,
                    label: L10n.Overview.uploadSpeed,
                    rate: system.uploadRate,
                    history: system.uploadHistory,
                    color: Color(hex: "#00C9FF"),
                    sessionTotal: system.sessionUploadTotalFormatted
                )
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private func networkMetricBentoBox(
        isDownload: Bool,
        label: String,
        rate: (value: String, unit: String),
        history: [MetricPoint],
        color: Color,
        sessionTotal: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Direction Icon + Label
            HStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 22, height: 22)

                    Image(systemName: isDownload ? "arrow.down" : "arrow.up")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(color)
                }

                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            // Speed Value + Unit
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(rate.value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .contentTransition(.numericText())
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(rate.unit)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            // Sparkline with Glowing Area Fill
            ZStack(alignment: .bottom) {
                if history.count > 1 {
                    Chart {
                        ForEach(history) { point in
                            LineMark(
                                x: .value("Time", point.timestamp),
                                y: .value("Speed", point.value)
                            )
                            .interpolationMethod(.monotone)
                            .lineStyle(StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
                            .foregroundStyle(color)

                            AreaMark(
                                x: .value("Time", point.timestamp),
                                y: .value("Speed", point.value)
                            )
                            .interpolationMethod(.monotone)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [color.opacity(0.24), color.opacity(0.0)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis(.hidden)
                    .allowsHitTesting(false)
                } else {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        .frame(height: 1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
            .frame(height: 32)

            // Session Cumulative Traffic
            HStack(spacing: 3) {
                Text(L10n.Overview.sessionTotal + ":")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)

                Text(sessionTotal)
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04), lineWidth: 0.5)
        )
    }
}

