//
//  SettingsPreferencesCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Hardware Diagnostic & Sensor Preferences Card (Obsidian Bento Platter Design System).
//

import SwiftUI

struct SettingsPreferencesCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @State private var showResetAlert = false
    @State private var showResetDoneToast = false

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            BentoSectionHeader(title: L10n.Settings.preferencesSection, icon: "slider.horizontal.3")

            VStack(spacing: SpacingTheme.standard) {
                // 1. Haptic Feedback Toggle Platter
                preferenceToggleTile(
                    icon: "hand.tap.fill",
                    title: L10n.Settings.prefHaptics,
                    subtitle: L10n.Settings.prefHapticsDesc,
                    isOn: $appState.isHapticsEnabled
                )

                // 2. Audio Feedback Toggle Platter
                preferenceToggleTile(
                    icon: "speaker.wave.2.fill",
                    title: L10n.Settings.prefAudio,
                    subtitle: L10n.Settings.prefAudioDesc,
                    isOn: $appState.isSoundEnabled
                )

                // 3. Keep Screen Awake Toggle Platter
                preferenceToggleTile(
                    icon: "sun.max.fill",
                    title: L10n.Settings.prefKeepAwake,
                    subtitle: L10n.Settings.prefKeepAwakeDesc,
                    isOn: $appState.isKeepScreenAwake
                )

                // 4. Sensor Power Saving Toggle Platter
                preferenceToggleTile(
                    icon: "leaf.fill",
                    title: L10n.Settings.prefPowerSaving,
                    subtitle: L10n.Settings.prefPowerSavingDesc,
                    isOn: $appState.isSensorPowerSaving
                )

                // 5. Reset Tare Calibration Platter Action Button
                Button {
                    Haptics.tick()
                    showResetAlert = true
                } label: {
                    HStack(spacing: SpacingTheme.standard) {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(IconTheme.tileLeading)
                            .foregroundStyle(appState.accentColor)
                            .frame(width: 20, height: 20, alignment: .center)

                        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                            Text(L10n.Settings.prefResetTare)
                                .font(Typography.bodyValue.weight(.medium))
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))

                            Text(showResetDoneToast ? L10n.Settings.prefResetDone : L10n.Settings.prefResetTareDesc)
                                .font(Typography.caption)
                                .foregroundStyle(showResetDoneToast ? appState.accentColor : Theme.textTertiary(for: colorScheme))
                                .lineLimit(1)
                        }

                        Spacer(minLength: SpacingTheme.standard)

                        Image(systemName: showResetDoneToast ? "checkmark.circle.fill" : "chevron.right")
                            .font(IconTheme.copyIndicator)
                            .foregroundStyle(showResetDoneToast ? appState.accentColor : Theme.textTertiary(for: colorScheme))
                    }
                    .padding(.horizontal, SpacingTheme.row)
                    .padding(.vertical, SpacingTheme.standard)
                    .background(
                        RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .bentoCard(accent: appState.accentColor)
        .alert(L10n.Settings.prefResetTare, isPresented: $showResetAlert) {
            Button("取消", role: .cancel) { }
            Button("重置", role: .destructive) {
                appState.resetSensorCalibration()
                withAnimation {
                    showResetDoneToast = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showResetDoneToast = false
                    }
                }
            }
        } message: {
            Text(L10n.Settings.prefResetTareDesc)
        }
    }

    // MARK: - Helper Views
    @ViewBuilder
    private func preferenceToggleTile(icon: String, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(alignment: .center, spacing: SpacingTheme.standard) {
            Image(systemName: icon)
                .font(IconTheme.tileLeading)
                .foregroundStyle(appState.accentColor)
                .frame(width: 20, height: 20, alignment: .center)

            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(title)
                    .font(Typography.bodyValue.weight(.medium))
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(subtitle)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
            }

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
