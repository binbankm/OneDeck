//
//  NetworkWolCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Network Wake-on-LAN (WoL) Magic Packet Transmitter Card.
//

import SwiftUI

struct NetworkWolCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var net = NetworkService.shared
    @Environment(\.colorScheme) private var colorScheme

    @AppStorage("onedeck_last_wol_mac") private var targetMac: String = "00:11:32:8A:2C:1F"
    @State private var feedbackMessage: String?
    @State private var isSuccess: Bool = true
    @FocusState private var isFieldFocused: Bool

    // Quick Presets
    private var presets: [(name: String, mac: String)] {
        [
            (L10n.Network.presetNas, "00:11:32:8A:2C:1F"),
            (L10n.Network.presetWorkstation, "B4:2E:99:4D:10:8A"),
            (L10n.Network.presetMedia, "70:85:C2:55:E1:90")
        ]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            headerRow
            macInputField
            presetsRow
            feedbackBanner
            sendPacketButton
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(appState.accentColor.opacity(0.12))
                    .frame(width: 30, height: 30)

                Image(systemName: "power.circle.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(appState.accentColor)
            }

            Text(L10n.Network.wolTitle)
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Theme.textPrimary(for: colorScheme))

            Spacer()

            Text(L10n.Network.wolPortBadge)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
        }
    }

    // MARK: - MAC Input Field
    @ViewBuilder
    private var macInputField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(L10n.Network.macAddress)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            HStack(spacing: 8) {
                Image(systemName: "number.square")
                    .font(.system(size: 15))
                    .foregroundStyle(appState.accentColor)

                TextField("AA:BB:CC:DD:EE:FF", text: $targetMac)
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .keyboardType(.asciiCapable)
                    .focused($isFieldFocused)
                    .onChange(of: targetMac) { _, newVal in
                        targetMac = newVal.uppercased()
                    }

                if !targetMac.isEmpty {
                    Button {
                        targetMac = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    }
                }

                // Paste Button
                Button {
                    if let clip = UIPasteboard.general.string {
                        targetMac = clip.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                        Haptics.tick()
                    }
                } label: {
                    Image(systemName: "doc.on.clipboard")
                        .font(.system(size: 14))
                        .foregroundStyle(appState.accentColor)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(isFieldFocused ? appState.accentColor : Theme.cardBorder(for: colorScheme), lineWidth: isFieldFocused ? 1.2 : 0.8)
            )
        }
    }

    // MARK: - Quick Presets
    @ViewBuilder
    private var presetsRow: some View {
        HStack(spacing: 8) {
            Text(L10n.Network.presets)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

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

    // MARK: - Feedback Banner
    @ViewBuilder
    private var feedbackBanner: some View {
        if let msg = feedbackMessage {
            HStack(spacing: 6) {
                Image(systemName: isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(isSuccess ? Color.green : Color.red)

                Text(msg)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(isSuccess ? Color.green : Color.red)

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background((isSuccess ? Color.green : Color.red).opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }

    // MARK: - Send Magic Packet Button
    @ViewBuilder
    private var sendPacketButton: some View {
        Button {
            isFieldFocused = false
            let result = net.sendWakeOnLan(macAddress: targetMac)
            withAnimation(.easeInOut(duration: 0.25)) {
                self.isSuccess = result.success
                self.feedbackMessage = result.message
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    if feedbackMessage == result.message {
                        feedbackMessage = nil
                    }
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 13, weight: .bold))

                Text(L10n.Network.sendWol)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
            }
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(appState.accentColor)
            )
            .shadow(color: appState.accentColor.opacity(0.25), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .disabled(targetMac.count < 12)
        .opacity(targetMac.count < 12 ? 0.5 : 1.0)
    }
}

// MARK: - Preset Button (Extracted for Swift type checker speed)
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
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(isSelected ? accentColor : Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(isSelected ? accentColor.opacity(0.14) : Theme.cardBackground(for: colorScheme).opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(isSelected ? accentColor.opacity(0.4) : Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
        }
        .buttonStyle(.plain)
    }
}
