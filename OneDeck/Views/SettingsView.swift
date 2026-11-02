//
//  SettingsView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Control Hub managing Appearance, Palette, Language & Deep System Settings.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var appState = AppState.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var customColor: Color = Color(hex: AppState.shared.themeColorHex)
    @State private var hexInput: String = AppState.shared.themeColorHex

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: SpacingTheme.cardStack) {
                    // MARK: - Appearance & Theme Card
                    VStack(alignment: .leading, spacing: 16) {
                        BentoSectionHeader(title: L10n.Settings.appearanceSection, icon: "paintbrush.fill")

                        // Appearance Mode Segmented Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text(L10n.Settings.appearanceMode)
                                .font(Typography.calloutLabel)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))

                            Picker(L10n.Settings.appearanceMode, selection: $appState.appearance) {
                                ForEach(AppearanceMode.allCases) { mode in
                                    Text(mode.displayName).tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: appState.appearance) { _, newMode in
                                appState.setAppearance(newMode)
                            }
                        }

                        Divider().opacity(0.3)

                        // Theme Presets
                        VStack(alignment: .leading, spacing: 10) {
                            Text(L10n.Settings.presets)
                                .font(Typography.calloutLabel)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))

                            HStack(spacing: 12) {
                                ForEach(ThemePreset.allPresets) { preset in
                                    Button {
                                        appState.setThemeHex(preset.hex)
                                        customColor = preset.primaryColor
                                        hexInput = preset.hex
                                    } label: {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [preset.primaryColor, preset.secondaryColor],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 36, height: 36)
                                            .overlay {
                                                if appState.themeColorHex.uppercased() == preset.hex.uppercased() {
                                                    Image(systemName: "checkmark")
                                                        .font(IconTheme.sectionHeader)
                                                        .foregroundStyle(.white)
                                                }
                                            }
                                            .shadow(color: preset.primaryColor.opacity(0.3), radius: 6, y: 2)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        Divider().opacity(0.3)

                        // Custom ColorPicker & Hex Input
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(L10n.Settings.customPalette)
                                    .font(Typography.calloutLabel)
                                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                                Text(L10n.Settings.hexCode + ": \(appState.themeColorHex)")
                                    .font(Typography.captionMono)
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            }

                            Spacer()

                            ColorPicker("", selection: $customColor, supportsOpacity: false)
                                .labelsHidden()
                                .onChange(of: customColor) { _, newColor in
                                    let hex = newColor.toHex()
                                    appState.setThemeHex(hex)
                                    hexInput = hex
                                }
                        }
                    }
                    .bentoCard(accent: appState.accentColor)

                    // MARK: - Language Card
                    VStack(alignment: .leading, spacing: 14) {
                        BentoSectionHeader(title: L10n.Settings.languageSection, icon: "globe")

                        Picker(L10n.Settings.languageSection, selection: $appState.language) {
                            ForEach(AppLanguage.allCases) { lang in
                                Text(lang.displayName).tag(lang)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(appState.accentColor)
                        .onChange(of: appState.language) { _, newLang in
                            appState.setLanguage(newLang)
                        }
                    }
                    .bentoCard(accent: appState.accentColor)

                    // MARK: - 7-Day Certificate Countdown
                    VStack(alignment: .leading, spacing: 12) {
                        BentoSectionHeader(title: L10n.Settings.signingSection, icon: "signature")

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(L10n.Settings.certExpiry)
                                    .font(Typography.calloutLabel)
                                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                                Text(L10n.Settings.certDaysHours(days: 6, hours: 22))
                                    .font(Typography.title2)
                                    .foregroundStyle(appState.accentColor)
                            }
                            Spacer()
                            Image(systemName: "clock.badge.checkmark")
                                .font(IconTheme.prominentAction)
                                .foregroundStyle(appState.accentColor.opacity(0.8))
                        }
                    }
                    .bentoCard(accent: appState.accentColor)

                    // MARK: - System Settings Shortcuts (App-prefs)
                    VStack(alignment: .leading, spacing: 12) {
                        BentoSectionHeader(title: L10n.Settings.sysPrefsSection, icon: "link")

                        VStack(spacing: 8) {
                            settingsLinkRow(title: L10n.Settings.prefWifi, icon: "wifi", url: "App-prefs:root=WIFI")
                            settingsLinkRow(title: L10n.Settings.prefBluetooth, icon: "antenna.radiowaves.left.and.right", url: "App-prefs:root=Bluetooth")
                            settingsLinkRow(title: L10n.Settings.prefBattery, icon: "battery.100", url: "App-prefs:root=BATTERY_USAGE")
                            settingsLinkRow(title: L10n.Settings.prefVpn, icon: "lock.shield", url: "App-prefs:root=General&path=VPN")
                            settingsLinkRow(title: L10n.Settings.prefHotspot, icon: "personalhotspot", url: "App-prefs:root=INTERNET_TETHERING")
                            settingsLinkRow(title: L10n.Settings.prefGeneralUpdate, icon: "arrow.triangle.2.circlepath", url: "App-prefs:root=General&path=SOFTWARE_UPDATE_LINK")
                        }
                    }
                    .bentoCard(accent: appState.accentColor)

                    // MARK: - About Card
                    VStack(alignment: .leading, spacing: 10) {
                        BentoSectionHeader(title: L10n.Settings.aboutSection, icon: "info.circle")

                        HStack {
                            Text(L10n.Settings.version)
                                .font(Typography.calloutLabel)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            Spacer()
                            Text("1.0.0 (Build 1)")
                                .font(Typography.calloutMono)
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        }

                        HStack {
                            Text(L10n.Settings.openSourceRepo)
                                .font(Typography.calloutLabel)
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            Spacer()
                            Text("GitHub / OneDeck")
                                .font(Typography.calloutBold)
                                .foregroundStyle(appState.accentColor)
                        }
                    }
                    .bentoCard(accent: appState.accentColor)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(width: geometry.size.width)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Settings.title)
        }
    }

    @ViewBuilder
    private func settingsLinkRow(title: String, icon: String, url: String) -> some View {
        Button {
            Haptics.tick()
            if let targetURL = URL(string: url) {
                UIApplication.shared.open(targetURL)
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(IconTheme.tileLeading)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(appState.accentColor)
                Text(title)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                Spacer()
                Image(systemName: "arrow.up.forward.app")
                    .font(IconTheme.copyIndicator)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

