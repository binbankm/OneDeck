//
//  SettingsLanguageCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Application language switcher and localization selection card.
//

import SwiftUI

// MARK: - SettingsLanguageCard
struct SettingsLanguageCard: View {
    // MARK: - Properties & State
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.languageSection, icon: "character.bubble.fill")

            languageTile
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    private var languageTile: some View {
        let labelContent = HStack(spacing: SpacingTheme.standard) {
            Image(systemName: "globe.asia.australia.fill")
                .font(IconTheme.tileLeading)
                .foregroundStyle(readableAccent)
                .frame(width: 20, height: 20, alignment: .center)
                .accessibilityHidden(true)

            Text(L10n.Settings.languageSelect)
                .font(Typography.bodyMedium)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }

        let menuPicker = Menu {
            Picker("", selection: Binding(
                get: { appState.language },
                set: { appState.setLanguage($0) }
            )) {
                ForEach(AppLanguage.allCases) { lang in
                    Text(lang.displayName).tag(lang)
                }
            }
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Text(appState.language.displayName)
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
        .accessibilityLabel(L10n.Settings.languageSelect)
        .accessibilityValue(appState.language.displayName)

        return Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    labelContent
                    menuPicker
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    labelContent
                    Spacer(minLength: SpacingTheme.standard)
                    menuPicker
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
}

// MARK: - Preview
#Preview {
    SettingsLanguageCard()
}
