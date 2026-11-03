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
        TabView(selection: $appState.activeTab) {
            overviewTab
            batteryTab
            networkTab
            toolsTab
            settingsTab
        }
        .tint(appState.accentColor)
        .preferredColorScheme(appState.resolvedColorScheme)
        .id(appState.language)
        .onChange(of: scenePhase) { _, newPhase in
            handleScenePhaseChange(newPhase)
        }
    }

    private func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .background:
            // High-priority power saving: suspend all background timers, sensors, GPS & pings when app is sent to background
            tools.onAppBackground()
            system.stopMonitoring()
            battery.stopMonitoring()
            net.stopMonitoring()
        case .inactive:
            // Transient interruption (permission dialogues, control center, notifications)
            // Maintain active sensors and views in standby so they resume smoothly
            break
        case .active:
            // Resume only the currently active tab
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
