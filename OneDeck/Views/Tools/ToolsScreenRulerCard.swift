//
//  ToolsScreenRulerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Screen Caliper Bento Launcher Card - Clean 2-row Bento standard.
//

import SwiftUI

struct ToolsScreenRulerCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationLink(destination: ScreenRulerDetailView()) {
            VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
                headerRow
                middleStatusRow
            }
            .bentoCard(accent: appState.accentColor)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Header
    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.screenRuler,
                icon: "ruler.fill",
                subtitle: L10n.Tools.screenRulerSub
            )

            Spacer()

            Text(String(format: "%.1f %@", tools.caliperCurrentMm, tools.caliperUnit.title))
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .foregroundStyle(appState.accentColor)
                .lineLimit(1)

            Image(systemName: "chevron.right")
                .font(IconTheme.badgeInline)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - Middle Status Row
    @ViewBuilder
    private var middleStatusRow: some View {
        HStack(spacing: SpacingTheme.standard) {
            Text(L10n.Tools.anchorTopJaw)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))

            Spacer()

            Text("1:1 · \(tools.caliperUnit.title)")
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsScreenRulerCard()
        .padding()
}
