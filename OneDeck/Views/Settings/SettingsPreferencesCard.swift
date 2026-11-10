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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @State private var didResetCalibration: Bool = false
    @State private var resetFeedbackTask: Task<Void, Never>?

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

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
        .onDisappear {
            resetFeedbackTask?.cancel()
            resetFeedbackTask = nil
        }
    }

    // MARK: - Subviews
    private var resetCalibrationRow: some View {
        let accent = readableAccent
        let green = Theme.readableGreen(for: colorScheme)
        let activeTint = didResetCalibration ? green : accent

        let titleRow = HStack(spacing: SpacingTheme.standard) {
            Image(systemName: "scope")
                .font(IconTheme.tileLeading)
                .foregroundStyle(accent)
                .frame(width: 20, height: 20, alignment: .center)
                .accessibilityHidden(true)

            Text(L10n.Settings.resetCalibration)
                .font(Typography.bodyMedium)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }

        let resetButton = Button {
            appState.resetSensorCalibration()
            withAnimation(.easeInOut(duration: 0.2)) {
                didResetCalibration = true
            }
            resetFeedbackTask?.cancel()
            resetFeedbackTask = Task { @MainActor in
                try? await Task.sleep(for: .seconds(2.0))
                guard !Task.isCancelled else { return }
                withAnimation(.easeInOut(duration: 0.2)) {
                    didResetCalibration = false
                }
            }
        } label: {
            Text(didResetCalibration ? L10n.Settings.resetCalibrationDone : L10n.Settings.resetCalibrationAction)
                .font(Typography.badgeTag)
                .foregroundStyle(activeTint)
                .lineLimit(1)
                .padding(.horizontal, SpacingTheme.row)
                .frame(minHeight: LayoutTheme.minTapTarget - 10)
                .background(activeTint.opacity(0.12))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(activeTint.opacity(0.32), lineWidth: 0.8)
                )
                .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                .contentShape(Capsule())
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityLabel(L10n.Settings.resetCalibration)

        return Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    titleRow
                    resetButton
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    titleRow
                    Spacer(minLength: SpacingTheme.standard)
                    resetButton
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

    @ViewBuilder
    private func preferenceToggleTile(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        let accent = readableAccent

        Toggle(isOn: isOn) {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: icon)
                    .font(IconTheme.tileLeading)
                    .foregroundStyle(accent)
                    .frame(width: 20, height: 20, alignment: .center)
                    .accessibilityHidden(true)

                Text(title)
                    .font(Typography.bodyMedium)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .tint(appState.accentColor)
        .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
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
    SettingsPreferencesCard()
}
