//
//  SettingsAppearanceCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Appearance & Color Palette Card.
//

import SwiftUI

struct SettingsAppearanceCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @State private var customColor: Color = Color(hex: AppState.shared.themeColorHex)

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.appearanceSection, icon: "paintbrush.fill")

            // 1. Appearance Mode Dropdown Menu (Order: 跟随系统 -> 浅色 -> 深色)
            HStack(spacing: SpacingTheme.rowStandard) {
                Image(systemName: "circle.lefthalf.filled")
                    .font(IconTheme.tileLeading)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(appState.accentColor)

                Text(L10n.Settings.appearanceMode)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Spacer()

                Picker(L10n.Settings.appearanceMode, selection: $appState.appearance) {
                    ForEach(AppearanceMode.allCases) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(.menu)
                .tint(appState.accentColor)
                .onChange(of: appState.appearance) { _, newMode in
                    appState.setAppearance(newMode)
                }
            }
            .padding(.vertical, SpacingTheme.tight)

            Divider().opacity(0.3)

            // 2. Custom Color Palette (Palette Only, Presets Removed)
            HStack(spacing: SpacingTheme.rowStandard) {
                Image(systemName: "paintpalette.fill")
                    .font(IconTheme.tileLeading)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(appState.accentColor)

                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    Text(L10n.Settings.customPalette)
                        .font(Typography.calloutLabel)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))

                    Text("\(L10n.Settings.hexCode): \(appState.themeColorHex.uppercased())")
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }

                Spacer()

                ColorPicker("", selection: $customColor, supportsOpacity: false)
                    .labelsHidden()
                    .onChange(of: customColor) { _, newColor in
                        let hex = newColor.toHex()
                        appState.setThemeHex(hex)
                    }
            }
            .padding(.vertical, SpacingTheme.tight)
        }
        .bentoCard(accent: appState.accentColor)
        .onAppear {
            customColor = Color(hex: appState.themeColorHex)
        }
    }
}

