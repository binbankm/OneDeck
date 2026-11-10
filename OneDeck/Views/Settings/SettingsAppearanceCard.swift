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
    @State private var hexInputText: String = AppState.shared.themeColorHex
    @State private var isHexInvalid: Bool = false
    @FocusState private var isHexFieldFocused: Bool

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
        .toolbar {
            if isHexFieldFocused {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(L10n.Common.done) {
                        commitHexInput(hexInputText)
                        isHexFieldFocused = false
                    }
                    .font(Typography.calloutBold)
                    .foregroundStyle(appState.accentColor)
                }
            }
        }
        .onChange(of: isHexFieldFocused) { _, focused in
            if !focused {
                commitHexInput(hexInputText)
            }
        }
        .onAppear {
            customColor = Color(hex: appState.themeColorHex)
            hexInputText = appState.themeColorHex
            isHexInvalid = false
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
                Picker("", selection: Binding(
                    get: { appState.appearance },
                    set: { appState.setAppearance($0) }
                )) {
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
            .accessibilityLabel(L10n.Settings.appearanceMode)
            .accessibilityValue(appState.appearance.displayName)
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
                    appState.setThemeHex(ThemePreset.defaultPreset.hex)
                    customColor = Color(hex: ThemePreset.defaultPreset.hex)
                    hexInputText = ThemePreset.defaultPreset.hex
                    isHexInvalid = false
                    isHexFieldFocused = false
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

            Divider().opacity(0.2)

            hexInputRow
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        )
    }

    private var hexInputRow: some View {
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            Image(systemName: "number.square.fill")
                .font(IconTheme.tileLeading)
                .foregroundStyle(appState.accentColor)
                .frame(width: 20, height: 20, alignment: .center)

            Text(L10n.Settings.hexCode)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)

            Spacer(minLength: SpacingTheme.compact)

            if isHexInvalid {
                Text(L10n.Settings.hexInvalidHint)
                    .font(Typography.badgeTag)
                    .foregroundStyle(.orange)
                    .lineLimit(1)
            }

            TextField("#00DC82", text: $hexInputText)
                .font(Typography.captionMono)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .focused($isHexFieldFocused)
                .multilineTextAlignment(.trailing)
                .frame(width: 88)
                .padding(.horizontal, SpacingTheme.compact)
                .padding(.vertical, SpacingTheme.tight)
                .background(colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                        .stroke(isHexInvalid ? Color.orange.opacity(0.7) : Color.clear, lineWidth: 0.8)
                )
                .onChange(of: hexInputText) { _, newValue in
                    applyHexInput(newValue)
                }
                .onSubmit {
                    commitHexInput(hexInputText)
                    isHexFieldFocused = false
                }
                .accessibilityLabel(L10n.Settings.hexCode)
        }
    }

    private func applyHexInput(_ raw: String) {
        let strippedHash = raw
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
        if strippedHash.isEmpty {
            isHexInvalid = false
            return
        }
        let allHex = strippedHash.allSatisfy(\.isHexDigit)
        if !allHex || strippedHash.count > 6 {
            isHexInvalid = true
            return
        }
        if strippedHash.count == 6 {
            let normalized = "#\(strippedHash)"
            isHexInvalid = false
            if appState.themeColorHex.caseInsensitiveCompare(normalized) != .orderedSame {
                appState.setThemeHex(normalized)
                customColor = Color(hex: normalized)
            }
        } else {
            isHexInvalid = false
        }
    }

    private func commitHexInput(_ raw: String) {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            hexInputText = appState.themeColorHex
            isHexInvalid = false
            return
        }
        if let normalized = Color.normalizedValidHex(trimmed) {
            isHexInvalid = false
            hexInputText = normalized
            if appState.themeColorHex.caseInsensitiveCompare(normalized) != .orderedSame {
                appState.setThemeHex(normalized)
                customColor = Color(hex: normalized)
            }
        } else {
            isHexInvalid = true
        }
    }

    @ViewBuilder
    private func presetSwatchButton(_ preset: ThemePreset) -> some View {
        let isSelected = appState.themeColorHex.caseInsensitiveCompare(preset.hex) == .orderedSame
        let swatchColor = Color(hex: preset.hex)

        Button {
            appState.setThemeHex(preset.hex)
            customColor = swatchColor
            hexInputText = preset.hex
            isHexInvalid = false
            isHexFieldFocused = false
        } label: {
            ZStack {
                Circle()
                    .fill(swatchColor)
                    .frame(width: 26, height: 26)

                if isSelected {
                    Circle()
                        .strokeBorder(Theme.textPrimary(for: colorScheme), lineWidth: 2)
                        .frame(width: 32, height: 32)

                    Image(systemName: "checkmark")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(Theme.contrastingForeground(for: swatchColor))
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
            guard hex.caseInsensitiveCompare(appState.themeColorHex) != .orderedSame else { return }
            appState.setThemeHex(hex)
            hexInputText = hex
            isHexInvalid = false
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsAppearanceCard()
}
