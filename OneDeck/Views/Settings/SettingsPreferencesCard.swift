//
//  SettingsPreferencesCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Hardware Diagnostic & Sensor Preferences Card.
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

            // 1. Haptic Feedback Toggle
            preferenceToggleRow(
                icon: "hand.tap.fill",
                title: L10n.Settings.prefHaptics,
                subtitle: L10n.Settings.prefHapticsDesc,
                isOn: $appState.isHapticsEnabled
            )

            Divider().opacity(0.3)

            // 2. Audio Feedback Toggle
            preferenceToggleRow(
                icon: "speaker.wave.2.fill",
                title: L10n.Settings.prefAudio,
                subtitle: L10n.Settings.prefAudioDesc,
                isOn: $appState.isSoundEnabled
            )

            Divider().opacity(0.3)

            // 3. Keep Screen Awake Toggle
            preferenceToggleRow(
                icon: "sun.max.fill",
                title: L10n.Settings.prefKeepAwake,
                subtitle: L10n.Settings.prefKeepAwakeDesc,
                isOn: $appState.isKeepScreenAwake
            )

            Divider().opacity(0.3)

            // 4. Sensor Power Saving Toggle
            preferenceToggleRow(
                icon: "leaf.fill",
                title: L10n.Settings.prefPowerSaving,
                subtitle: L10n.Settings.prefPowerSavingDesc,
                isOn: $appState.isSensorPowerSaving
            )

            Divider().opacity(0.3)

            // 5. Reset Tare Calibration
            Button {
                Haptics.tick()
                showResetAlert = true
            } label: {
                HStack(spacing: SpacingTheme.rowStandard) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(IconTheme.tileLeading)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(appState.accentColor)

                    VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                        Text(L10n.Settings.prefResetTare)
                            .font(Typography.calloutLabel)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))

                        Text(showResetDoneToast ? L10n.Settings.prefResetDone : L10n.Settings.prefResetTareDesc)
                            .font(Typography.caption)
                            .foregroundStyle(showResetDoneToast ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                            .animation(.default, value: showResetDoneToast)
                    }

                    Spacer()

                    Image(systemName: showResetDoneToast ? "checkmark.circle.fill" : "chevron.right")
                        .font(IconTheme.copyIndicator)
                        .foregroundStyle(showResetDoneToast ? appState.accentColor : Theme.textTertiary(for: colorScheme))
                }
                .padding(.vertical, SpacingTheme.tight)
            }
            .buttonStyle(.plain)
        }
        .bentoCard(accent: appState.accentColor)
        .alert(L10n.Settings.prefResetTare, isPresented: $showResetAlert) {
            Button("取消", role: .cancel) { }
            Button("重置", role: .destructive) {
                appState.resetSensorCalibration()
                withAnimation {
                    showResetDoneToast = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
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
    private func preferenceToggleRow(icon: String, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: SpacingTheme.rowStandard) {
            Image(systemName: icon)
                .font(IconTheme.tileLeading)
                .frame(width: 20, height: 20)
                .foregroundStyle(appState.accentColor)

            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(title)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(subtitle)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(appState.accentColor)
        }
        .padding(.vertical, SpacingTheme.tight)
    }
}

