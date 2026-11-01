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
        VStack(alignment: .leading, spacing: 14) {
            // MARK: - Header
            HStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(appState.accentColor.opacity(0.12))
                        .frame(width: 30, height: 30)

                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(appState.accentColor)
                }

                Text(L10n.Network.latencyTitle)
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Spacer()

                // Quality Badge (Single-line, non-wrapping)
                Text(qualityBadge.text)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(qualityBadge.color)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
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
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(appState.accentColor)
                        .padding(5)
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
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(qualityBadge.color)

                    Text("ms")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Spacer()

                // Jitter & Packet Loss stats
                HStack(spacing: 14) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(L10n.Network.jitter)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))

                        Text(net.isConnected ? String(format: "±%.1f ms", net.jitterMs) : "--")
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)
                    }

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(L10n.Network.packetLoss)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))

                        Text(net.isConnected ? String(format: "%.0f%%", net.packetLossPercent) : "100%")
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
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
                            HStack(spacing: 5) {
                                Circle()
                                    .fill(isSelected ? appState.accentColor : Color.secondary.opacity(0.4))
                                    .frame(width: 6, height: 6)

                                Text(target.shortName)
                                    .font(.system(size: 12, weight: isSelected ? .semibold : .regular, design: .rounded))
                                    .foregroundStyle(isSelected ? Theme.textPrimary(for: colorScheme) : Theme.textSecondary(for: colorScheme))
                                    .lineLimit(1)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .padding(.horizontal, 11)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(isSelected ? appState.accentColor.opacity(0.16) : Theme.cardBackground(for: colorScheme).opacity(0.5))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(isSelected ? appState.accentColor.opacity(0.5) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                            )
                        }
                        .buttonStyle(.plain)
                        .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .padding(.horizontal, 1)
            }

            // Swift Charts Rolling Latency Waveform
            VStack(alignment: .leading, spacing: 6) {
                if net.latencyHistory.isEmpty {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.3))
                        .frame(height: 110)
                } else {
                    Chart {
                        ForEach(net.latencyHistory) { pt in
                            AreaMark(
                                x: .value("Time", pt.timestamp),
                                y: .value("Latency", pt.value)
                            )
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        appState.accentColor.opacity(0.28),
                                        appState.accentColor.opacity(0.02)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .interpolationMethod(.catmullRom)

                            LineMark(
                                x: .value("Time", pt.timestamp),
                                y: .value("Latency", pt.value)
                            )
                            .foregroundStyle(appState.accentColor)
                            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.catmullRom)
                        }

                        RuleMark(y: .value("Baseline", 50))
                            .lineStyle(StrokeStyle(lineWidth: 0.8, dash: [4, 4]))
                            .foregroundStyle(Color.secondary.opacity(0.35))
                    }
                    .chartXAxis(.hidden)
                    .chartYAxis {
                        AxisMarks(position: .trailing, values: .automatic(desiredCount: 3)) { val in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 3]))
                                .foregroundStyle(Color.secondary.opacity(0.2))
                            AxisValueLabel {
                                if let intVal = val.as(Int.self) {
                                    Text("\(intVal)ms")
                                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
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
                    .font(.system(size: 11, weight: .medium))
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
                                .font(.system(size: 10, weight: .bold))
                        }

                        Text(L10n.Network.runBenchmark)
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
                HStack(spacing: 5) {
                    Text(node.name)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)

                    if node.isFastest {
                        Text(L10n.Network.fastestNode)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Color.green)
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(Color.green.opacity(0.14))
                            .clipShape(Capsule())
                    }
                }

                Text(node.host)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            Spacer()

            // Latency Readout
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(node.latencyMs > 900 ? "--" : String(format: "%.0f", node.latencyMs))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(node.isFastest ? Color.green : (node.latencyMs < 50 ? accentColor : Color.orange))

                Text("ms")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(node.isFastest ? Color.green.opacity(0.4) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }
}
