//
//  NetworkLanScannerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Local subnet ARP scanner and connected device discovery card.
//

import SwiftUI

struct NetworkLanScannerCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @State private var copiedDeviceID: DiscoveredDevice.ID?
    @State private var copyToastTask: Task<Void, Never>?

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            devicesListSection
        }
        .bentoCard(accent: appState.accentColor)
        .onDisappear {
            copyToastTask?.cancel()
            copyToastTask = nil
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(title: L10n.Network.lanScanTitle, icon: "point.3.filled.connected.trianglepath.dotted")

            if !net.discoveredDevices.isEmpty {
                Text("\(net.discoveredDevices.count)")
                    .font(Typography.captionMono)
                    .foregroundStyle(appState.accentColor)
                    .padding(.horizontal, SpacingTheme.compact)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(appState.accentColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            Spacer()

            // Trigger Scan Button
            Button {
                Haptics.impact(.medium)
                net.startLanScan()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    if net.isScanningLan {
                        ProgressView()
                            .tint(appState.accentColor)
                            .scaleEffect(0.65)
                    } else {
                        Image(systemName: "sensor.tag.radiowaves.forward.fill")
                            .font(IconTheme.actionButton)
                    }

                    Text(net.isScanningLan ? L10n.Network.scanning : L10n.Network.startScan)
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
            .buttonStyle(.plain)
            .disabled(net.isScanningLan)
        }
    }

    @ViewBuilder
    private var devicesListSection: some View {
        if net.discoveredDevices.isEmpty {
            VStack(spacing: SpacingTheme.standard) {
                Image(systemName: net.isScanningLan ? "antenna.radiowaves.left.and.right.circle.fill" : "wifi.router.fill")
                    .font(IconTheme.emptyState)
                    .foregroundStyle(appState.accentColor.opacity(0.7))
                    .symbolEffect(.pulse, isActive: net.isScanningLan)

                Text(net.isScanningLan ? L10n.Network.scanning : L10n.Network.noLanDevices)
                    .font(Typography.bodyValue)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(L10n.Network.noLanDevicesHint)
                    .font(Typography.captionRegular)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, SpacingTheme.heroPadding)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.4))
            )
        } else {
            VStack(spacing: SpacingTheme.standard) {
                ForEach(net.discoveredDevices) { device in
                    let hasValidIP = device.ipAddress != "--" && !device.ipAddress.isEmpty
                    Button {
                        guard hasValidIP else { return }
                        UIPasteboard.general.string = device.ipAddress
                        Haptics.tick()
                        withAnimation(.easeInOut(duration: 0.2)) {
                            copiedDeviceID = device.id
                        }
                        copyToastTask?.cancel()
                        copyToastTask = Task { @MainActor in
                            try? await Task.sleep(for: .seconds(1.8))
                            guard !Task.isCancelled else { return }
                            withAnimation {
                                if copiedDeviceID == device.id {
                                    copiedDeviceID = nil
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: SpacingTheme.row) {
                            Image(systemName: device.iconName)
                                .font(IconTheme.sectionHeader)
                                .foregroundStyle(appState.accentColor)
                                .frame(width: 24, height: 24, alignment: .center)

                            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                                HStack(spacing: SpacingTheme.compact) {
                                    Text(device.name)
                                        .font(Typography.bodyValue)
                                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.85)

                                    if let vendor = device.vendorName, vendor != device.name {
                                        Text(vendor)
                                            .font(Typography.badgeTagMedium)
                                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                                            .lineLimit(1)
                                    }
                                }

                                HStack(spacing: SpacingTheme.compact) {
                                    if device.ipAddress != "--" {
                                        Text(device.ipAddress)
                                            .font(Typography.captionMono)
                                            .foregroundStyle(appState.accentColor)
                                    }

                                    if let mac = device.macAddress {
                                        Text(mac.uppercased())
                                            .font(Typography.badgeTagMonoMedium)
                                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                    }

                                    Text("· \(friendlyServiceType(device.serviceType))")
                                        .font(Typography.badgeTagMedium)
                                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                }
                            }

                            Spacer()

                            if copiedDeviceID == device.id {
                                Text(L10n.Common.copied)
                                    .font(Typography.badgeTag)
                                    .foregroundStyle(appState.accentColor)
                                    .transition(.opacity)
                            } else if let lat = device.latencyMs, lat.isFinite {
                                Text(String(format: "%.0fms", lat))
                                    .font(Typography.badgeTagMono)
                                    .foregroundStyle(Color.green)
                                    .padding(.horizontal, SpacingTheme.compact)
                                    .padding(.vertical, SpacingTheme.micro)
                                    .background(Color.green.opacity(0.12))
                                    .clipShape(Capsule())
                            } else {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .contentShape(Rectangle())
                        .padding(.horizontal, SpacingTheme.row)
                        .padding(.vertical, SpacingTheme.standard)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(!hasValidIP)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(device.name)\(hasValidIP ? ", \(device.ipAddress)" : "")")
                    .accessibilityHint(hasValidIP ? L10n.Network.copyDeviceIp : "")
                }
            }
        }
    }

    // MARK: - Helpers
    private func friendlyServiceType(_ type: String) -> String {
        if type.contains("airplay") {
            return "AirPlay"
        } else if type.contains("smb") {
            return "SMB"
        } else if type.contains("raop") {
            return "AirPlay Audio"
        } else if type.contains("http") {
            return "HTTP"
        } else {
            return type.replacingOccurrences(of: "._tcp", with: "").replacingOccurrences(of: "_", with: "")
        }
    }
}

// MARK: - Preview
#Preview {
    NetworkLanScannerCard()
        .padding()
}
