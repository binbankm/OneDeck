//
//  NetworkLatencyCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Latency Card: Real POSIX TCP RTT Ping, Jitter & DNS Benchmark.
//

import SwiftUI
import Charts

enum LatencyCardMode: Int, CaseIterable, Identifiable {
    case live
    case benchmark

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .live: return L10n.Network.latencyLive
        case .benchmark: return L10n.Network.latencyBenchmark
        }
    }
}

struct NetworkLatencyCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var net = NetworkService.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedMode: LatencyCardMode = .live

    private var qualityBadge: (text: String, color: Color) {
        if !net.isConnected {
            return (L10n.Network.disconnected, .red)
        }
        let lat = net.currentLatencyMs
        if lat <= 0 {
            return ("--", .secondary)
        } else if lat < 25 {
            return (L10n.Network.qualityOptimal, .green)
        } else if lat < 60 {
            return (L10n.Network.qualityGood, appState.accentColor)
        } else if lat < 120 {
            return (L10n.Network.qualityFair, .orange)
        } else {
            return (L10n.Network.qualityPoor, .red)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            // MARK: - Header
            HStack(spacing: 8) {
                BentoSectionHeader(title: L10n.Network.latencyTitle, icon: "waveform.path.ecg")

                Spacer()

                // Quality Badge (Single-line, non-wrapping)
                Text(qualityBadge.text)
                    .font(Typography.captionBold)
                    .foregroundStyle(qualityBadge.color)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.horizontal, 8)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(qualityBadge.color.opacity(0.12))
                    .clipShape(Capsule())

                // Instant Refresh Button
                Button {
                    Haptics.tick()
                    if selectedMode == .live {
                        net.pingCurrentTarget()
                    } else {
                        net.runDnsBenchmark()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(IconTheme.actionButton)
                        .foregroundStyle(appState.accentColor)
                        .padding(SpacingTheme.compact)
                        .background(appState.accentColor.opacity(0.1))
                        .clipShape(Circle())
                }
            }

            // Mode Toggle Bar
            Picker("", selection: $selectedMode) {
                ForEach(LatencyCardMode.allCases) { m in
                    Text(m.title).tag(m)
                }
            }
            .pickerStyle(.segmented)

            if selectedMode == .live {
                livePingSection
            } else {
                dnsBenchmarkSection
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - 1. Live Ping Subview
    @ViewBuilder
    private var livePingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Hero Ping Metric & Jitter / Loss HUD
            HStack(alignment: .lastTextBaseline, spacing: 16) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(net.isConnected ? String(format: "%.0f", max(1.0, net.currentLatencyMs)) : "--")
                        .font(Typography.displayHero)
                        .monospacedDigit()
                        .foregroundStyle(qualityBadge.color)

                    Text("ms")
                        .font(Typography.sectionHeader)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Spacer()

                // Jitter & Packet Loss stats
                HStack(spacing: 14) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(L10n.Network.jitter)
                            .font(Typography.caption)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))

                        Text(net.isConnected ? String(format: "±%.1f ms", net.jitterMs) : "--")
                            .font(Typography.bodyValueMono)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)
                    }

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(L10n.Network.packetLoss)
                            .font(Typography.caption)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))

                        Text(net.isConnected ? String(format: "%.0f%%", net.packetLossPercent) : "100%")
                            .font(Typography.bodyValueMono)
                            .foregroundStyle(net.packetLossPercent > 0 ? Color.orange : Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)
                    }
                }
            }

            // Ping Target Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(PingTargetNode.allCases) { target in
                        let isSelected = (net.selectedTarget == target)
                        Button {
                            Haptics.selection()
                            net.selectedTarget = target
                            net.pingCurrentTarget()
                        } label: {
                            HStack(spacing: SpacingTheme.tight) {
                                Circle()
                                    .fill(isSelected ? appState.accentColor : Color.secondary.opacity(0.4))
                                    .frame(width: 6, height: 6)

                                Text(target.shortName)
                                    .font(isSelected ? Typography.calloutBold : Typography.calloutLabel)
                                    .foregroundStyle(isSelected ? Theme.textPrimary(for: colorScheme) : Theme.textSecondary(for: colorScheme))
                                    .lineLimit(1)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .fill(isSelected ? appState.accentColor.opacity(0.16) : Theme.cardBackground(for: colorScheme).opacity(0.5))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .stroke(isSelected ? appState.accentColor.opacity(0.5) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                            )
                        }
                        .buttonStyle(.plain)
                        .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .padding(.horizontal, SpacingTheme.micro)
            }

            // Swift Charts Rolling Latency Waveform
            VStack(alignment: .leading, spacing: 6) {
                if net.latencyHistory.isEmpty {
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                        .frame(height: 110)
                } else {
                    Chart {
                        ForEach(net.latencyHistory) { pt in
                            AreaMark(
                                x: .value("Time", pt.timestamp),
                                y: .value("Latency", pt.value)
                            )
                            .foregroundStyle(ChartTheme.areaGradient(for: appState.accentColor))
                            .interpolationMethod(.monotone)

                            LineMark(
                                x: .value("Time", pt.timestamp),
                                y: .value("Latency", pt.value)
                            )
                            .foregroundStyle(appState.accentColor)
                            .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.monotone)
                        }

                        RuleMark(y: .value("Baseline", 50))
                            .lineStyle(StrokeStyle(lineWidth: 0.8, dash: [3, 2]))
                            .foregroundStyle(Color.orange.opacity(0.6))
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis {
                        AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) { val in
                            AxisGridLine(stroke: ChartTheme.gridStroke)
                                .foregroundStyle(ChartTheme.gridColor(for: colorScheme))
                            AxisValueLabel {
                                if let intVal = val.as(Int.self) {
                                    Text("\(intVal)ms")
                                        .font(ChartTheme.axisLabelFont)
                                        .foregroundStyle(ChartTheme.axisLabelColor(for: colorScheme))
                                }
                            }
                        }
                    }
                    .frame(height: 110)
                }
            }
        }
    }

    // MARK: - 2. Multi-Node DNS Benchmark Subview
    @ViewBuilder
    private var dnsBenchmarkSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(L10n.Network.dnsBenchmarkDesc)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)

                Spacer()

                Button {
                    net.runDnsBenchmark()
                } label: {
                    HStack(spacing: 4) {
                        if net.isBenchmarkingDns {
                            ProgressView()
                                .tint(appState.accentColor)
                                .scaleEffect(0.65)
                        } else {
                            Image(systemName: "bolt.horizontal.fill")
                                .font(IconTheme.actionButton)
                        }

                        Text(L10n.Network.runBenchmark)
                            .font(Typography.captionBold)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .foregroundStyle(appState.accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(appState.accentColor.opacity(0.12))
                    .clipShape(Capsule())
                }
                .disabled(net.isBenchmarkingDns)
            }

            VStack(spacing: 8) {
                ForEach(net.dnsBenchmarkResults) { node in
                    DnsBenchmarkNodeRow(node: node, accentColor: appState.accentColor)
                }
            }
        }
    }
}

// MARK: - DNS Benchmark Row
private struct DnsBenchmarkNodeRow: View {
    let node: DnsBenchmarkResult
    let accentColor: Color
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: SpacingTheme.tight) {
                    Text(node.name)
                        .font(Typography.bodyValue)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)

                    if node.isFastest {
                        Text(L10n.Network.fastestNode)
                            .font(Typography.badgeTag)
                            .foregroundStyle(Color.green)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, SpacingTheme.compact)
                            .padding(.vertical, SpacingTheme.micro)
                            .background(Color.green.opacity(0.14))
                            .clipShape(Capsule())
                    }
                }

                Text(node.host)
                    .font(Typography.badgeTagMonoMedium)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            Spacer()

            // Latency Readout
            if node.latencyMs == 0.0 {
                Text(L10n.Network.pendingBenchmark)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
            } else {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(node.latencyMs > 900 ? "--" : String(format: "%.0f", node.latencyMs))
                        .font(Typography.headlineValue)
                        .monospacedDigit()
                        .foregroundStyle(node.isFastest ? Color.green : (node.latencyMs < 50 ? accentColor : Color.orange))

                    Text("ms")
                        .font(Typography.badgeTagMedium)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .stroke(node.isFastest ? Color.green.opacity(0.4) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }
}
