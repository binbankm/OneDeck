//
//  NetworkPortScannerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Port Scanner Card: Real Non-Blocking POSIX TCP Service & Port Probing.
//

import SwiftUI

struct NetworkPortScannerCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var net = NetworkService.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var targetHostInput: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            // MARK: - Header
            HStack(spacing: 8) {
                BentoSectionHeader(title: L10n.Network.portScanTitle, icon: "door.left.hand.open")

                Spacer()

                // Trigger Scan Button
                Button {
                    Haptics.impact(.medium)
                    net.scanCommonPorts(targetHost: targetHostInput.isEmpty ? nil : targetHostInput)
                } label: {
                    HStack(spacing: 4) {
                        if net.isScanningPorts {
                            ProgressView()
                                .tint(appState.accentColor)
                                .scaleEffect(0.65)
                        } else {
                            Image(systemName: "magnifyingglass")
                                .font(IconTheme.actionButton)
                        }

                        Text(net.isScanningPorts ? L10n.Network.querying : L10n.Network.checkPorts)
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
                .disabled(net.isScanningPorts)
            }

            // MARK: - Target Host Sub-banner with Quick Switchers
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(L10n.Network.targetHost)
                        .font(Typography.captionBold)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)

                    let defaultHost = (net.gatewayIPv4 != "--") ? net.gatewayIPv4 : "192.168.1.1"
                    TextField(defaultHost, text: $targetHostInput)
                        .font(Typography.calloutMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .keyboardType(.numbersAndPunctuation)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    if !targetHostInput.isEmpty {
                        Button {
                            targetHostInput = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(IconTheme.actionButton)
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                        .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )

                // Quick Presets
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: SpacingTheme.compact) {
                        let gw = (net.gatewayIPv4 != "--") ? net.gatewayIPv4 : "192.168.1.1"
                        quickPresetButton(label: L10n.Network.targetGateway(ip: gw), host: gw)
                        quickPresetButton(label: L10n.Network.targetLocalhost, host: "127.0.0.1")
                        if net.localIPv4 != "--" && net.localIPv4 != gw {
                            quickPresetButton(label: L10n.Network.targetSubnet, host: net.localIPv4)
                        }
                    }
                }
            }

            // MARK: - Port Status Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(net.portScanResults) { item in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(item.isOpen ? Color.green : Color.secondary.opacity(0.3))
                            .frame(width: 6, height: 6)

                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 4) {
                                Text(String(item.port))
                                    .font(Typography.calloutLabel)
                                    .fontDesign(.monospaced)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                                Text(item.serviceName)
                                    .font(Typography.badgeTag)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                            }

                            Text(item.isOpen ? L10n.Network.portOpen : L10n.Network.portClosed)
                                .font(Typography.badgeTag)
                                .foregroundStyle(item.isOpen ? Color.green : Theme.textSecondary(for: colorScheme).opacity(0.7))
                        }

                        Spacer(minLength: 0)

                        if item.isOpen && item.latencyMs > 0 {
                            Text(String(format: "%.0fms", item.latencyMs))
                                .font(Typography.badgeTagMono)
                                .foregroundStyle(appState.accentColor)
                                .lineLimit(1)
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
                            .stroke(item.isOpen ? Color.green.opacity(0.35) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                    )
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    @ViewBuilder
    private func quickPresetButton(label: String, host: String) -> some View {
        Button {
            targetHostInput = host
            Haptics.tick()
        } label: {
            Text(label)
                .font(Typography.badgeTagMonoMedium)
                .foregroundStyle(targetHostInput == host ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                .padding(.horizontal, 6)
                .padding(.vertical, SpacingTheme.micro)
                .background((targetHostInput == host ? appState.accentColor : Theme.cardBackground(for: colorScheme)).opacity(0.12))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
