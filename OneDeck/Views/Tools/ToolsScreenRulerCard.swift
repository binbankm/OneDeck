//
//  ToolsScreenRulerCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Screen Caliper Bento Launcher Card.
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
                miniRulerPreview
                footerInfoRow
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

    // MARK: - Mini Ruler Preview
    @ViewBuilder
    private var miniRulerPreview: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.5))
                .frame(height: 36)

            // Scaled Ticks
            HStack(spacing: SpacingTheme.compact) {
                ForEach(0..<18) { index in
                    Rectangle()
                        .fill(index % 5 == 0 ? appState.accentColor : Theme.textTertiary(for: colorScheme))
                        .frame(width: 1, height: index % 5 == 0 ? 20 : 10)
                }
            }
            .padding(.horizontal, SpacingTheme.standard)

            // Caliper Jaw Indicators
            HStack {
                Rectangle()
                    .fill(appState.accentColor)
                    .frame(width: 2, height: 32)
                Spacer()
                Rectangle()
                    .fill(appState.accentColor)
                    .frame(width: 2, height: 32)
            }
            .padding(.horizontal, SpacingTheme.modalPadding)
        }
    }

    // MARK: - Footer Info
    @ViewBuilder
    private var footerInfoRow: some View {
        HStack {
            Text(L10n.Tools.anchorTopJaw)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))

            Spacer()

            Text(tools.caliperUnit.title)
                .font(Typography.badgeTagMono)
                .foregroundStyle(appState.accentColor)
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsScreenRulerCard()
        .padding()
}
