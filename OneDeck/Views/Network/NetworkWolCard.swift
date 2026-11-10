//
//  NetworkWolCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Wake-on-LAN magic packet transmitter and host wake card.
//

import SwiftUI

struct NetworkWolCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @AppStorage("onedeck_last_wol_mac") private var targetMac: String = "00:11:32:8A:2C:1F"
    @State private var feedbackMessage: String?
    @State private var isSuccess: Bool = true
    @State private var feedbackDismissTask: Task<Void, Never>?
    @FocusState private var isFieldFocused: Bool

    // Quick Presets
    private var presets: [(name: String, mac: String)] {
        [
            (L10n.Network.presetNas, "00:11:32:8A:2C:1F"),
            (L10n.Network.presetWorkstation, "B4:2E:99:4D:10:8A"),
            (L10n.Network.presetMedia, "70:85:C2:55:E1:90")
        ]
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerRow
            macInputField
            presetsRow
            feedbackBanner
            sendPacketButton
        }
        .bentoCard(accent: appState.accentColor)
        .onDisappear {
            feedbackDismissTask?.cancel()
            feedbackDismissTask = nil
        }
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(title: L10n.Network.wolTitle, icon: "power.circle.fill")

            Spacer()

            Text(L10n.Network.wolPortBadge)
                .font(Typography.captionMono)
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.micro)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
        }
    }

    // MARK: - MAC Input Field
    @ViewBuilder
    private var macInputField: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            Text(L10n.Network.macAddress)
                .font(Typography.captionBold)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: "number.square.fill")
                    .font(IconTheme.sectionHeader)
                    .foregroundStyle(appState.accentColor)

                TextField("AA:BB:CC:DD:EE:FF", text: $targetMac)
                    .font(Typography.headlineValue)
                    .fontDesign(.monospaced)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .keyboardType(.asciiCapable)
                    .submitLabel(.send)
                    .focused($isFieldFocused)
                    .onSubmit {
                        sendMagicPacket()
                    }
                    .onChange(of: targetMac) { _, newVal in
                        let upper = newVal.uppercased()
                        if targetMac != upper {
                            targetMac = upper
                        }
                    }

                if !targetMac.isEmpty {
                    Button {
                        targetMac = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(IconTheme.actionButton)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(L10n.Common.clearInput)
                }

                // Paste Button
                Button {
                    if let clip = UIPasteboard.general.string {
                        targetMac = clip.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                        Haptics.tick()
                    }
                } label: {
                    Image(systemName: "doc.on.clipboard.fill")
                        .font(IconTheme.actionButton)
                        .foregroundStyle(appState.accentColor)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(L10n.Network.pasteMac)
            }
            .padding(.horizontal, SpacingTheme.rowStandard)
            .padding(.vertical, SpacingTheme.row)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(isFieldFocused ? appState.accentColor : Theme.cardBorder(for: colorScheme), lineWidth: isFieldFocused ? 1.2 : 0.8)
            )
        }
    }

    // MARK: - Quick Presets
    @ViewBuilder
    private var presetsRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            Text(L10n.Network.presets)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .layoutPriority(1)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SpacingTheme.compact) {
                    ForEach(presets, id: \.mac) { preset in
                        WolPresetButton(
                            name: preset.name,
                            mac: preset.mac,
                            isSelected: targetMac == preset.mac,
                            accentColor: appState.accentColor
                        ) {
                            Haptics.selection()
                            targetMac = preset.mac
                        }
                    }
                }
            }
        }
    }

    // MARK: - Feedback Banner
    @ViewBuilder
    private var feedbackBanner: some View {
        if let msg = feedbackMessage {
            HStack(spacing: SpacingTheme.compact) {
                Image(systemName: isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .font(IconTheme.actionButton)
                    .foregroundStyle(isSuccess ? Color.green : Color.red)

                Text(msg)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(isSuccess ? Color.green : Color.red)

                Spacer()
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
            .background((isSuccess ? Color.green : Color.red).opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }

    // MARK: - Send Magic Packet Button
    private var hasEnoughMacHexDigits: Bool {
        targetMac.filter(\.isHexDigit).count >= 12
    }

    private func sendMagicPacket() {
        guard hasEnoughMacHexDigits else { return }
        isFieldFocused = false
        let result = net.sendWakeOnLan(macAddress: targetMac)
        withAnimation(.easeInOut(duration: 0.25)) {
            self.isSuccess = result.success
            self.feedbackMessage = result.message
        }
        feedbackDismissTask?.cancel()
        feedbackDismissTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(3.0))
            guard !Task.isCancelled else { return }
            withAnimation {
                if feedbackMessage == result.message {
                    feedbackMessage = nil
                }
            }
        }
    }

    @ViewBuilder
    private var sendPacketButton: some View {
        Button {
            sendMagicPacket()
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: "bolt.fill")
                    .font(IconTheme.sectionHeader)

                Text(L10n.Network.sendWol)
                    .font(Typography.sectionHeader)
            }
            .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
            .frame(maxWidth: .infinity)
            .padding(.vertical, SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(appState.accentColor)
            )
        }
        .buttonStyle(.plain)
        .disabled(!hasEnoughMacHexDigits)
        .opacity(hasEnoughMacHexDigits ? 1.0 : 0.5)
    }
}

// MARK: - Preset Button Component
private struct WolPresetButton: View {
    let name: String
    let mac: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            Text(name)
                .font(Typography.captionBold)
                .foregroundStyle(isSelected ? accentColor : Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.tight)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                        .fill(isSelected ? accentColor.opacity(0.14) : Theme.cardBackground(for: colorScheme).opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                        .stroke(isSelected ? accentColor.opacity(0.4) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    NetworkWolCard()
        .padding()
}
