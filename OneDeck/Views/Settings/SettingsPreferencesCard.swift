//
//  SettingsPreferencesCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Haptics, sound effects, and power saving preference card.
//

import SwiftUI

// MARK: - SettingsPreferencesCard
struct SettingsPreferencesCard: View {
    // MARK: - Properties & State
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.preferencesSection, icon: "slider.horizontal.3")

            VStack(spacing: SpacingTheme.standard) {
                // 1. Haptic Feedback Toggle Platter
                preferenceToggleTile(
                    icon: "hand.tap.fill",
                    title: L10n.Settings.prefHaptics,
                    isOn: $appState.isHapticsEnabled
                )

                // 2. Keep Screen Awake Toggle Platter
                preferenceToggleTile(
                    icon: "sun.max.fill",
                    title: L10n.Settings.prefKeepAwake,
                    isOn: $appState.isKeepScreenAwake
                )

                // 3. Sensor Power Saving Toggle Platter
                preferenceToggleTile(
                    icon: "leaf.fill",
                    title: L10n.Settings.prefPowerSaving,
                    isOn: $appState.isSensorPowerSaving
                )
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private func preferenceToggleTile(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            Image(systemName: icon)
                .font(IconTheme.tileLeading)
                .foregroundStyle(appState.accentColor)
                .frame(width: 20, height: 20, alignment: .center)

            Text(title)
                .font(Typography.bodyMedium)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)

            Spacer(minLength: SpacingTheme.standard)

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(appState.accentColor)
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
    SettingsPreferencesCard()
}
