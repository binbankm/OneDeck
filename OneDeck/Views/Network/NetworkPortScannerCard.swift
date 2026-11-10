//
//  NetworkPortScannerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  TCP socket port accessibility and open service inspection card.
//

import SwiftUI

struct NetworkPortScannerCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @State private var targetHostInput: String = ""
    @FocusState private var isHostFieldFocused: Bool

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerSection
            targetHostInputSection
            if let errorMessage = net.portScanError {
                ToolNoticeBanner(icon: "exclamationmark.triangle.fill", message: errorMessage)
            }
            portStatusGridSection
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerSection: some View {
        let scanButton = Button {
            Haptics.impact(.medium)
            triggerPortScan()
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                if net.isScanningPorts {
                    ProgressView()
                        .controlSize(.small)
                        .tint(accentFg)
                } else {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                }

                Text(net.isScanningPorts ? L10n.Network.querying : L10n.Network.checkPorts)
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
        .disabled(net.isScanningPorts)

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                BentoSectionHeader(title: L10n.Network.portScanTitle, icon: "shield.lefthalf.filled")
                scanButton
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                BentoSectionHeader(title: L10n.Network.portScanTitle, icon: "shield.lefthalf.filled")
                Spacer(minLength: SpacingTheme.compact)
                scanButton
            }
        }
    }

    @ViewBuilder
    private var targetHostInputSection: some View {
        let defaultHost = (net.gatewayIPv4 != "--") ? net.gatewayIPv4 : "192.168.1.1"
        let textField = TextField(defaultHost, text: $targetHostInput)
            .font(Typography.calloutMono)
            .foregroundStyle(Theme.textPrimary(for: colorScheme))
            .keyboardType(.URL)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .submitLabel(.go)
            .focused($isHostFieldFocused)
            .onSubmit {
                triggerPortScan()
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    if isHostFieldFocused {
                        Spacer()
                        Button(L10n.Common.done) {
                            isHostFieldFocused = false
                        }
                    }
                }
            }

        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            HStack(spacing: SpacingTheme.standard) {
                Text(L10n.Network.targetHost)
                    .font(Typography.captionBold)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)

                textField
                    .frame(minHeight: LayoutTheme.minTapTarget)

                if !targetHostInput.isEmpty {
                    Button {
                        Haptics.selection()
                        targetHostInput = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(IconTheme.actionButton)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                            .frame(width: LayoutTheme.minTapTarget, height: LayoutTheme.minTapTarget)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .accessibilityLabel(L10n.Common.clearInput)
                }
            }
            .padding(.leading, SpacingTheme.row)
            .padding(.trailing, targetHostInput.isEmpty ? SpacingTheme.row : SpacingTheme.tight)
            .frame(minHeight: LayoutTheme.minTapTarget)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.tileBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(isHostFieldFocused ? accentFg : Theme.tileBorder(for: colorScheme), lineWidth: isHostFieldFocused ? 1.1 : 0.8)
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
        if !net.hasScannedPorts {
            BentoEmptyStateView(
                icon: "network.badge.shield.half.filled",
                message: L10n.Network.portScanEmptyHint,
                height: 96
            )
        } else {
            let green = Theme.readableGreen(for: colorScheme)
            let columns = dynamicTypeSize.isAccessibilitySize
                ? [GridItem(.flexible())]
                : [GridItem(.flexible()), GridItem(.flexible())]

            LazyVGrid(columns: columns, spacing: SpacingTheme.standard) {
                ForEach(net.portScanResults) { item in
                    let statusText = item.isOpen ? L10n.Network.portOpen : L10n.Network.portClosed
                    let latencyStr = (item.isOpen && item.latencyMs.isFinite && item.latencyMs > 0)
                        ? String(format: "%.0fms", item.latencyMs)
                        : ""

                    HStack(spacing: SpacingTheme.standard) {
                        Circle()
                            .fill(item.isOpen ? green : Theme.textTertiary(for: colorScheme).opacity(0.35))
                            .frame(width: 6, height: 6)
                            .accessibilityHidden(true)

                        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                            HStack(spacing: SpacingTheme.tight) {
                                Text(String(item.port))
                                    .font(Typography.calloutMono)
                                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                                Text(item.serviceName)
                                    .font(Typography.badgeTag)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                            }

                            Text(statusText)
                                .font(Typography.badgeTag)
                                .foregroundStyle(item.isOpen ? green : Theme.textTertiary(for: colorScheme))
                        }

                        Spacer(minLength: 0)

                        if !latencyStr.isEmpty {
                            Text(latencyStr)
                                .font(Typography.badgeTagMono)
                                .foregroundStyle(accentFg)
                                .lineLimit(1)
                        }
                    }
                    .padding(.horizontal, SpacingTheme.row)
                    .padding(.vertical, SpacingTheme.standard)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(Theme.tileBackground(for: colorScheme))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(item.isOpen ? green.opacity(0.38) : Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                    )
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("\(item.port) \(item.serviceName)")
                    .accessibilityValue(latencyStr.isEmpty ? statusText : "\(statusText), \(latencyStr)")
                }
            }
        }
    }

    // MARK: - Actions & Button Helper
    private func triggerPortScan() {
        isHostFieldFocused = false
        let trimmed = targetHostInput.trimmingCharacters(in: .whitespacesAndNewlines)
        net.scanCommonPorts(targetHost: trimmed.isEmpty ? nil : trimmed)
    }

    @ViewBuilder
    private func quickPresetButton(label: String, host: String) -> some View {
        let isSelected = targetHostInput == host

        Button {
            isHostFieldFocused = false
            targetHostInput = host
            Haptics.tick()
        } label: {
            Text(label)
                .font(Typography.badgeTagMonoMedium)
                .foregroundStyle(isSelected ? accentFg : Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .padding(.horizontal, SpacingTheme.row)
                .frame(minHeight: LayoutTheme.minTapTarget)
                .background(
                    Capsule()
                        .fill(isSelected ? appState.accentColor.opacity(0.14) : Theme.chipBackground(for: colorScheme))
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? accentFg.opacity(0.45) : Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                )
                .contentShape(Capsule())
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

// MARK: - Preview
#Preview {
    NetworkPortScannerCard()
        .padding()
}
