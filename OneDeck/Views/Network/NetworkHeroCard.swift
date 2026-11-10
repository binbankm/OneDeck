//
//  NetworkHeroCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Active network interface, link speed, and connectivity status hero card.
//

import SwiftUI

struct NetworkHeroCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @State private var copiedItem: String?
    @State private var copyToastTask: Task<Void, Never>?

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            interfaceBannerSection
            BentoHairlineDivider()
            metricGridSection
            specsFooterSection
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
        let statusColor = net.isConnected
            ? Theme.readableGreen(for: colorScheme)
            : Theme.readableRed(for: colorScheme)
        let statusText = net.isConnected ? L10n.Network.connected : L10n.Network.disconnected

        let statusBadge = HStack(spacing: SpacingTheme.tight) {
            Circle()
                .fill(statusColor)
                .frame(width: 7, height: 7)
                .accessibilityHidden(true)

            Text(statusText)
                .font(Typography.calloutBold)
                .foregroundStyle(statusColor)
                .lineLimit(1)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.tight)
        .background(statusColor.opacity(0.12))
        .clipShape(Capsule())
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Network.linkStatusTitle)
        .accessibilityValue(statusText)

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                BentoSectionHeader(title: L10n.Network.linkStatusTitle, icon: net.linkType.iconName)
                statusBadge
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                BentoSectionHeader(title: L10n.Network.linkStatusTitle, icon: net.linkType.iconName)
                Spacer(minLength: SpacingTheme.compact)
                statusBadge
            }
        }
    }

    @ViewBuilder
    private var interfaceBannerSection: some View {
        let bannerTitle: String = {
            if net.linkType == .wifi {
                if let ssid = net.wifiSSID, !ssid.isEmpty { return ssid }
                return net.linkType.localizedName
            } else if net.linkType == .cellular {
                return net.carrierName.isEmpty ? L10n.Network.cellular : net.carrierName
            } else {
                return net.linkType.localizedName
            }
        }()

        let genTag = net.linkType == .cellular
            ? net.cellularGeneration
            : (net.linkType == .wifi ? net.wifiHardwareGeneration : "")

        let subDetails: String = {
            if net.linkType == .wifi {
                var parts = ["en0", net.wifiStandard]
                if let rssi = net.wifiRssiDbm { parts.append("\(rssi) dBm") }
                if let ch = net.wifiChannel { parts.append("CH\(ch)") }
                if let rate = net.wifiTxRateMbps { parts.append("\(rate) Mbps") }
                return parts.joined(separator: " · ")
            } else if net.linkType == .cellular {
                return "pdp_ip0 · \(L10n.Network.cellularBasebandDesc)"
            } else {
                return "lo0"
            }
        }()

        let orangeColor = Theme.readableOrange(for: colorScheme)
        let yellowColor = Theme.readableYellow(for: colorScheme)
        let genColor = net.linkType == .cellular ? orangeColor : accentFg

        let mainContent = VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            FlowLayout(spacing: SpacingTheme.compact, rowSpacing: SpacingTheme.tight) {
                Text(bannerTitle)
                    .font(Typography.title1)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                if !genTag.isEmpty {
                    Text(genTag)
                        .font(Typography.badgeTag)
                        .foregroundStyle(genColor)
                        .lineLimit(1)
                        .padding(.horizontal, SpacingTheme.compact)
                        .padding(.vertical, SpacingTheme.micro)
                        .background(genColor.opacity(0.14))
                        .clipShape(Capsule())
                }
            }

            FlowLayout(spacing: SpacingTheme.compact, rowSpacing: SpacingTheme.tight) {
                Text(subDetails)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                    .minimumScaleFactor(0.8)

                if net.isExpensive {
                    Text(L10n.Network.expensiveCellular)
                        .font(Typography.badgeTag)
                        .foregroundStyle(orangeColor)
                        .padding(.horizontal, SpacingTheme.compact)
                        .padding(.vertical, SpacingTheme.micro)
                        .background(orangeColor.opacity(0.14))
                        .clipShape(Capsule())
                }

                if net.isConstrained {
                    Text(L10n.Network.lowDataMode)
                        .font(Typography.badgeTag)
                        .foregroundStyle(yellowColor)
                        .padding(.horizontal, SpacingTheme.compact)
                        .padding(.vertical, SpacingTheme.micro)
                        .background(yellowColor.opacity(0.14))
                        .clipShape(Capsule())
                }
            }
        }

        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    mainContent

                    if let copied = copiedItem {
                        Text("\(copied) \(L10n.Network.copied)")
                            .font(Typography.captionBold)
                            .foregroundStyle(accentFg)
                            .transition(.opacity.combined(with: .scale))
                    }
                }
            } else {
                HStack(alignment: .center, spacing: SpacingTheme.rowStandard) {
                    mainContent

                    Spacer(minLength: SpacingTheme.compact)

                    if let copied = copiedItem {
                        Text("\(copied) \(L10n.Network.copied)")
                            .font(Typography.captionBold)
                            .foregroundStyle(accentFg)
                            .lineLimit(1)
                            .transition(.opacity.combined(with: .scale))
                    }
                }
            }
        }
        .padding(.vertical, SpacingTheme.micro)
    }

    @ViewBuilder
    private var metricGridSection: some View {
        let columns = dynamicTypeSize.isAccessibilitySize
            ? [GridItem(.flexible())]
            : [GridItem(.flexible()), GridItem(.flexible())]

        LazyVGrid(columns: columns, spacing: SpacingTheme.row) {
            metricCell(
                label: L10n.Network.localIP,
                value: net.localIPv4,
                icon: "network",
                canCopy: true
            )

            metricCell(
                label: L10n.Network.gateway,
                value: net.gatewayIPv4,
                icon: "point.3.filled.connected.trianglepath.dotted",
                canCopy: true
            )

            metricCell(
                label: L10n.Network.subnetMask,
                value: net.subnetMask,
                icon: "shield.lefthalf.filled",
                canCopy: false
            )

            metricCell(
                label: L10n.Network.dnsServer,
                value: net.dnsServers.first ?? "--",
                icon: "cylinder.split.1x2.fill",
                canCopy: true
            )
        }
    }

    @ViewBuilder
    private var specsFooterSection: some View {
        let mtuBlock = HStack(spacing: SpacingTheme.tight) {
            Text(L10n.Network.mtu)
                .font(Typography.badgeTag)
                .foregroundStyle(accentFg)
                .lineLimit(1)
                .padding(.horizontal, SpacingTheme.tight)
                .padding(.vertical, SpacingTheme.micro)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.micro, style: .continuous))

            Text("\(net.interfaceMtu) B")
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Network.mtu)
        .accessibilityValue("\(net.interfaceMtu) B")

        let subnetBlock = Group {
            if net.subnetRange != "--" {
                HStack(spacing: SpacingTheme.tight) {
                    Text(L10n.Network.subnetRange)
                        .font(Typography.badgeTagMedium)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)

                    Text(net.subnetRange)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(L10n.Network.subnetRange)
                .accessibilityValue(net.subnetRange)
            }
        }

        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    mtuBlock
                    subnetBlock
                }
            } else {
                HStack(spacing: SpacingTheme.rowStandard) {
                    mtuBlock
                    Spacer(minLength: SpacingTheme.compact)
                    subnetBlock
                }
            }
        }
        .padding(.top, SpacingTheme.micro)
    }

    // MARK: - Metric Cell Helper
    @ViewBuilder
    private func metricCell(label: String, value: String, icon: String, canCopy: Bool) -> some View {
        let copyEnabled = canCopy && value != "--" && !value.isEmpty

        Button {
            guard copyEnabled else { return }
            UIPasteboard.general.string = value
            Haptics.tick()
            withAnimation(.easeInOut(duration: 0.2)) {
                copiedItem = label
            }
            copyToastTask?.cancel()
            copyToastTask = Task { @MainActor in
                try? await Task.sleep(for: .seconds(1.8))
                guard !Task.isCancelled else { return }
                withAnimation {
                    if copiedItem == label {
                        copiedItem = nil
                    }
                }
            }
        } label: {
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: icon)
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(accentFg.opacity(0.85))
                        .accessibilityHidden(true)

                    Text(label)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: 0)

                    if copyEnabled {
                        Image(systemName: "doc.on.doc.fill")
                            .font(IconTheme.copyIndicator)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                            .accessibilityHidden(true)
                    }
                }

                Text(value)
                    .font(Typography.bodyValueMono)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? 2 : 1)
                    .minimumScaleFactor(0.75)
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget, alignment: .leading)
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
        .disabled(!copyEnabled)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(value)
        .accessibilityHint(copyEnabled ? L10n.Common.copyValue : "")
    }
}

// MARK: - Preview
#Preview {
    NetworkHeroCard()
        .padding()
}
