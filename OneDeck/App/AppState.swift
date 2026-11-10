//
//  AppState.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Global observable state managing localization, appearance, and preferences.
//

import Observation
import SwiftUI

// MARK: - Appearance Mode
public enum AppearanceMode: String, CaseIterable, Identifiable {
    case system = "system"
    case light = "light"
    case dark = "dark"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .system:
            return L10n.Settings.modeSystem
        case .light:
            return L10n.Settings.modeLight
        case .dark:
            return L10n.Settings.modeDark
        }
    }
}

// MARK: - App Tab Navigation
public enum AppTab: Int, CaseIterable, Identifiable {
    case overview = 0
    case battery = 1
    case network = 2
    case tools = 3
    case settings = 4

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .overview: return L10n.Tabs.overview
        case .battery: return L10n.Tabs.battery
        case .network: return L10n.Tabs.network
        case .tools: return L10n.Tabs.tools
        case .settings: return L10n.Tabs.settings
        }
    }

    public var iconName: String {
        switch self {
        case .overview: return "square.grid.2x2.fill"
        case .battery: return "battery.100.bolt"
        case .network: return "network"
        case .tools: return "wrench.and.screwdriver.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

// MARK: - App State Hub
@Observable
public final class AppState {
    @MainActor public static let shared = AppState()

    // MARK: - User Defaults Keys
    private enum Keys {
        static let language = "onedeck_app_language"
        static let appearance = "onedeck_appearance_mode"
        static let themeHex = "onedeck_theme_hex"
        static let haptics = "onedeck_pref_haptics"
        static let sound = "onedeck_pref_sound"
        static let keepAwake = "onedeck_pref_keep_awake"
        static let sensorPowerSaving = "onedeck_pref_power_saving"
    }

    // MARK: - State Properties
    public var language: AppLanguage {
        didSet {
            guard oldValue != language else { return }
            UserDefaults.standard.set(language.rawValue, forKey: Keys.language)
        }
    }

    public var appearance: AppearanceMode {
        didSet {
            guard oldValue != appearance else { return }
            UserDefaults.standard.set(appearance.rawValue, forKey: Keys.appearance)
        }
    }

    public var themeColorHex: String {
        didSet {
            guard oldValue != themeColorHex else { return }
            UserDefaults.standard.set(themeColorHex, forKey: Keys.themeHex)
        }
    }

    public var isHapticsEnabled: Bool {
        didSet {
            guard oldValue != isHapticsEnabled else { return }
            UserDefaults.standard.set(isHapticsEnabled, forKey: Keys.haptics)
            if isHapticsEnabled { Haptics.selection() }
        }
    }

    public var isSoundEnabled: Bool {
        didSet {
            guard oldValue != isSoundEnabled else { return }
            UserDefaults.standard.set(isSoundEnabled, forKey: Keys.sound)
            Haptics.selection()
        }
    }

    public var isKeepScreenAwake: Bool {
        didSet {
            guard oldValue != isKeepScreenAwake else { return }
            UserDefaults.standard.set(isKeepScreenAwake, forKey: Keys.keepAwake)
            UIApplication.shared.isIdleTimerDisabled = isKeepScreenAwake
            Haptics.selection()
        }
    }

    public var isSensorPowerSaving: Bool {
        didSet {
            guard oldValue != isSensorPowerSaving else { return }
            UserDefaults.standard.set(isSensorPowerSaving, forKey: Keys.sensorPowerSaving)
            Haptics.selection()
            SystemViewModel.shared.applyPowerSavingPreference()
            BatteryViewModel.shared.applyPowerSavingPreference()
            NetworkViewModel.shared.applyPowerSavingPreference()
            ToolsViewModel.shared.applyPowerSavingPreference()
        }
    }

    public var activeTab: AppTab = .overview

    // MARK: - Computed Helpers
    public var accentColor: Color {
        Color(hex: themeColorHex)
    }

    public var resolvedColorScheme: ColorScheme? {
        switch appearance {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    public var resolvedLocale: Locale {
        switch language {
        case .system:
            return .autoupdatingCurrent
        case .zhHans:
            return Locale(identifier: "zh-Hans")
        case .en:
            return Locale(identifier: "en")
        case .zhHant:
            return Locale(identifier: "zh-Hant")
        }
    }

    // MARK: - Initialization
    public init() {
        let savedLangRaw = UserDefaults.standard.string(forKey: Keys.language) ?? AppLanguage.system.rawValue
        self.language = AppLanguage(rawValue: savedLangRaw) ?? .system

        let savedAppModeRaw = UserDefaults.standard.string(forKey: Keys.appearance) ?? AppearanceMode.system.rawValue
        self.appearance = AppearanceMode(rawValue: savedAppModeRaw) ?? .system

        if let savedHex = UserDefaults.standard.string(forKey: Keys.themeHex),
           let normalized = Color.normalizedValidHex(savedHex) {
            self.themeColorHex = normalized
        } else {
            self.themeColorHex = ThemePreset.defaultPreset.hex
        }

        self.isHapticsEnabled = UserDefaults.standard.object(forKey: Keys.haptics) as? Bool ?? true
        self.isSoundEnabled = UserDefaults.standard.object(forKey: Keys.sound) as? Bool ?? true
        self.isKeepScreenAwake = UserDefaults.standard.object(forKey: Keys.keepAwake) as? Bool ?? true
        self.isSensorPowerSaving = UserDefaults.standard.object(forKey: Keys.sensorPowerSaving) as? Bool ?? false

        UIApplication.shared.isIdleTimerDisabled = self.isKeepScreenAwake
    }

    // MARK: - Mutators
    public func setThemeHex(_ hex: String) {
        guard let normalized = Color.normalizedValidHex(hex), normalized != themeColorHex else { return }
        self.themeColorHex = normalized
        Haptics.selection()
    }

    public func setAppearance(_ mode: AppearanceMode) {
        guard appearance != mode else { return }
        self.appearance = mode
        Haptics.selection()
    }

    public func setLanguage(_ lang: AppLanguage) {
        guard language != lang else { return }
        self.language = lang
        Haptics.selection()
    }

    @MainActor
    public func resetSensorCalibration() {
        // Reset spirit level / motion tare bias and runtime tool calibrations
        UserDefaults.standard.removeObject(forKey: "onedeck_level_tare_roll")
        UserDefaults.standard.removeObject(forKey: "onedeck_level_tare_pitch")
        UserDefaults.standard.removeObject(forKey: "onedeck_barometer_altitude_tare")
        ToolsViewModel.shared.resetAllCalibrations(emitHaptic: false)
        Haptics.success()
    }
}
