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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @State private var copiedDeviceID: DiscoveredDevice.ID?
    @State private var copyToastTask: Task<Void, Never>?

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

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
        let titleAndCount = HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(title: L10n.Network.lanScanTitle, icon: "point.3.filled.connected.trianglepath.dotted")

            if !net.discoveredDevices.isEmpty {
                Text("\(net.discoveredDevices.count)")
                    .font(Typography.captionMono)
                    .foregroundStyle(accentFg)
                    .padding(.horizontal, SpacingTheme.compact)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(appState.accentColor.opacity(0.12))
                    .clipShape(Capsule())
                    .accessibilityLabel(L10n.Network.devicesCountText(count: net.discoveredDevices.count))
            }
        }

        let scanButton = Button {
            Haptics.impact(.medium)
            net.startLanScan()
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                if net.isScanningLan {
                    ProgressView()
                        .controlSize(.small)
                        .tint(accentFg)
                } else {
                    Image(systemName: "sensor.tag.radiowaves.forward.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                }

                Text(net.isScanningLan ? L10n.Network.scanning : L10n.Network.startScan)
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
        .disabled(net.isScanningLan)

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                titleAndCount
                scanButton
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                titleAndCount
                Spacer(minLength: SpacingTheme.compact)
                scanButton
            }
        }
    }

    @ViewBuilder
    private var devicesListSection: some View {
        if net.discoveredDevices.isEmpty {
            BentoEmptyStateView(
                icon: "wifi.router.fill",
                message: net.isScanningLan ? L10n.Network.scanning : L10n.Network.noLanDevices,
                subtitle: L10n.Network.noLanDevicesHint,
                showsProgress: net.isScanningLan,
                height: 120
            )
        } else {
            let green = Theme.readableGreen(for: colorScheme)

            VStack(spacing: SpacingTheme.standard) {
                ForEach(net.discoveredDevices) { device in
                    let hasValidIP = device.ipAddress != "--" && !device.ipAddress.isEmpty
                    let serviceName = friendlyServiceType(device.serviceType)

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
                                .foregroundStyle(accentFg)
                                .frame(width: 24, height: 24, alignment: .center)
                                .accessibilityHidden(true)

                            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                                HStack(spacing: SpacingTheme.compact) {
                                    Text(device.name)
                                        .font(Typography.bodyValue)
                                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                        .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                                        .minimumScaleFactor(0.85)

                                    if let vendor = device.vendorName, vendor != device.name {
                                        Text(vendor)
                                            .font(Typography.badgeTagMedium)
                                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                                            .lineLimit(1)
                                    }
                                }

                                FlowLayout(spacing: SpacingTheme.compact, rowSpacing: SpacingTheme.micro) {
                                    if device.ipAddress != "--" {
                                        Text(device.ipAddress)
                                            .font(Typography.captionMono)
                                            .foregroundStyle(accentFg)
                                    }

                                    if let mac = device.macAddress {
                                        Text(mac.uppercased())
                                            .font(Typography.badgeTagMonoMedium)
                                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                    }

                                    Text("· \(serviceName)")
                                        .font(Typography.badgeTagMedium)
                                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                }
                            }

                            Spacer(minLength: SpacingTheme.compact)

                            if copiedDeviceID == device.id {
                                Text(L10n.Common.copied)
                                    .font(Typography.badgeTag)
                                    .foregroundStyle(accentFg)
                                    .transition(.opacity)
                            } else if let lat = device.latencyMs, lat.isFinite {
                                Text(String(format: "%.0fms", lat))
                                    .font(Typography.badgeTagMono)
                                    .foregroundStyle(green)
                                    .padding(.horizontal, SpacingTheme.compact)
                                    .padding(.vertical, SpacingTheme.micro)
                                    .background(green.opacity(0.12))
                                    .clipShape(Capsule())
                            } else {
                                Circle()
                                    .fill(green)
                                    .frame(width: 6, height: 6)
                                    .accessibilityHidden(true)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget, alignment: .leading)
                        .padding(.horizontal, SpacingTheme.row)
                        .padding(.vertical, SpacingTheme.standard)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .fill(Theme.tileBackground(for: colorScheme))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .disabled(!hasValidIP)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(device.name)\(hasValidIP ? ", \(device.ipAddress)" : ""), \(serviceName)")
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
            return L10n.Network.airPlayAudio
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
