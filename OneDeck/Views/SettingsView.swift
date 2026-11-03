//
//  SettingsView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Settings & Control Hub: Appearance, Language, Preferences, Provisioning, Licenses & About.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    cardStack
                        .padding(.horizontal, SpacingTheme.cardStack)
                        .padding(.vertical, SpacingTheme.rowStandard)
                        .frame(width: geometry.size.width)
                }
                .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            }
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Settings.title)
        }
    }

    // MARK: - 6 Core Modular Cards in Requested Order
    @ViewBuilder
    private var cardStack: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // 1. 外观 (Appearance: 跟随系统/浅色/深色, 调色板, 全部下拉)
            SettingsAppearanceCard()

            // 2. 语言 (Language: 下拉选择)
            SettingsLanguageCard()

            // 3. 偏好设置 (Preferences: 触感, 音效, 屏幕常亮, 传感器节能, 校准归零)
            SettingsPreferencesCard()

            // 4. 签名功能 (Signing & Provisioning: 证书有效期倒计时, 去除系统跳转)
            SettingsSigningCard()

            // 5. 开源协议 (Open Source Licenses: MIT 协议查看器, 原生技术栈)
            SettingsLicensesCard()

            // 6. 关于 (About: 官方三色环图标, 动态版本构建, 架构, GitHub 仓库)
            SettingsAboutCard()
        }
    }
}

#Preview {
    SettingsView()
}
