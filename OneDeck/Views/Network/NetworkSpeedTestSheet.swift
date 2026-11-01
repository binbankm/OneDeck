//
//  NetworkSpeedTestSheet.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Bandwidth Speed Test Sheet: Live Speedometer, Gauge, 4-Quadrant Scorecard & Ratings.
//

import SwiftUI

struct NetworkSpeedTestSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var appState = AppState.shared
    @Bindable var net = NetworkService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    gaugeSection
                    scorecardGrid
                    serverBanner
                    actionDispatcherSection
                    historySection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Network.speedTestTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        dismiss()
                    }
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(appState.accentColor)
                }
            }
        }
    }

    // MARK: - 1. Speedometer Arc Gauge HUD
    @ViewBuilder
    private var gaugeSection: some View {
        VStack(spacing: 10) {
            ZStack {
                // Speedometer Gauge Arc (240-degree top arch)
                SpeedometerGaugeArc(
                    currentMbps: net.speedTestCurrentMbps,
                    maxScale: 500.0,
                    accentColor: appState.accentColor
                )
                .frame(width: 200, height: 160)

                // Digital Center Readout
                VStack(spacing: 2) {
                    Text(String(format: "%.1f", net.speedTestCurrentMbps))
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("Mbps")
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
                .offset(y: -8)
            }
            .frame(width: 200, height: 160)

            // Stage Pill (In bottom arch opening)
            stageIndicatorPill

            // Linear Overall Progress Bar
            ProgressView(value: net.speedTestProgress)
                .tint(appState.accentColor)
                .scaleEffect(x: 1, y: 1.6, anchor: .center)
                .padding(.horizontal, 24)
                .padding(.top, 4)
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    // MARK: - 2. 4-Quadrant Scorecard Bento Grid
    @ViewBuilder
    private var scorecardGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            scorecardCell(
                title: L10n.Network.downloadSpeed,
                value: net.speedTestDownloadMbps > 0 ? String(format: "%.1f", net.speedTestDownloadMbps) : "--",
                unit: "Mbps",
                subtext: net.speedTestDownloadPeakMbps > 0 ? L10n.Network.peakSpeedFormatted(mbps: net.speedTestDownloadPeakMbps) : nil,
                icon: "arrow.down.circle.fill",
                color: appState.accentColor
            )

            scorecardCell(
                title: L10n.Network.uploadSpeed,
                value: net.speedTestUploadMbps > 0 ? String(format: "%.1f", net.speedTestUploadMbps) : "--",
                unit: "Mbps",
                subtext: net.speedTestUploadPeakMbps > 0 ? L10n.Network.peakSpeedFormatted(mbps: net.speedTestUploadPeakMbps) : nil,
                icon: "arrow.up.circle.fill",
                color: Color.mint
            )

            scorecardCell(
                title: L10n.Network.latencyTitle,
                value: net.speedTestPingMs > 0 ? String(format: "%.0f", net.speedTestPingMs) : "--",
                unit: "ms",
                subtext: nil,
                icon: "bolt.horizontal.circle.fill",
                color: Color.cyan
            )

            scorecardCell(
                title: L10n.Network.jitter,
                value: net.speedTestJitterMs > 0 ? String(format: "±%.1f", net.speedTestJitterMs) : "--",
                unit: "ms",
                subtext: nil,
                icon: "waveform.path.ecg",
                color: Color.orange
            )
        }
    }

    // MARK: - 3. Rating & Server Info Banner
    @ViewBuilder
    private var serverBanner: some View {
        HStack(spacing: 8) {
            if !net.speedTestRating.isEmpty {
                HStack(spacing: 5) {
                    Image(systemName: "rosette")
                        .font(.system(size: 11, weight: .bold))
                    Text(net.speedTestRating)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .lineLimit(1)
                }
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
            } else {
                HStack(spacing: 5) {
                    Circle()
                        .fill(appState.accentColor)
                        .frame(width: 6, height: 6)
                    Text(L10n.Network.serverNode)
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
            }

            Spacer()

            Text(net.speedTestServerName)
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    // MARK: - 4. Action Dispatcher Controls
    @ViewBuilder
    private var actionDispatcherSection: some View {
        VStack(spacing: 10) {
            if net.isRunningSpeedTest {
                Button {
                    Haptics.impact(.medium)
                    net.stopSpeedTest()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "stop.fill")
                            .font(.system(size: 13, weight: .bold))
                        Text(L10n.Network.speedTestStop)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.red)
                    )
                }
                .buttonStyle(.plain)
            } else if net.speedTestStage == .completed {
                HStack(spacing: 12) {
                    Button {
                        Haptics.selection()
                        net.resetSpeedTest()
                    } label: {
                        Text(L10n.Network.clearResults)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.8))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                            )
                    }
                    .buttonStyle(.plain)

                    Button {
                        Haptics.impact(.medium)
                        net.startSpeedTest()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 13, weight: .bold))
                            Text(L10n.Network.speedTestRestart)
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
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
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 14, weight: .bold))
                        Text(L10n.Network.startSpeedTest)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(appState.accentColor)
                    )
                    .shadow(color: appState.accentColor.opacity(0.3), radius: 8, x: 0, y: 3)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 6)
    }

    // MARK: - 5. Speed Test History Section
    @ViewBuilder
    private var historySection: some View {
        if !net.speedTestHistory.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(L10n.Network.speedTestHistory)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Spacer()

                    Button {
                        Haptics.selection()
                        net.clearSpeedTestHistory()
                    } label: {
                        Text(L10n.Network.clearHistory)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    }
                }

                VStack(spacing: 8) {
                    ForEach(net.speedTestHistory) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.date, format: .dateTime.month().day().hour().minute())
                                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))

                                Text(item.rating)
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundStyle(appState.accentColor)
                                    .lineLimit(1)
                            }

                            Spacer()

                            HStack(spacing: 8) {
                                Text("↓\(String(format: "%.1f", item.downloadMbps))M")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundStyle(appState.accentColor)

                                Text("↑\(String(format: "%.1f", item.uploadMbps))M")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundStyle(Color.mint)

                                Text("\(String(format: "%.0f", item.pingMs))ms")
                                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                        )
                    }
                }
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var stageIndicatorPill: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(net.isRunningSpeedTest ? Color.green : appState.accentColor)
                .frame(width: 6, height: 6)

            Text(stageText)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
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
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(color)

                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.system(size: 17, weight: .bold, design: .monospaced))
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Text(unit)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            if let sub = subtext {
                Text(sub)
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundStyle(Theme.textSecondary(for: colorScheme).opacity(0.8))
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }
}

// MARK: - Speedometer Gauge Arc Shape (240° arch over the top)
private struct SpeedometerGaugeArc: View {
    let currentMbps: Double
    let maxScale: Double
    let accentColor: Color
    @Environment(\.colorScheme) private var colorScheme

    // Non-linear calibrated ratio (sqrt) for intuitive dynamic response across 1-500 Mbps
    private var progressRatio: Double {
        guard currentMbps > 0.05 else { return 0.0 }
        let linear = min(1.0, max(0.0, currentMbps / maxScale))
        return sqrt(linear)
    }

    var body: some View {
        ZStack {
            // Track Arc: 240 degrees arch starting at 150° (bottom-left) to 30° (bottom-right)
            Circle()
                .trim(from: 0.0, to: 0.6667)
                .stroke(
                    colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(150))

            // Dynamic Fill Arc (only drawn when currentMbps has actual signal)
            if progressRatio > 0.005 {
                Circle()
                    .trim(from: 0.0, to: 0.6667 * progressRatio)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [accentColor.opacity(0.85), accentColor, Color.cyan]),
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
        .padding(8)
    }
}
