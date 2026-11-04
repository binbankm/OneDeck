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
                themePaletteTile
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
                .font(Typography.bodyMedium)
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

    private var themePaletteTile: some View {
        // 2. Curated theme color swatches & native custom picker platter tile
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack(alignment: .center, spacing: SpacingTheme.standard) {
                Image(systemName: "paintpalette.fill")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(appState.accentColor)
                    .frame(width: 20, height: 20, alignment: .center)

                Text(L10n.Settings.customPalette)
                    .font(Typography.bodyMedium)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)

                Spacer(minLength: SpacingTheme.standard)

                let isDefault = appState.themeColorHex.caseInsensitiveCompare(ThemePreset.defaultPreset.hex) == .orderedSame

                Button {
                    Haptics.selection()
                    appState.setThemeHex(ThemePreset.defaultPreset.hex)
                    customColor = Color(hex: ThemePreset.defaultPreset.hex)
                } label: {
                    HStack(spacing: SpacingTheme.tight) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(IconTheme.badgeInline)
                        Text(L10n.Common.reset)
                            .font(Typography.badgeTag)
                    }
                    .foregroundStyle(isDefault ? Theme.textTertiary(for: colorScheme) : appState.accentColor)
                    .padding(.horizontal, SpacingTheme.standard)
                    .padding(.vertical, SpacingTheme.micro)
                    .background(
                        isDefault
                            ? (colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
                            : appState.accentColor.opacity(0.12)
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .strokeBorder(
                                isDefault ? Color.clear : appState.accentColor.opacity(0.3),
                                lineWidth: 0.8
                            )
                    )
                }
                .buttonStyle(.plain)
                .disabled(isDefault)
            }

            HStack(spacing: 0) {
                ForEach(ThemePreset.allPresets) { preset in
                    presetSwatchButton(preset)
                    Spacer(minLength: 0)
                }

                customColorPickerSwatch
            }
            .padding(.top, SpacingTheme.micro)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        )
    }

    @ViewBuilder
    private func presetSwatchButton(_ preset: ThemePreset) -> some View {
        let isSelected = appState.themeColorHex.caseInsensitiveCompare(preset.hex) == .orderedSame

        Button {
            Haptics.selection()
            appState.setThemeHex(preset.hex)
            customColor = Color(hex: preset.hex)
        } label: {
            ZStack {
                Circle()
                    .fill(Color(hex: preset.hex))
                    .frame(width: 26, height: 26)

                if isSelected {
                    Circle()
                        .strokeBorder(Theme.textPrimary(for: colorScheme), lineWidth: 2)
                        .frame(width: 32, height: 32)

                    Image(systemName: "checkmark")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(Color.white)
                        .shadow(color: Color.black.opacity(0.6), radius: 1, x: 0, y: 1)
                }
            }
            .frame(width: 32, height: 32)
            .contentShape(Circle())
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityLabel(preset.hex)
    }

    private var customColorPickerSwatch: some View {
        let isCustomSelected = ThemePreset.allPresets.allSatisfy {
            $0.hex.caseInsensitiveCompare(appState.themeColorHex) != .orderedSame
        }

        return ZStack {
            if isCustomSelected {
                Circle()
                    .strokeBorder(Theme.textPrimary(for: colorScheme), lineWidth: 2)
                    .frame(width: 32, height: 32)
            }

            ColorPicker("", selection: $customColor, supportsOpacity: false)
                .labelsHidden()
                .frame(width: 28, height: 28)
        }
        .frame(width: 32, height: 32)
        .onChange(of: customColor) { _, newColor in
            let hex = newColor.toHex()
            appState.setThemeHex(hex)
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsAppearanceCard()
}
