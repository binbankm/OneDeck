//
//  NetworkSpeedTestSheet.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Multi-stream download and upload network speed benchmarking sheet.
//

import SwiftUI

struct NetworkSpeedTestSheet: View {
    // MARK: - Dependencies & Environment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    private var uploadAccentColor: Color {
        colorScheme == .dark ? ChartTheme.uploadColor : Theme.readableCyan(for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    gaugeSection
                    if let errorMessage = net.speedTestError, !errorMessage.isEmpty {
                        speedTestErrorBanner(errorMessage)
                    }
                    scorecardGrid
                    serverBanner
                    actionDispatcherSection
                    historySection
                }
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.cardStack)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Network.speedTestTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                net.stopSpeedTest()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        dismiss()
                    }
                    .font(Typography.bodyValue)
                    .foregroundStyle(accentFg)
                }
            }
        }
        .presentationDragIndicator(.visible)
    }

    // MARK: - 1. Speedometer Arc Gauge HUD
    @ViewBuilder
    private var gaugeSection: some View {
        let gaugeWidth: CGFloat = dynamicTypeSize.isAccessibilitySize ? 240 : 200
        let gaugeHeight: CGFloat = dynamicTypeSize.isAccessibilitySize ? 190 : 160
        let safeMbps = net.speedTestCurrentMbps.isFinite ? net.speedTestCurrentMbps : 0.0
        let safeProgress = net.speedTestProgress.isFinite ? min(1.0, max(0.0, net.speedTestProgress)) : 0.0

        VStack(spacing: SpacingTheme.row) {
            ZStack {
                SpeedometerGaugeArc(
                    currentMbps: net.speedTestCurrentMbps,
                    maxScale: 500.0,
                    accentColor: appState.accentColor
                )
                .frame(width: gaugeWidth, height: gaugeHeight)
                .accessibilityHidden(true)

                VStack(spacing: SpacingTheme.micro) {
                    Text(String(format: "%.1f", safeMbps))
                        .font(Typography.displayHero)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text("Mbps")
                        .font(Typography.calloutLabel)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
                .padding(.horizontal, SpacingTheme.modalPadding)
                .offset(y: -8)
            }
            .frame(width: gaugeWidth, height: gaugeHeight)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Network.speedTestTitle)
            .accessibilityValue(String(format: "%.1f Mbps, %@", safeMbps, stageText))

            stageIndicatorPill

            BentoCapsuleProgressBar(
                value: safeProgress,
                tint: appState.accentColor,
                height: 7,
                accessibilityLabel: stageText
            )
            .padding(.horizontal, SpacingTheme.modalPadding)
            .padding(.top, SpacingTheme.tight)
        }
        .padding(.vertical, SpacingTheme.cardStack)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.sheetCard, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.sheetCard, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    // MARK: - 2. 4-Quadrant Scorecard Bento Grid
    @ViewBuilder
    private var scorecardGrid: some View {
        let safeDown = net.speedTestDownloadMbps.isFinite ? net.speedTestDownloadMbps : 0.0
        let safeDownPeak = net.speedTestDownloadPeakMbps.isFinite ? net.speedTestDownloadPeakMbps : 0.0
        let safeUp = net.speedTestUploadMbps.isFinite ? net.speedTestUploadMbps : 0.0
        let safeUpPeak = net.speedTestUploadPeakMbps.isFinite ? net.speedTestUploadPeakMbps : 0.0
        let safePing = net.speedTestPingMs.isFinite ? net.speedTestPingMs : 0.0
        let safeJitter = net.speedTestJitterMs.isFinite ? net.speedTestJitterMs : 0.0
        let columns = dynamicTypeSize.isAccessibilitySize
            ? [GridItem(.flexible())]
            : [GridItem(.flexible()), GridItem(.flexible())]

        LazyVGrid(columns: columns, spacing: SpacingTheme.row) {
            scorecardCell(
                title: L10n.Network.downloadSpeed,
                value: safeDown > 0 ? String(format: "%.1f", safeDown) : "--",
                unit: "Mbps",
                subtext: safeDownPeak > 0 ? L10n.Network.peakSpeedFormatted(mbps: safeDownPeak) : nil,
                icon: "arrow.down.circle.fill",
                color: accentFg
            )

            let uploadUnavailable = !net.isSpeedTestUploadAvailable && net.speedTestStage == .completed && safeUp <= 0
            scorecardCell(
                title: L10n.Network.uploadSpeed,
                value: safeUp > 0 ? String(format: "%.1f", safeUp) : "--",
                unit: uploadUnavailable ? "" : "Mbps",
                subtext: uploadUnavailable
                    ? L10n.Network.speedTestUploadUnavailable
                    : (safeUpPeak > 0 ? L10n.Network.peakSpeedFormatted(mbps: safeUpPeak) : nil),
                icon: "arrow.up.circle.fill",
                color: uploadAccentColor
            )

            scorecardCell(
                title: L10n.Network.latencyTitle,
                value: safePing > 0 ? String(format: "%.0f", safePing) : "--",
                unit: "ms",
                subtext: nil,
                icon: "bolt.horizontal.circle.fill",
                color: Theme.readableCyan(for: colorScheme)
            )

            scorecardCell(
                title: L10n.Network.jitter,
                value: safeJitter > 0 ? String(format: "±%.1f", safeJitter) : "--",
                unit: "ms",
                subtext: nil,
                icon: "waveform.path.ecg.rectangle.fill",
                color: Theme.readableOrange(for: colorScheme)
            )
        }
    }

    // MARK: - 3. Rating & Server Info Banner
    @ViewBuilder
    private var serverBanner: some View {
        let leadingTag = Group {
            if !net.speedTestRating.isEmpty {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "medal.fill")
                        .font(IconTheme.badgeInline)
                        .accessibilityHidden(true)
                    Text(net.speedTestRating)
                        .font(Typography.badgeTag)
                        .lineLimit(1)
                }
                .foregroundStyle(accentFg)
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.tight)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
            } else {
                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(accentFg)
                        .frame(width: 6, height: 6)
                        .accessibilityHidden(true)
                    Text(L10n.Network.serverNode)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
            }
        }

        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    leadingTag
                    Text(net.speedTestServerName)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(2)
                }
            } else {
                HStack(spacing: SpacingTheme.standard) {
                    leadingTag
                    Spacer(minLength: SpacingTheme.compact)
                    Text(net.speedTestServerName)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, SpacingTheme.cardInternal)
        .padding(.vertical, SpacingTheme.row)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Network.serverNode)
        .accessibilityValue("\(net.speedTestServerName)\(net.speedTestRating.isEmpty ? "" : ", \(net.speedTestRating)")")
    }

    // MARK: - 4. Action Dispatcher Controls
    @ViewBuilder
    private var actionDispatcherSection: some View {
        let stopColor = Theme.readableRed(for: colorScheme)

        VStack(spacing: SpacingTheme.row) {
            if net.isRunningSpeedTest {
                Button {
                    Haptics.impact(.medium)
                    net.stopSpeedTest()
                } label: {
                    HStack(spacing: SpacingTheme.compact) {
                        Image(systemName: "stop.fill")
                            .font(IconTheme.sectionHeader)
                            .accessibilityHidden(true)
                        Text(L10n.Network.speedTestStop)
                            .font(Typography.headlineValue)
                    }
                    .foregroundStyle(Theme.contrastingForeground(for: stopColor))
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                            .fill(stopColor)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
                }
                .buttonStyle(BentoCardButtonStyle())
            } else if net.speedTestStage == .completed {
                let clearBtn = Button {
                    Haptics.selection()
                    net.resetSpeedTest()
                } label: {
                    Text(L10n.Network.clearResults)
                        .font(Typography.headlineValue)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                                .fill(Theme.chipBackground(for: colorScheme))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                                .stroke(Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
                }
                .buttonStyle(BentoCardButtonStyle())

                let retestBtn = Button {
                    Haptics.impact(.medium)
                    net.startSpeedTest()
                } label: {
                    HStack(spacing: SpacingTheme.compact) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .font(IconTheme.sectionHeader)
                            .accessibilityHidden(true)
                        Text(L10n.Network.speedTestRestart)
                            .font(Typography.headlineValue)
                    }
                    .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                            .fill(appState.accentColor)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
                }
                .buttonStyle(BentoCardButtonStyle())

                if dynamicTypeSize.isAccessibilitySize {
                    VStack(spacing: SpacingTheme.rowStandard) {
                        retestBtn
                        clearBtn
                    }
                } else {
                    HStack(spacing: SpacingTheme.rowStandard) {
                        clearBtn
                        retestBtn
                    }
                }
            } else {
                Button {
                    Haptics.impact(.medium)
                    net.startSpeedTest()
                } label: {
                    HStack(spacing: SpacingTheme.standard) {
                        Image(systemName: "play.fill")
                            .font(IconTheme.sectionHeader)
                            .accessibilityHidden(true)
                        Text(L10n.Network.startSpeedTest)
                            .font(Typography.headlineValue)
                    }
                    .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                            .fill(appState.accentColor)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
                }
                .buttonStyle(BentoCardButtonStyle())
            }
        }
        .padding(.top, SpacingTheme.compact)
    }

    // MARK: - 5. Speed Test History Section
    @ViewBuilder
    private var historySection: some View {
        if !net.speedTestHistory.isEmpty {
            VStack(alignment: .leading, spacing: SpacingTheme.row) {
                HStack {
                    Text(L10n.Network.speedTestHistory)
                        .font(Typography.bodyValue)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .accessibilityAddTraits(.isHeader)

                    Spacer(minLength: SpacingTheme.compact)

                    Button {
                        Haptics.selection()
                        net.clearSpeedTestHistory()
                    } label: {
                        Text(L10n.Network.clearHistory)
                            .font(Typography.captionBold)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .padding(.horizontal, SpacingTheme.row)
                            .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                            .contentShape(Capsule())
                    }
                    .buttonStyle(BentoCardButtonStyle())
                }

                VStack(spacing: SpacingTheme.standard) {
                    ForEach(net.speedTestHistory) { item in
                        let itemDown = item.downloadMbps.isFinite ? item.downloadMbps : 0.0
                        let itemUp = item.uploadMbps.isFinite ? item.uploadMbps : 0.0
                        let itemPing = item.pingMs.isFinite ? item.pingMs : 0.0

                        let leftMeta = VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                            Text(item.date, format: .dateTime.month().day().hour().minute())
                                .font(Typography.captionMono)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))

                            Text(item.rating)
                                .font(Typography.captionBold)
                                .foregroundStyle(accentFg)
                                .lineLimit(1)
                        }

                        let rightMetrics = HStack(spacing: SpacingTheme.standard) {
                            Text("↓\(String(format: "%.1f", itemDown))M")
                                .font(Typography.calloutMono)
                                .foregroundStyle(accentFg)

                            Text(itemUp > 0 ? "↑\(String(format: "%.1f", itemUp))M" : "↑--")
                                .font(Typography.calloutMono)
                                .foregroundStyle(uploadAccentColor)

                            Text("\(String(format: "%.0f", itemPing))ms")
                                .font(Typography.captionMono)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        }

                        Group {
                            if dynamicTypeSize.isAccessibilitySize {
                                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                                    leftMeta
                                    rightMetrics
                                }
                            } else {
                                HStack {
                                    leftMeta
                                    Spacer(minLength: SpacingTheme.compact)
                                    rightMetrics
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, SpacingTheme.rowStandard)
                        .padding(.vertical, SpacingTheme.standard)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .fill(Theme.cardBackground(for: colorScheme))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                        )
                        .accessibilityElement(children: .combine)
                    }
                }
            }
            .padding(.top, SpacingTheme.tight)
        }
    }

    // MARK: - Subviews & Helpers
    @ViewBuilder
    private func speedTestErrorBanner(_ message: String) -> some View {
        ToolNoticeBanner(icon: "exclamationmark.triangle.fill", message: message)
    }

    @ViewBuilder
    private var stageIndicatorPill: some View {
        let dotColor = net.isRunningSpeedTest ? Theme.readableGreen(for: colorScheme) : accentFg

        HStack(spacing: SpacingTheme.tight) {
            Circle()
                .fill(dotColor)
                .frame(width: 6, height: 6)
                .accessibilityHidden(true)

            Text(stageText)
                .font(Typography.captionBold)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
        .padding(.horizontal, SpacingTheme.standard)
        .padding(.vertical, SpacingTheme.tight)
        .background(Theme.chipBackground(for: colorScheme))
        .overlay(Capsule().stroke(Theme.chipBorder(for: colorScheme), lineWidth: 0.6))
        .clipShape(Capsule())
        .accessibilityElement(children: .combine)
    }

    private var stageText: String {
        switch net.speedTestStage {
        case .idle: return L10n.Network.speedReady
        case .ping: return L10n.Network.speedStagePing
        case .download: return L10n.Network.speedStageDownload
        case .upload: return L10n.Network.speedStageUpload
        case .completed: return L10n.Network.speedStageCompleted
        }
    }

    @ViewBuilder
    private func scorecardCell(title: String, value: String, unit: String, subtext: String?, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: icon)
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(color)
                    .accessibilityHidden(true)

                Text(title)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.micro) {
                Text(value)
                    .font(Typography.headlineValue)
                    .fontDesign(.monospaced)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                if !unit.isEmpty {
                    Text(unit)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }

            if let sub = subtext {
                Text(sub)
                    .font(Typography.badgeTag)
                    .fontDesign(.monospaced)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, SpacingTheme.rowStandard)
        .padding(.vertical, SpacingTheme.row)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue("\(value)\(unit.isEmpty ? "" : " \(unit)")\(subtext.map { ", \($0)" } ?? "")")
    }
}

// MARK: - Speedometer Gauge Arc Shape
private struct SpeedometerGaugeArc: View {
    let currentMbps: Double
    let maxScale: Double
    let accentColor: Color
    @Environment(\.colorScheme) private var colorScheme

    private var progressRatio: Double {
        guard currentMbps.isFinite, currentMbps > 0.05, maxScale > 0 else { return 0.0 }
        let linear = min(1.0, max(0.0, currentMbps / maxScale))
        return sqrt(linear)
    }

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: 0.6667)
                .stroke(
                    colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(150))

            if progressRatio > 0.005 {
                Circle()
                    .trim(from: 0.0, to: 0.6667 * progressRatio)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [accentColor.opacity(0.85), accentColor, Theme.readableCyan(for: colorScheme)]),
                            center: .center,
                            startAngle: .degrees(150),
                            endAngle: .degrees(390)
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(150))
                    .animation(.easeOut(duration: 0.25), value: progressRatio)
            }
        }
        .padding(SpacingTheme.standard)
    }
}

// MARK: - Preview
#Preview {
    NetworkSpeedTestSheet()
}
