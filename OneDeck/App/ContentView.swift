//
//  ContentView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Root tab view coordinating the 5 primary application tabs.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.scenePhase) private var scenePhase
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared
    @Bindable private var system = SystemViewModel.shared
    @Bindable private var battery = BatteryViewModel.shared
    @Bindable private var net = NetworkViewModel.shared

    // MARK: - Body
    var body: some View {
        let _ = appState.language
        Group {
            TabView(selection: $appState.activeTab) {
                overviewTab
                batteryTab
                networkTab
                toolsTab
                settingsTab
            }
            .tint(appState.accentColor)
            .preferredColorScheme(appState.resolvedColorScheme)
            .environment(\.locale, appState.resolvedLocale)
        }
        .onAppear {
            guard scenePhase == .active else { return }
            system.refreshDisplaySpecs()
            net.startPathMonitoring()
            activateMonitoring(for: appState.activeTab)
        }
        .onChange(of: appState.language) { _, _ in
            refreshLocalizedModels()
        }
        .onChange(of: appState.activeTab) { oldTab, newTab in
            handleTabChange(from: oldTab, to: newTab)
        }
        .onChange(of: scenePhase) { _, newPhase in
            handleScenePhaseChange(newPhase)
        }
    }

    private func handleTabChange(from oldTab: AppTab, to newTab: AppTab) {
        guard oldTab != newTab else { return }
        Haptics.selection()

        // Halt background polling and hardware telemetry of the inactive tab
        deactivateMonitoring(for: oldTab)

        // Activate telemetry exclusively for the newly selected tab
        guard scenePhase == .active else { return }
        activateMonitoring(for: newTab)
    }

    private func deactivateMonitoring(for tab: AppTab) {
        switch tab {
        case .overview:
            system.stopMonitoring()
        case .battery:
            battery.stopMonitoring()
        case .network:
            net.stopMonitoring()
        case .tools:
            tools.onTabDisappear()
        case .settings:
            break
        }
    }

    private func activateMonitoring(for tab: AppTab) {
        switch tab {
        case .overview:
            system.startMonitoring()
        case .battery:
            battery.startMonitoring()
        case .network:
            net.startMonitoring()
        case .tools:
            tools.onTabAppear()
        case .settings:
            break
        }
    }

    private func refreshLocalizedModels() {
        system.refreshLocalizedStrings()
        battery.refreshLocalizedStrings()
        net.refreshLocalizedStrings()
    }

    private func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .background:
            // High-priority power saving: release idle lock and suspend all background sensors & timers
            UIApplication.shared.isIdleTimerDisabled = false
            tools.onAppBackground()
            system.stopMonitoring()
            battery.stopMonitoring()
            net.stopMonitoring()
            net.stopPathMonitoring()
        case .inactive:
            // Transient interruption (permission prompts, control center, incoming calls)
            break
        case .active:
            // Restore screen sleep preference, re-sync display/locale, and resume only the active tab
            UIApplication.shared.isIdleTimerDisabled = appState.isKeepScreenAwake
            system.refreshDisplaySpecs()
            refreshLocalizedModels()
            net.startPathMonitoring()
            switch appState.activeTab {
            case .overview:
                system.startMonitoring()
            case .battery:
                battery.startMonitoring()
            case .network:
                net.startMonitoring()
            case .tools:
                tools.onAppForeground()
            case .settings:
                break
            }
        @unknown default:
            break
        }
    }

    @ViewBuilder
    private var overviewTab: some View {
        OverviewView()
            .tabItem {
                Label(AppTab.overview.title, systemImage: AppTab.overview.iconName)
            }
            .tag(AppTab.overview)
    }

    @ViewBuilder
    private var batteryTab: some View {
        BatteryView()
            .tabItem {
                Label(AppTab.battery.title, systemImage: AppTab.battery.iconName)
            }
            .tag(AppTab.battery)
    }

    @ViewBuilder
    private var networkTab: some View {
        NetworkView()
            .tabItem {
                Label(AppTab.network.title, systemImage: AppTab.network.iconName)
            }
            .tag(AppTab.network)
    }

    @ViewBuilder
    private var toolsTab: some View {
        ToolsView()
            .tabItem {
                Label(AppTab.tools.title, systemImage: AppTab.tools.iconName)
            }
            .tag(AppTab.tools)
    }

    @ViewBuilder
    private var settingsTab: some View {
        SettingsView()
            .tabItem {
                Label(AppTab.settings.title, systemImage: AppTab.settings.iconName)
            }
            .tag(AppTab.settings)
    }
}

#Preview {
    ContentView()
}
