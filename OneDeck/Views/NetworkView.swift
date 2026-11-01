//
//  NetworkView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Tab: Wi-Fi, Cellular, Ping Latency, LAN Discovery & WOL.
//

import SwiftUI

struct NetworkView: View {
    @Bindable var appState = AppState.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var pingLatency: Int = 18

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 16) {
                    // MARK: - Wi-Fi Status Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Label(L10n.Network.wifiStatus, systemImage: "wifi")
                                .font(.system(.headline, design: .rounded))
                                .foregroundStyle(appState.accentColor)
                            Spacer()
                            Text("已连接")
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(appState.accentColor.opacity(0.15))
                                .foregroundStyle(appState.accentColor)
                                .clipShape(Capsule())
                        }

                        Divider().opacity(0.3)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            netItem(label: L10n.Network.ssid, value: "Home-Wi-Fi-5G")
                            netItem(label: L10n.Network.localIP, value: "192.168.1.108")
                            netItem(label: L10n.Network.gateway, value: "192.168.1.1")
                            netItem(label: L10n.Network.publicIP, value: "114.88.23.15")
                        }
                    }
                    .bentoCard(accent: appState.accentColor)

                    // MARK: - Ping Latency Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label(L10n.Network.pingTest, systemImage: "waveform.path.ecg")
                                .font(.system(.headline, design: .rounded))
                                .foregroundStyle(appState.accentColor)
                            Spacer()
                            Button {
                                Haptics.tick()
                                pingLatency = Int.random(in: 12...28)
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .font(.subheadline)
                                    .foregroundStyle(appState.accentColor)
                            }
                        }

                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text("\(pingLatency)")
                                .font(.system(size: 38, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(appState.accentColor)
                            Text("ms (1.1.1.1 Cloudflare DNS)")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        }
                    }
                    .bentoCard(accent: appState.accentColor)

                    // MARK: - LAN Scanner & WOL Tools Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        Button {
                            Haptics.impact(.medium)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: "bonjour")
                                    .font(.title2)
                                    .foregroundStyle(appState.accentColor)
                                Text(L10n.Network.lanScan)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                Text("发现 12 台内网设备")
                                    .font(.caption2)
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bentoCard(accent: appState.accentColor)
                        }
                        .buttonStyle(.plain)

                        Button {
                            Haptics.success()
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: "power.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(appState.accentColor)
                                Text(L10n.Network.wol)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                Text("发送唤醒魔术包")
                                    .font(.caption2)
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .bentoCard(accent: appState.accentColor)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(width: geometry.size.width)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Network.title)
        }
    }

    @ViewBuilder
    private func netItem(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
            Text(value)
                .font(.subheadline)
                .fontDesign(.monospaced)
                .fontWeight(.medium)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
    }
}

