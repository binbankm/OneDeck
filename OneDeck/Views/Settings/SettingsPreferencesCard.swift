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
    @State private var didResetCalibration: Bool = false

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

                // 2. Instrument Sound Cues Toggle Platter
                preferenceToggleTile(
                    icon: "speaker.wave.2.fill",
                    title: L10n.Settings.prefSound,
                    isOn: $appState.isSoundEnabled
                )

                // 3. Keep Screen Awake Toggle Platter
                preferenceToggleTile(
                    icon: "sun.max.fill",
                    title: L10n.Settings.prefKeepAwake,
                    isOn: $appState.isKeepScreenAwake
                )

                // 4. Sensor Power Saving Toggle Platter
                preferenceToggleTile(
                    icon: "leaf.fill",
                    title: L10n.Settings.prefPowerSaving,
                    isOn: $appState.isSensorPowerSaving
                )

                // 5. Reset Sensor Calibration Action Platter
                resetCalibrationRow
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    private var resetCalibrationRow: some View {
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            Image(systemName: "scope")
                .font(IconTheme.tileLeading)
                .foregroundStyle(appState.accentColor)
                .frame(width: 20, height: 20, alignment: .center)

            Text(L10n.Settings.resetCalibration)
                .font(Typography.bodyMedium)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)

            Spacer(minLength: SpacingTheme.standard)

            Button {
                appState.resetSensorCalibration()
                withAnimation(.easeInOut(duration: 0.2)) {
                    didResetCalibration = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        didResetCalibration = false
                    }
                }
            } label: {
                Text(didResetCalibration ? L10n.Settings.resetCalibrationDone : L10n.Settings.resetCalibrationAction)
                    .font(Typography.badgeTag)
                    .foregroundStyle(didResetCalibration ? Color.green : appState.accentColor)
                    .padding(.horizontal, SpacingTheme.row)
                    .padding(.vertical, SpacingTheme.tight)
                    .background((didResetCalibration ? Color.green : appState.accentColor).opacity(0.12))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke((didResetCalibration ? Color.green : appState.accentColor).opacity(0.3), lineWidth: 0.8)
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(L10n.Settings.resetCalibration)
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        )
    }
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
                .accessibilityLabel(title)
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
