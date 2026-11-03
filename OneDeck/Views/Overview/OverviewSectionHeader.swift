//
//  OverviewSectionHeader.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Standardized section header component with icon and title.
//

import SwiftUI

struct OverviewSectionHeader: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared

    // MARK: - Configuration Properties
    let title: String
    let icon: String
    var subtitle: String?
    var accentColor: Color?

    private var activeAccent: Color {
        accentColor ?? appState.accentColor
    }

    // MARK: - Body
    var body: some View {
        HStack(spacing: SpacingTheme.standard) {
            Image(systemName: icon)
                .font(IconTheme.sectionHeader)
                .foregroundStyle(activeAccent)
                .frame(width: 22, height: 22, alignment: .center)

            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(title)
                    .font(Typography.sectionHeader)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                if let subtitle {
                    Text(subtitle)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
            }
        }
    }
}

// MARK: - Typealias & Preview
typealias BentoSectionHeader = OverviewSectionHeader

#Preview {
    OverviewSectionHeader(
        title: "CPU & Engine",
        icon: "cpu.fill",
        subtitle: "Real-time Telemetry"
    )
    .padding()
}
