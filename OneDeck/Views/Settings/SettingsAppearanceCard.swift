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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @State private var customColor: Color = .init(hex: AppState.shared.themeColorHex)
    @State private var hexInputText: String = AppState.shared.themeColorHex
    @State private var isHexInvalid: Bool = false
    @FocusState private var isHexFieldFocused: Bool

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

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
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(L10n.Common.done) {
                    commitHexInput(hexInputText)
                    isHexFieldFocused = false
                }
                .font(Typography.calloutBold)
                .foregroundStyle(readableAccent)
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
        let accent = readableAccent

        let titleContent = HStack(spacing: SpacingTheme.standard) {
            Image(systemName: "circle.lefthalf.filled")
                .font(IconTheme.tileLeading)
                .foregroundStyle(accent)
                .frame(width: 20, height: 20, alignment: .center)
                .accessibilityHidden(true)

            Text(L10n.Settings.appearanceMode)
                .font(Typography.bodyMedium)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }

        let modeMenu = Menu {
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
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Image(systemName: "chevron.up.chevron.down")
                    .font(IconTheme.chevronIndicator)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, SpacingTheme.standard)
            .frame(minHeight: LayoutTheme.minTapTarget - 6)
            .background(Theme.chipBackground(for: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                    .stroke(Theme.chipBorder(for: colorScheme), lineWidth: 0.5)
            )
            .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
            .contentShape(Rectangle())
        }
        .accessibilityLabel(L10n.Settings.appearanceMode)
        .accessibilityValue(appState.appearance.displayName)

        return Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    titleContent
                    modeMenu
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    titleContent
                    Spacer(minLength: SpacingTheme.standard)
                    modeMenu
                }
            }
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.compact)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
    }

    private var themePaletteTile: some View {
        let accent = readableAccent
        let isDefault = appState.themeColorHex.caseInsensitiveCompare(ThemePreset.defaultPreset.hex) == .orderedSame

        return VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            HStack(alignment: .center, spacing: SpacingTheme.standard) {
                Image(systemName: "paintpalette.fill")
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(accent)
                    .frame(width: 20, height: 20, alignment: .center)
                    .accessibilityHidden(true)

                Text(L10n.Settings.customPalette)
                    .font(Typography.bodyMedium)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: SpacingTheme.standard)

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
                            .accessibilityHidden(true)
                        Text(L10n.Common.reset)
                            .font(Typography.badgeTag)
                            .lineLimit(1)
                    }
                    .foregroundStyle(isDefault ? Theme.textTertiary(for: colorScheme) : accent)
                    .padding(.horizontal, SpacingTheme.standard)
                    .frame(minHeight: LayoutTheme.minTapTarget - 12)
                    .background(
                        isDefault
                            ? Theme.chipBackground(for: colorScheme)
                            : accent.opacity(0.12)
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .strokeBorder(
                                isDefault ? Theme.chipBorder(for: colorScheme) : accent.opacity(0.32),
                                lineWidth: 0.8
                            )
                    )
                    .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                    .contentShape(Capsule())
                }
                .buttonStyle(BentoCardButtonStyle())
                .disabled(isDefault)
                .accessibilityLabel("\(L10n.Common.reset) \(L10n.Settings.customPalette)")
            }

            FlowLayout(spacing: SpacingTheme.tight) {
                ForEach(ThemePreset.allPresets) { preset in
                    presetSwatchButton(preset)
                }

                customColorPickerSwatch
            }

            BentoHairlineDivider()

            hexInputRow
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
    }

    private var hexInputRow: some View {
        let accent = readableAccent
        let orange = Theme.readableOrange(for: colorScheme)

        let labelCluster = HStack(spacing: SpacingTheme.standard) {
            Image(systemName: "number.square.fill")
                .font(IconTheme.tileLeading)
                .foregroundStyle(accent)
                .frame(width: 20, height: 20, alignment: .center)
                .accessibilityHidden(true)

            Text(L10n.Settings.hexCode)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }

        let inputField = HStack(spacing: SpacingTheme.compact) {
            if isHexInvalid {
                Text(L10n.Settings.hexInvalidHint)
                    .font(Typography.badgeTag)
                    .foregroundStyle(orange)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            TextField("#00DC82", text: $hexInputText)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .tint(accent)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .focused($isHexFieldFocused)
                .multilineTextAlignment(dynamicTypeSize.isAccessibilitySize ? .leading : .trailing)
                .frame(minWidth: 88, maxWidth: dynamicTypeSize.isAccessibilitySize ? 160 : 108, minHeight: LayoutTheme.minTapTarget - 8)
                .padding(.horizontal, SpacingTheme.standard)
                .background(Theme.chipBackground(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.compact, style: .continuous)
                        .stroke(
                            isHexInvalid
                                ? orange.opacity(0.8)
                                : (isHexFieldFocused ? accent.opacity(0.6) : Theme.chipBorder(for: colorScheme)),
                            lineWidth: isHexFieldFocused || isHexInvalid ? 0.9 : 0.5
                        )
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

        return Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    labelCluster
                    inputField
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    labelCluster
                    Spacer(minLength: SpacingTheme.compact)
                    inputField
                }
            }
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
        if !allHex || strippedHash.count > 8 {
            isHexInvalid = true
            return
        }
        if strippedHash.count == 6 || strippedHash.count == 8 {
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
        let presetTitle = L10n.Settings.accentPresetName(hex: preset.hex)

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
                    .frame(width: 28, height: 28)

                if isSelected {
                    Circle()
                        .strokeBorder(Theme.textPrimary(for: colorScheme), lineWidth: 2)
                        .frame(width: 34, height: 34)

                    Image(systemName: "checkmark")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(Theme.contrastingForeground(for: swatchColor))
                        .accessibilityHidden(true)
                }
            }
            .frame(width: LayoutTheme.minTapTarget, height: LayoutTheme.minTapTarget)
            .contentShape(Circle())
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityLabel(presetTitle)
        .accessibilityValue(preset.hex)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }

    private var customColorPickerSwatch: some View {
        let isCustomSelected = ThemePreset.allPresets.allSatisfy {
            $0.hex.caseInsensitiveCompare(appState.themeColorHex) != .orderedSame
        }

        return ZStack {
            if isCustomSelected {
                Circle()
                    .strokeBorder(Theme.textPrimary(for: colorScheme), lineWidth: 2)
                    .frame(width: 34, height: 34)
            }

            ColorPicker(L10n.Settings.customAccentColor, selection: $customColor, supportsOpacity: false)
                .labelsHidden()
                .frame(width: 28, height: 28)
        }
        .frame(width: LayoutTheme.minTapTarget, height: LayoutTheme.minTapTarget)
        .accessibilityLabel(L10n.Settings.customAccentColor)
        .accessibilityValue(appState.themeColorHex)
        .accessibilityAddTraits(isCustomSelected ? [.isSelected] : [])
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
