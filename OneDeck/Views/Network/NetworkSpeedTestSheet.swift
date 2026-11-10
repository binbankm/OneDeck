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
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    private var uploadAccentColor: Color {
        colorScheme == .dark ? ChartTheme.uploadColor : Theme.readableCyan(for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
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
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.cardStack)
            }
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
                    .foregroundStyle(appState.accentColor)
                }
            }
        }
    }

    // MARK: - 1. Speedometer Arc Gauge HUD
    @ViewBuilder
    private var gaugeSection: some View {
        VStack(spacing: SpacingTheme.row) {
            ZStack {
                SpeedometerGaugeArc(
                    currentMbps: net.speedTestCurrentMbps,
                    maxScale: 500.0,
                    accentColor: appState.accentColor
                )
                .frame(width: 200, height: 160)

                VStack(spacing: SpacingTheme.micro) {
                    let safeMbps = net.speedTestCurrentMbps.isFinite ? net.speedTestCurrentMbps : 0.0
                    Text(String(format: "%.1f", safeMbps))
                        .font(Typography.displayHero)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("Mbps")
                        .font(Typography.calloutLabel)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
                .offset(y: -8)
            }
            .frame(width: 200, height: 160)

            stageIndicatorPill

            let safeProgress = net.speedTestProgress.isFinite ? min(1.0, max(0.0, net.speedTestProgress)) : 0.0
            ProgressView(value: safeProgress)
                .tint(appState.accentColor)
                .scaleEffect(x: 1, y: 1.6, anchor: .center)
                .padding(.horizontal, SpacingTheme.modalPadding)
                .padding(.top, SpacingTheme.tight)
        }
        .padding(.vertical, SpacingTheme.cardStack)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.sheetCard, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
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

        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: SpacingTheme.row) {
            scorecardCell(
                title: L10n.Network.downloadSpeed,
                value: safeDown > 0 ? String(format: "%.1f", safeDown) : "--",
                unit: "Mbps",
                subtext: safeDownPeak > 0 ? L10n.Network.peakSpeedFormatted(mbps: safeDownPeak) : nil,
                icon: "arrow.down.circle.fill",
                color: appState.accentColor
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
                color: Color.orange
            )
        }
    }

    // MARK: - 3. Rating & Server Info Banner
    @ViewBuilder
    private var serverBanner: some View {
        HStack(spacing: SpacingTheme.standard) {
            if !net.speedTestRating.isEmpty {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "medal.fill")
                        .font(IconTheme.badgeInline)
                    Text(net.speedTestRating)
                        .font(Typography.badgeTag)
                        .lineLimit(1)
                }
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.tight)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
            } else {
                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(appState.accentColor)
                        .frame(width: 6, height: 6)
                    Text(L10n.Network.serverNode)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
            }

            Spacer()

            Text(net.speedTestServerName)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
        .padding(.horizontal, SpacingTheme.cardInternal)
        .padding(.vertical, SpacingTheme.row)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
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
        VStack(spacing: SpacingTheme.row) {
            if net.isRunningSpeedTest {
                Button {
                    Haptics.impact(.medium)
                    net.stopSpeedTest()
                } label: {
                    HStack(spacing: SpacingTheme.compact) {
                        Image(systemName: "stop.fill")
                            .font(IconTheme.sectionHeader)
                        Text(L10n.Network.speedTestStop)
                            .font(Typography.headlineValue)
                    }
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, SpacingTheme.rowStandard)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                            .fill(Color.red)
                    )
                }
                .buttonStyle(.plain)
            } else if net.speedTestStage == .completed {
                HStack(spacing: SpacingTheme.rowStandard) {
                    Button {
                        Haptics.selection()
                        net.resetSpeedTest()
                    } label: {
                        Text(L10n.Network.clearResults)
                            .font(Typography.sectionHeader)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, SpacingTheme.rowStandard)
                            .background(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.8))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                            )
                    }
                    .buttonStyle(.plain)

                    Button {
                        Haptics.impact(.medium)
                        net.startSpeedTest()
                    } label: {
                        HStack(spacing: SpacingTheme.compact) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(IconTheme.sectionHeader)
                            Text(L10n.Network.speedTestRestart)
                                .font(Typography.headlineValue)
                        }
                        .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, SpacingTheme.rowStandard)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                                .fill(appState.accentColor)
                        )
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Button {
                    Haptics.impact(.medium)
                    net.startSpeedTest()
                } label: {
                    HStack(spacing: SpacingTheme.standard) {
                        Image(systemName: "play.fill")
                            .font(IconTheme.sectionHeader)
                        Text(L10n.Network.startSpeedTest)
                            .font(Typography.headlineValue)
                    }
                    .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, SpacingTheme.cardInternal)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                            .fill(appState.accentColor)
                    )
                }
                .buttonStyle(.plain)
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

                    Spacer()

                    Button {
                        Haptics.selection()
                        net.clearSpeedTestHistory()
                    } label: {
                        Text(L10n.Network.clearHistory)
                            .font(Typography.captionBold)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    }
                    .buttonStyle(.plain)
                }

                VStack(spacing: SpacingTheme.standard) {
                    ForEach(net.speedTestHistory) { item in
                        let itemDown = item.downloadMbps.isFinite ? item.downloadMbps : 0.0
                        let itemUp = item.uploadMbps.isFinite ? item.uploadMbps : 0.0
                        let itemPing = item.pingMs.isFinite ? item.pingMs : 0.0

                        HStack {
                            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                                Text(item.date, format: .dateTime.month().day().hour().minute())
                                    .font(Typography.captionMono)
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                                Text(item.rating)
                                    .font(Typography.captionBold)
                                    .foregroundStyle(appState.accentColor)
                                    .lineLimit(1)
                            }

                            Spacer()

                            HStack(spacing: SpacingTheme.standard) {
                                Text("↓\(String(format: "%.1f", itemDown))M")
                                    .font(Typography.calloutMono)
                                    .foregroundStyle(appState.accentColor)

                                Text(itemUp > 0 ? "↑\(String(format: "%.1f", itemUp))M" : "↑--")
                                    .font(Typography.calloutMono)
                                    .foregroundStyle(uploadAccentColor)

                                Text("\(String(format: "%.0f", itemPing))ms")
                                    .font(Typography.captionMono)
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            }
                        }
                        .padding(.horizontal, SpacingTheme.rowStandard)
                        .padding(.vertical, SpacingTheme.standard)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                        )
                    }
                }
            }
            .padding(.top, SpacingTheme.tight)
        }
    }

    // MARK: - Subviews & Helpers
    @ViewBuilder
    private func speedTestErrorBanner(_ message: String) -> some View {
        HStack(spacing: SpacingTheme.compact) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(IconTheme.tileLeading)
                .foregroundStyle(.orange)

            Text(message)
                .font(Typography.caption)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(2)

            Spacer()
        }
        .padding(.horizontal, SpacingTheme.rowStandard)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                .fill(Color.orange.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                .stroke(Color.orange.opacity(0.30), lineWidth: 0.8)
        )
    }

    @ViewBuilder
    private var stageIndicatorPill: some View {
        HStack(spacing: SpacingTheme.tight) {
            Circle()
                .fill(net.isRunningSpeedTest ? Color.green : appState.accentColor)
                .frame(width: 6, height: 6)

            Text(stageText)
                .font(Typography.captionBold)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, SpacingTheme.standard)
        .padding(.vertical, SpacingTheme.micro)
        .background(Theme.cardBackground(for: colorScheme).opacity(0.8))
        .clipShape(Capsule())
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

                Text(unit)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            if let sub = subtext {
                Text(sub)
                    .font(Typography.badgeTag)
                    .fontDesign(.monospaced)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme).opacity(0.8))
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, SpacingTheme.rowStandard)
        .padding(.vertical, SpacingTheme.row)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
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
