//
//  SettingsAppearanceCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Appearance color scheme and accent palette selection card.
//

import SwiftUI

// MARK: - SettingsAppearanceCard
struct SettingsAppearanceCard: View {
    // MARK: - Properties & State
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @State private var customColor: Color = .init(hex: AppState.shared.themeColorHex)

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.appearanceSection, icon: "paintbrush.fill")

            VStack(spacing: SpacingTheme.standard) {
                appearanceModeRow
                customPaletteRow
            }
        }
        .bentoCard(accent: appState.accentColor)
        .onAppear {
            customColor = Color(hex: appState.themeColorHex)
        }
    }

    // MARK: - Subviews
    private var appearanceModeRow: some View {
        // 1. Appearance mode selector
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            Image(systemName: "circle.lefthalf.filled")
                .font(IconTheme.tileLeading)
                .foregroundStyle(appState.accentColor)
                .frame(width: 20, height: 20, alignment: .center)

            Text(L10n.Settings.appearanceMode)
                .font(Typography.bodyValue.weight(.medium))
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
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
                        .font(IconTheme.chevronIndicator)
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
    }

    private var customPaletteRow: some View {
        // 2. Custom Color Palette Platter Tile
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            Image(systemName: "paintpalette.fill")
                .font(IconTheme.tileLeading)
                .foregroundStyle(appState.accentColor)
                .frame(width: 20, height: 20, alignment: .center)

            Text(L10n.Settings.customPalette)
                .font(Typography.bodyValue.weight(.medium))
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)

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

// MARK: - Preview
#Preview {
    SettingsAppearanceCard()
}
