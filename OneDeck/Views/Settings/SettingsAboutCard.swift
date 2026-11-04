//
//  SettingsAboutCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Application version, build metadata, and GitHub repository card.
//

import SwiftUI

// MARK: - SettingsAboutCard
struct SettingsAboutCard: View {
    // MARK: - Properties & State
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    private var system = SystemViewModel.shared

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.aboutSection, icon: "info.circle.fill")

            VStack(spacing: SpacingTheme.standard) {
                appIdentityTile
                hardwareSpecTiles
                repoLinkTile
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    private var appIdentityTile: some View {
        // 1. Clean App Identity Platter Tile
        HStack(spacing: SpacingTheme.rowStandard) {
            appIconView

            HStack(spacing: SpacingTheme.compact) {
                Text(L10n.Settings.appName)
                    .font(Typography.title1)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text("v\(appVersion)")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(appState.accentColor)
                    .padding(.horizontal, SpacingTheme.compact)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(appState.accentColor.opacity(0.12))
                    .clipShape(Capsule())
            }

            Spacer()
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        )
    }

    @ViewBuilder
    private var hardwareSpecTiles: some View {
        // 2. Hardware Environment & Telemetry Specs
        specTile(icon: "iphone.gen3", label: L10n.Settings.aboutDevice, value: system.marketingName)
        specTile(icon: "cpu.fill", label: L10n.Settings.aboutChip, value: system.chipName)
        specTile(
            icon: "apple.terminal.fill",
            label: L10n.Settings.aboutSystem,
            value: "iOS \(UIDevice.current.systemVersion)\(system.osBuildNumber.isEmpty ? "" : " (\(system.osBuildNumber))")"
        )
        specTile(icon: "memorychip.fill", label: L10n.Settings.architecture, value: "arm64e · Metal 3")
        specTile(icon: "hammer.fill", label: L10n.Settings.build, value: "Build \(buildNumber)")
    }

    private var repoLinkTile: some View {
        // 3. Official Repository Link Platter Tile
        Button {
            Haptics.tick()
            if let url = URL(string: "https://github.com/binbankm/OneDeck") {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack(alignment: .center, spacing: SpacingTheme.standard) {
                Image(systemName: "arrow.up.forward.app.fill")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(appState.accentColor)
                    .frame(width: 20, height: 20, alignment: .center)

                Text(L10n.Settings.repoLink)
                    .font(Typography.bodyMedium)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Spacer(minLength: SpacingTheme.standard)

                Image(systemName: "arrow.up.forward")
                    .font(IconTheme.copyIndicator)
                    .foregroundStyle(appState.accentColor)
            }
            .padding(.horizontal, SpacingTheme.row)
            .padding(.vertical, SpacingTheme.standard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - App Icon View (Protected against missing image asset warnings)
    @ViewBuilder
    private var appIconView: some View {
        if let uiImage = UIImage(named: "AppIcon-Display") {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                )
        } else {
            // High-fidelity fallback squircle with accent gradient
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(appState.accentColor.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: "circle.circle.fill")
                    .font(IconTheme.heroAvatar)
                    .foregroundStyle(appState.accentColor)
            }
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
        }
    }

    // MARK: - Spec Tile Helper
    @ViewBuilder
    private func specTile(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            Image(systemName: icon)
                .font(IconTheme.tileLeading)
                .foregroundStyle(appState.accentColor)
                .frame(width: 20, height: 20, alignment: .center)

            Text(label)
                .font(Typography.bodyMedium)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Spacer(minLength: SpacingTheme.standard)

            Text(value)
                .font(Typography.bodyValue)
                .monospacedDigit()
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        )
    }
}

// MARK: - Preview
#Preview {
    SettingsAboutCard()
}
