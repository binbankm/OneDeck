//
//  NetworkPortScannerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Port Scanner Card: Real Non-Blocking POSIX TCP Service & Port Probing.
//

import SwiftUI

struct NetworkPortScannerCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @State private var targetHostInput: String = ""

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            targetHostInputSection
            portStatusGridSection
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(title: L10n.Network.portScanTitle, icon: "shield.lefthalf.filled")

            Spacer()

            // Trigger Scan Button
            Button {
                Haptics.impact(.medium)
                net.scanCommonPorts(targetHost: targetHostInput.isEmpty ? nil : targetHostInput)
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    if net.isScanningPorts {
                        ProgressView()
                            .tint(appState.accentColor)
                            .scaleEffect(0.65)
                    } else {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(IconTheme.actionButton)
                    }

                    Text(net.isScanningPorts ? L10n.Network.querying : L10n.Network.checkPorts)
                        .font(Typography.captionBold)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.tight)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
            }
            .disabled(net.isScanningPorts)
        }
    }

    @ViewBuilder
    private var targetHostInputSection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            HStack(spacing: SpacingTheme.standard) {
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
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.compact)
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
    }

    @ViewBuilder
    private var portStatusGridSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: SpacingTheme.standard) {
            ForEach(net.portScanResults) { item in
                HStack(spacing: SpacingTheme.standard) {
                    Circle()
                        .fill(item.isOpen ? Color.green : Color.secondary.opacity(0.3))
                        .frame(width: 6, height: 6)

                    VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                        HStack(spacing: SpacingTheme.tight) {
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
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.standard)
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

    // MARK: - Button Helper
    @ViewBuilder
    private func quickPresetButton(label: String, host: String) -> some View {
        Button {
            targetHostInput = host
            Haptics.tick()
        } label: {
            Text(label)
                .font(Typography.badgeTagMonoMedium)
                .foregroundStyle(targetHostInput == host ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                .padding(.horizontal, SpacingTheme.compact)
                .padding(.vertical, SpacingTheme.micro)
                .background((targetHostInput == host ? appState.accentColor : Theme.cardBackground(for: colorScheme)).opacity(0.12))
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    NetworkPortScannerCard()
        .padding()
}
