//
//  AppState.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Global Observable State Hub managing Localization, Appearance & Theme Engine.
//

import SwiftUI
import Observation

// MARK: - Appearance Mode
public enum AppearanceMode: String, CaseIterable, Identifiable {
    case dark = "dark"
    case light = "light"
    case system = "system"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .dark:
            return L10n.Settings.modeDark
        case .light:
            return L10n.Settings.modeLight
        case .system:
            return L10n.Settings.modeSystem
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
        case .overview: return "gauge.with.needle.fill"
        case .battery: return "battery.100.bolt"
        case .network: return "network"
        case .tools: return "wrench.and.screwdriver.fill"
        case .settings: return "slider.horizontal.3"
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
    }

    // MARK: - State Properties
    public var language: AppLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: Keys.language)
        }
    }

    public var appearance: AppearanceMode {
        didSet {
            UserDefaults.standard.set(appearance.rawValue, forKey: Keys.appearance)
        }
    }

    public var themeColorHex: String {
        didSet {
            UserDefaults.standard.set(themeColorHex, forKey: Keys.themeHex)
        }
    }

    public var activeTab: AppTab = .overview

    // MARK: - Computed Helpers
    public var accentColor: Color {
        Color(hex: themeColorHex)
    }

    public var resolvedColorScheme: ColorScheme? {
        switch appearance {
        case .dark:
            return .dark
        case .light:
            return .light
        case .system:
            return nil
        }
    }

    // MARK: - Initialization
    public init() {
        let savedLangRaw = UserDefaults.standard.string(forKey: Keys.language) ?? AppLanguage.system.rawValue
        self.language = AppLanguage(rawValue: savedLangRaw) ?? .system

        let savedAppModeRaw = UserDefaults.standard.string(forKey: Keys.appearance) ?? AppearanceMode.dark.rawValue
        self.appearance = AppearanceMode(rawValue: savedAppModeRaw) ?? .dark

        let savedHex = UserDefaults.standard.string(forKey: Keys.themeHex) ?? ThemePreset.emerald.hex
        self.themeColorHex = savedHex
    }

    // MARK: - Mutators
    public func setThemeHex(_ hex: String) {
        self.themeColorHex = hex
        Haptics.selection()
    }

    public func setAppearance(_ mode: AppearanceMode) {
        self.appearance = mode
        Haptics.selection()
    }

    public func setLanguage(_ lang: AppLanguage) {
        self.language = lang
        Haptics.selection()
    }
}

