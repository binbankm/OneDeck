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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - State
    @AppStorage("onedeck_last_wol_mac") private var targetMac: String = "00:11:32:8A:2C:1F"
    @State private var feedbackMessage: String?
    @State private var isSuccess: Bool = true
    @State private var feedbackDismissTask: Task<Void, Never>?
    @FocusState private var isFieldFocused: Bool

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

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
        let portBadge = Text(L10n.Network.wolPortBadge)
            .font(Typography.captionMono)
            .foregroundStyle(accentFg)
            .lineLimit(1)
            .padding(.horizontal, SpacingTheme.standard)
            .padding(.vertical, SpacingTheme.micro)
            .background(appState.accentColor.opacity(0.12))
            .clipShape(Capsule())

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                BentoSectionHeader(title: L10n.Network.wolTitle, icon: "power.circle.fill")
                portBadge
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                BentoSectionHeader(title: L10n.Network.wolTitle, icon: "power.circle.fill")
                Spacer(minLength: SpacingTheme.compact)
                portBadge
            }
        }
    }

    // MARK: - MAC Input Field
    @ViewBuilder
    private var macInputField: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
            Text(L10n.Network.macAddress)
                .font(Typography.captionBold)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "number.square.fill")
                    .font(IconTheme.sectionHeader)
                    .foregroundStyle(accentFg)
                    .accessibilityHidden(true)

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
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            if isFieldFocused {
                                Spacer()
                                Button(L10n.Common.done) {
                                    isFieldFocused = false
                                }
                            }
                        }
                    }

                if !targetMac.isEmpty {
                    Button {
                        Haptics.selection()
                        targetMac = ""
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

                // Paste Button
                Button {
                    pasteFromClipboard()
                } label: {
                    Image(systemName: "doc.on.clipboard.fill")
                        .font(IconTheme.actionButton)
                        .foregroundStyle(accentFg)
                        .frame(width: LayoutTheme.minTapTarget, height: LayoutTheme.minTapTarget)
                        .contentShape(Rectangle())
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(L10n.Network.pasteMac)
            }
            .padding(.leading, SpacingTheme.rowStandard)
            .padding(.trailing, SpacingTheme.tight)
            .frame(minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.tileBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(isFieldFocused ? accentFg : Theme.tileBorder(for: colorScheme), lineWidth: isFieldFocused ? 1.2 : 0.8)
            )
        }
    }

    // MARK: - Quick Presets
    @ViewBuilder
    private var presetsRow: some View {
        let scroller = ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: SpacingTheme.compact) {
                ForEach(presets, id: \.mac) { preset in
                    WolPresetButton(
                        name: preset.name,
                        isSelected: targetMac == preset.mac,
                        accentColor: appState.accentColor
                    ) {
                        Haptics.selection()
                        isFieldFocused = false
                        targetMac = preset.mac
                    }
                }
            }
        }

        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                Text(L10n.Network.presets)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                scroller
            }
        } else {
            HStack(spacing: SpacingTheme.standard) {
                Text(L10n.Network.presets)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .layoutPriority(1)
                scroller
            }
        }
    }

    // MARK: - Feedback Banner
    @ViewBuilder
    private var feedbackBanner: some View {
        if let msg = feedbackMessage {
            let bannerColor = isSuccess ? Theme.readableGreen(for: colorScheme) : Theme.readableRed(for: colorScheme)

            HStack(spacing: SpacingTheme.compact) {
                Image(systemName: isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .font(IconTheme.actionButton)
                    .foregroundStyle(bannerColor)
                    .accessibilityHidden(true)

                Text(msg)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(bannerColor)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .fill(bannerColor.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(bannerColor.opacity(0.32), lineWidth: 0.8)
            )
            .accessibilityElement(children: .combine)
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }

    // MARK: - Send Magic Packet Button
    private var isValidMacAddress: Bool {
        targetMac.filter(\.isHexDigit).count == 12
    }

    private func pasteFromClipboard() {
        isFieldFocused = false
        let trimmed = UIPasteboard.general.string?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() ?? ""
        if trimmed.isEmpty {
            Haptics.warning()
            showFeedback(message: L10n.Network.clipboardEmpty, success: false)
        } else {
            targetMac = trimmed
            Haptics.tick()
        }
    }

    private func showFeedback(message: String, success: Bool) {
        withAnimation(.easeInOut(duration: 0.25)) {
            self.isSuccess = success
            self.feedbackMessage = message
        }
        feedbackDismissTask?.cancel()
        feedbackDismissTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(3.0))
            guard !Task.isCancelled else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                if feedbackMessage == message {
                    feedbackMessage = nil
                }
            }
        }
    }

    private func sendMagicPacket() {
        guard isValidMacAddress else { return }
        isFieldFocused = false
        let result = net.sendWakeOnLan(macAddress: targetMac)
        showFeedback(message: result.message, success: result.success)
    }

    @ViewBuilder
    private var sendPacketButton: some View {
        Button {
            sendMagicPacket()
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: "bolt.fill")
                    .font(IconTheme.sectionHeader)
                    .accessibilityHidden(true)

                Text(L10n.Network.sendWol)
                    .font(Typography.sectionHeader)
            }
            .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(appState.accentColor)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .disabled(!isValidMacAddress)
        .opacity(isValidMacAddress ? 1.0 : 0.5)
        .accessibilityLabel(L10n.Network.sendWol)
        .accessibilityValue(isValidMacAddress ? targetMac : L10n.Network.wolInvalidMac)
    }
}

// MARK: - Preset Button Component
private struct WolPresetButton: View {
    let name: String
    let isSelected: Bool
    let accentColor: Color
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let readableAccent = Theme.readableAccent(accentColor, for: colorScheme)

        Button(action: action) {
            Text(name)
                .font(Typography.captionBold)
                .foregroundStyle(isSelected ? readableAccent : Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .padding(.horizontal, SpacingTheme.row)
                .frame(minHeight: LayoutTheme.minTapTarget)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(isSelected ? accentColor.opacity(0.14) : Theme.chipBackground(for: colorScheme))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(isSelected ? readableAccent.opacity(0.45) : Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

// MARK: - Preview
#Preview {
    NetworkWolCard()
        .padding()
}
