//
//  ContentView.swift
//  OneDeck
//
//  Created by lbyan on 2026/11/1.
//  Root 5-Tab View hosting Overview, Battery, Network, Tools & Settings.
//

import SwiftUI

struct ContentView: View {
    @Bindable var appState = AppState.shared

    var body: some View {
        TabView(selection: $appState.activeTab) {
            OverviewView()
                .tabItem {
                    Label(AppTab.overview.title, systemImage: AppTab.overview.iconName)
                }
                .tag(AppTab.overview)

            BatteryView()
                .tabItem {
                    Label(AppTab.battery.title, systemImage: AppTab.battery.iconName)
                }
                .tag(AppTab.battery)

            NetworkView()
                .tabItem {
                    Label(AppTab.network.title, systemImage: AppTab.network.iconName)
                }
                .tag(AppTab.network)

            ToolsView()
                .tabItem {
                    Label(AppTab.tools.title, systemImage: AppTab.tools.iconName)
                }
                .tag(AppTab.tools)

            SettingsView()
                .tabItem {
                    Label(AppTab.settings.title, systemImage: AppTab.settings.iconName)
                }
                .tag(AppTab.settings)
        }
        .tint(appState.accentColor)
        .preferredColorScheme(appState.resolvedColorScheme)
        .id(appState.language)
    }
}

#Preview {
    ContentView()
}
