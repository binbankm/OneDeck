//
//  SettingsAboutCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  About & Application Build Information Card.
//

import SwiftUI

struct SettingsAboutCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.aboutSection, icon: "info.circle.fill")

            // 1. App Identity Header
            HStack(spacing: SpacingTheme.rowStandard) {
                // Official Option 1 App Icon Thumbnail
                Image("AppIcon-1024", bundle: .main)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 1)
                    )

                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    Text(L10n.Settings.appName)
                        .font(Typography.headlineValue)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Text(L10n.Settings.appSubtitle)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                }

                Spacer()
            }
            .padding(.vertical, SpacingTheme.tight)

            Divider().opacity(0.3)

            // 2. Telemetry Rows
            VStack(spacing: SpacingTheme.standard) {
                row(title: L10n.Settings.version, value: "\(appVersion) (Build \(buildNumber))")
                row(title: L10n.Settings.architecture, value: "arm64 · Metal 3")

                // Open Source Repository Button
                Button {
                    Haptics.tick()
                    if let url = URL(string: "https://github.com/lbyan/OneDeck") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Text(L10n.Settings.openSourceRepo)
                            .font(Typography.calloutLabel)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))

                        Spacer()

                        HStack(spacing: 4) {
                            Text(L10n.Settings.repoLink)
                                .font(Typography.captionMono)
                                .foregroundStyle(appState.accentColor)

                            Image(systemName: "arrow.up.forward.app.fill")
                                .font(IconTheme.copyIndicator)
                                .foregroundStyle(appState.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Helper Views
    @ViewBuilder
    private func row(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(Typography.calloutLabel)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            Spacer()

            Text(value)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
    }
}
