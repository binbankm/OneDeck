//
//  SettingsAppearanceCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Appearance & Color Palette Card (Obsidian Bento Platter Design System).
//

import SwiftUI

struct SettingsAppearanceCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @State private var customColor: Color = Color(hex: AppState.shared.themeColorHex)

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.appearanceSection, icon: "paintbrush.fill")

            VStack(spacing: SpacingTheme.standard) {
                // 1. Appearance Mode Platter Tile (Strict Order: 跟随系统 -> 浅色 -> 深色)
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    Image(systemName: "circle.lefthalf.filled")
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(appState.accentColor)
                        .frame(width: 20, height: 20, alignment: .center)

                    Text(L10n.Settings.appearanceMode)
                        .font(Typography.bodyValue.weight(.medium))
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)

                    Spacer(minLength: SpacingTheme.standard)

                    Menu {
                        Picker("", selection: $appState.appearance) {
                            ForEach(AppearanceMode.allCases) { mode in
                                Text(mode.displayName).tag(mode)
                            }
                        }
                    } label: {
                        HStack(spacing: SpacingTheme.tight) {
                            Text(appState.appearance.displayName)
                                .font(Typography.bodyValue)
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))

                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        }
                        .padding(.horizontal, SpacingTheme.standard)
                        .padding(.vertical, SpacingTheme.compact)
                        .background(
                            colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.05)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
                    }
                    .onChange(of: appState.appearance) { _, newMode in
                        appState.setAppearance(newMode)
                    }
                }
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.standard)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
                )

                // 2. Custom Color Palette Platter Tile
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    Image(systemName: "paintpalette.fill")
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(appState.accentColor)
                        .frame(width: 20, height: 20, alignment: .center)

                    VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                        Text(L10n.Settings.customPalette)
                            .font(Typography.bodyValue.weight(.medium))
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .lineLimit(1)

                        Text("\(L10n.Settings.hexCode): \(appState.themeColorHex.uppercased())")
                            .font(Typography.captionMono)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    }

                    Spacer(minLength: SpacingTheme.standard)

                    ColorPicker("", selection: $customColor, supportsOpacity: false)
                        .labelsHidden()
                        .onChange(of: customColor) { _, newColor in
                            let hex = newColor.toHex()
                            appState.setThemeHex(hex)
                        }
                }
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.standard)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
                )
            }
        }
        .bentoCard(accent: appState.accentColor)
        .onAppear {
            customColor = Color(hex: appState.themeColorHex)
        }
    }
}
