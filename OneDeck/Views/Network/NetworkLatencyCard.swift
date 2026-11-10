//
//  NetworkLatencyCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  POSIX TCP ping latency, jitter, and target response matrix card.
//

import Charts
import SwiftUI

struct NetworkLatencyCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @State private var selectedMode: LatencyCardMode = .live

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    private var qualityBadge: (text: String, color: Color) {
        if !net.isConnected {
            return (L10n.Network.disconnected, Theme.readableRed(for: colorScheme))
        }
        let lat = net.currentLatencyMs
        if lat <= 0 {
            return ("--", Theme.textSecondary(for: colorScheme))
        } else if lat < 25 {
            return (L10n.Network.qualityOptimal, Theme.readableGreen(for: colorScheme))
        } else if lat < 60 {
            return (L10n.Network.qualityGood, accentFg)
        } else if lat < 120 {
            return (L10n.Network.qualityFair, Theme.readableOrange(for: colorScheme))
        } else {
            return (L10n.Network.qualityPoor, Theme.readableRed(for: colorScheme))
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            modeToggleBar

            if selectedMode == .live {
                livePingSection
            } else {
                dnsBenchmarkSection
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        let trailingControls = HStack(spacing: SpacingTheme.standard) {
            Text(qualityBadge.text)
                .font(Typography.captionBold)
                .foregroundStyle(qualityBadge.color)
                .lineLimit(1)
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.micro)
                .background(qualityBadge.color.opacity(0.12))
                .clipShape(Capsule())
                .accessibilityLabel(L10n.Network.latency)
                .accessibilityValue(qualityBadge.text)

            if selectedMode == .live {
                Button {
                    Haptics.tick()
                    net.pingCurrentTarget()
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(IconTheme.actionButton)
                        .foregroundStyle(accentFg)
                        .frame(width: LayoutTheme.minTapTarget, height: LayoutTheme.minTapTarget)
                        .background(appState.accentColor.opacity(0.12), in: Circle())
                        .contentShape(Circle())
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(L10n.Network.refresh)
            }
        }

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                BentoSectionHeader(title: L10n.Network.latencyTitle, icon: "stopwatch.fill")
                trailingControls
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                BentoSectionHeader(title: L10n.Network.latencyTitle, icon: "stopwatch.fill")
                Spacer(minLength: SpacingTheme.compact)
                trailingControls
            }
        }
    }

    @ViewBuilder
    private var modeToggleBar: some View {
        Picker(L10n.Network.latencyTitle, selection: $selectedMode) {
            ForEach(LatencyCardMode.allCases) { m in
                Text(m.title).tag(m)
            }
        }
        .labelsHidden()
        .pickerStyle(.segmented)
        .accessibilityLabel(L10n.Network.latencyTitle)
    }

    // MARK: - Live Ping Section
    @ViewBuilder
    private var livePingSection: some View {
        let hasLatency = net.isConnected && net.currentLatencyMs.isFinite && net.currentLatencyMs > 0
        let safeLatency = hasLatency ? String(format: "%.0f", max(1.0, net.currentLatencyMs)) : "--"
        let safeJitter = net.jitterMs.isFinite ? net.jitterMs : 0.0
        let safeLoss = net.packetLossPercent.isFinite ? net.packetLossPercent : 0.0
        let jitterText = net.isConnected ? String(format: "±%.1f \(L10n.Network.msSuffix)", safeJitter) : "--"
        let lossText = net.isConnected ? String(format: "%.0f%%", safeLoss) : "100%"

        let heroKPI = HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.tight) {
            Text(safeLatency)
                .font(Typography.displayHero)
                .monospacedDigit()
                .foregroundStyle(qualityBadge.color)

            Text(L10n.Network.msSuffix)
                .font(Typography.sectionHeader)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Network.latency)
        .accessibilityValue("\(safeLatency) \(L10n.Network.msSuffix)")

        let secondaryStats = HStack(spacing: SpacingTheme.cardInternal) {
            VStack(alignment: dynamicTypeSize.isAccessibilitySize ? .leading : .trailing, spacing: SpacingTheme.micro) {
                Text(L10n.Network.jitter)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                Text(jitterText)
                    .font(Typography.bodyValueMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Network.jitter)
            .accessibilityValue(jitterText)

            VStack(alignment: dynamicTypeSize.isAccessibilitySize ? .leading : .trailing, spacing: SpacingTheme.micro) {
                Text(L10n.Network.packetLoss)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                Text(lossText)
                    .font(Typography.bodyValueMono)
                    .foregroundStyle(safeLoss > 0 ? Theme.readableOrange(for: colorScheme) : Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Network.packetLoss)
            .accessibilityValue(lossText)
        }

        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    heroKPI
                    secondaryStats
                }
            } else {
                HStack(alignment: .lastTextBaseline, spacing: SpacingTheme.cardStack) {
                    heroKPI
                    Spacer(minLength: SpacingTheme.compact)
                    secondaryStats
                }
            }

            // Ping Target Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SpacingTheme.standard) {
                    ForEach(PingTargetNode.allCases) { target in
                        let isSelected = (net.selectedTarget == target)
                        Button {
                            Haptics.selection()
                            net.selectPingTarget(target)
                        } label: {
                            HStack(spacing: SpacingTheme.tight) {
                                Circle()
                                    .fill(isSelected ? accentFg : Theme.textTertiary(for: colorScheme).opacity(0.45))
                                    .frame(width: 6, height: 6)
                                    .accessibilityHidden(true)

                                Text(target.shortName)
                                    .font(isSelected ? Typography.calloutBold : Typography.calloutLabel)
                                    .foregroundStyle(isSelected ? Theme.textPrimary(for: colorScheme) : Theme.textSecondary(for: colorScheme))
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, SpacingTheme.row)
                            .frame(minHeight: LayoutTheme.minTapTarget)
                            .background(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .fill(isSelected ? appState.accentColor.opacity(0.16) : Theme.chipBackground(for: colorScheme))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .stroke(isSelected ? accentFg.opacity(0.55) : Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                        }
                        .buttonStyle(BentoCardButtonStyle())
                        .accessibilityLabel(target.shortName)
                        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
                    }
                }
                .padding(.horizontal, SpacingTheme.micro)
            }

            // Swift Charts Rolling Latency Waveform
            let validLatency = net.latencyHistory.filter { $0.value.isFinite }
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                if validLatency.isEmpty {
                    BentoEmptyStateView(
                        icon: "waveform.path.ecg",
                        message: L10n.Network.waitingForSamples,
                        showsProgress: true,
                        height: 110
                    )
                } else {
                    let baselineColor = Theme.readableOrange(for: colorScheme)
                    Chart {
                        ForEach(validLatency) { pt in
                            AreaMark(
                                x: .value(L10n.Network.chartTimeAxis, pt.timestamp),
                                y: .value(L10n.Network.chartLatencyAxis, pt.value)
                            )
                            .foregroundStyle(ChartTheme.areaGradient(for: appState.accentColor))
                            .interpolationMethod(.monotone)

                            LineMark(
                                x: .value(L10n.Network.chartTimeAxis, pt.timestamp),
                                y: .value(L10n.Network.chartLatencyAxis, pt.value)
                            )
                            .foregroundStyle(accentFg)
                            .lineStyle(StrokeStyle(lineWidth: ChartTheme.lineWidth, lineCap: .round, lineJoin: .round))
                            .interpolationMethod(.monotone)
                        }

                        RuleMark(y: .value(L10n.Network.chartBaselineAxis, 50))
                            .lineStyle(StrokeStyle(lineWidth: 0.8, dash: [3, 2]))
                            .foregroundStyle(baselineColor.opacity(0.65))
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
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(L10n.Network.latencyTitle)
                    .accessibilityValue("\(safeLatency) \(L10n.Network.msSuffix)")
                }
            }
        }
    }

    // MARK: - DNS Benchmark Section
    @ViewBuilder
    private var dnsBenchmarkSection: some View {
        let benchmarkButton = Button {
            Haptics.selection()
            net.runDnsBenchmark()
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                if net.isBenchmarkingDns {
                    ProgressView()
                        .controlSize(.small)
                        .tint(accentFg)
                } else {
                    Image(systemName: "bolt.horizontal.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                }

                Text(L10n.Network.runBenchmark)
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
        .disabled(net.isBenchmarkingDns)

        VStack(alignment: .leading, spacing: SpacingTheme.row) {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    Text(L10n.Network.dnsBenchmarkDesc)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)
                    benchmarkButton
                }
            } else {
                HStack(spacing: SpacingTheme.compact) {
                    Text(L10n.Network.dnsBenchmarkDesc)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                    Spacer(minLength: SpacingTheme.compact)
                    benchmarkButton
                }
            }

            VStack(spacing: SpacingTheme.standard) {
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
        let readableGreen = Theme.readableGreen(for: colorScheme)
        let readableOrange = Theme.readableOrange(for: colorScheme)
        let readableAccent = Theme.readableAccent(accentColor, for: colorScheme)
        let latencyValueText: String = {
            if !node.latencyMs.isFinite || node.latencyMs == 0.0 {
                return L10n.Network.pendingBenchmark
            } else if node.latencyMs > 900 {
                return "--"
            } else {
                return String(format: "%.0f %@", node.latencyMs, L10n.Network.msSuffix)
            }
        }()

        HStack(spacing: SpacingTheme.row) {
            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                FlowLayout(spacing: SpacingTheme.tight, rowSpacing: SpacingTheme.micro) {
                    Text(node.name)
                        .font(Typography.bodyValue)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)

                    if node.isFastest {
                        Text(L10n.Network.fastestNode)
                            .font(Typography.badgeTag)
                            .foregroundStyle(readableGreen)
                            .lineLimit(1)
                            .padding(.horizontal, SpacingTheme.compact)
                            .padding(.vertical, SpacingTheme.micro)
                            .background(readableGreen.opacity(0.14))
                            .clipShape(Capsule())
                    }
                }

                Text(node.host)
                    .font(Typography.badgeTagMonoMedium)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            Spacer(minLength: SpacingTheme.compact)

            if !node.latencyMs.isFinite || node.latencyMs == 0.0 {
                Text(L10n.Network.pendingBenchmark)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
            } else if node.latencyMs > 900 {
                Text("--")
                    .font(Typography.headlineValue)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
            } else {
                let valueColor = node.isFastest
                    ? readableGreen
                    : (node.latencyMs < 50 ? readableAccent : readableOrange)

                HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                    Text(String(format: "%.0f", node.latencyMs))
                        .font(Typography.headlineValue)
                        .monospacedDigit()
                        .foregroundStyle(valueColor)

                    Text("ms")
                        .font(Typography.badgeTagMedium)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .stroke(node.isFastest ? readableGreen.opacity(0.45) : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(node.name), \(node.host)")
        .accessibilityValue(node.isFastest ? "\(latencyValueText), \(L10n.Network.fastestNode)" : latencyValueText)
    }
}

// MARK: - Preview
#Preview {
    NetworkLatencyCard()
        .padding()
}
