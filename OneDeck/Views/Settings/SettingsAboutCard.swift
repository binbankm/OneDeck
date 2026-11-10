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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.openURL) private var openURL
    @Bindable private var appState = AppState.shared
    private var system = SystemViewModel.shared

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

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
        let accent = readableAccent

        return HStack(spacing: SpacingTheme.rowStandard) {
            appIconView
                .accessibilityHidden(true)

            FlowLayout(spacing: SpacingTheme.compact) {
                Text(L10n.Settings.appName)
                    .font(Typography.title1)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text("v\(appVersion)")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(accent)
                    .padding(.horizontal, SpacingTheme.compact)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(accent.opacity(0.12))
                    .clipShape(Capsule())
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Settings.appName)
        .accessibilityValue("v\(appVersion)")
    }

    @ViewBuilder
    private var hardwareSpecTiles: some View {
        specTile(
            icon: UIDevice.current.userInterfaceIdiom == .pad ? "ipad.gen2" : "iphone.gen3",
            label: L10n.Settings.aboutDevice,
            value: system.marketingName
        )
        specTile(icon: "cpu.fill", label: L10n.Settings.aboutChip, value: system.chipName)
        specTile(
            icon: "apple.terminal.fill",
            label: L10n.Settings.aboutSystem,
            value: system.osVersionWithBuild
        )
        specTile(
            icon: "memorychip.fill",
            label: L10n.Settings.architecture,
            value: "\(system.hardwareSpecs.isaArchitecture) · \(system.hardwareSpecs.supportsMeshShaders ? "Metal 3" : "Metal 2")"
        )
        specTile(icon: "hammer.fill", label: L10n.Settings.build, value: L10n.Settings.buildValue(buildNumber))
    }

    private var repoLinkTile: some View {
        let accent = readableAccent

        return Button {
            Haptics.tick()
            if let url = URL(string: "https://github.com/binbankm/OneDeck") {
                openURL(url)
            }
        } label: {
            HStack(alignment: .center, spacing: SpacingTheme.standard) {
                Image(systemName: "arrow.up.forward.app.fill")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(accent)
                    .frame(width: 20, height: 20, alignment: .center)
                    .accessibilityHidden(true)

                Text(L10n.Settings.repoLink)
                    .font(Typography.bodyMedium)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: SpacingTheme.standard)

                Image(systemName: "arrow.up.forward")
                    .font(IconTheme.copyIndicator)
                    .foregroundStyle(accent)
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
            .padding(.horizontal, SpacingTheme.row)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.tileBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityAddTraits(.isLink)
    }

    // MARK: - App Icon View (Protected against missing image asset warnings)
    @ViewBuilder
    private var appIconView: some View {
        let accent = readableAccent

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
            ZStack {
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(accent.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: "circle.circle.fill")
                    .font(IconTheme.heroAvatar)
                    .foregroundStyle(accent)
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
        let accent = readableAccent

        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    HStack(spacing: SpacingTheme.standard) {
                        Image(systemName: icon)
                            .font(IconTheme.tileLeading)
                            .foregroundStyle(accent)
                            .frame(width: 20, height: 20, alignment: .center)
                            .accessibilityHidden(true)

                        Text(label)
                            .font(Typography.bodyMedium)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Text(value)
                        .font(Typography.bodyValue)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    Image(systemName: icon)
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(accent)
                        .frame(width: 20, height: 20, alignment: .center)
                        .accessibilityHidden(true)

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
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(value)
    }
}

// MARK: - Preview
#Preview {
    SettingsAboutCard()
}
