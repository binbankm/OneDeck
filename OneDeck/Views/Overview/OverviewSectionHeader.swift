//
//  OverviewSectionHeader.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Reusable Bento Section Header with Tinted Icon Badge and Rounded Typography.
//

import SwiftUI

struct OverviewSectionHeader: View {
    @Bindable var appState = AppState.shared
    @Environment(\.colorScheme) private var colorScheme

    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(appState.accentColor)
                .frame(width: 26, height: 26)
                .background(appState.accentColor.opacity(0.14))
                .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))

            Text(title)
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
    }
}

