//
//  ToolsView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Hardware diagnostic instruments grid and toolkit view.
//

import SwiftUI

struct ToolsView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                cardStack
                    .frame(maxWidth: 680)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, SpacingTheme.cardStack)
                    .padding(.vertical, SpacingTheme.rowStandard)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Tools.title)
            .navigationDestination(for: HardwareTool.self) { tool in
                tool.destinationView
            }
        }
    }

    // MARK: - Cards Stack
    @ViewBuilder
    private var cardStack: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            ForEach(HardwareTool.allCases) { tool in
                ToolLauncherCard(tool: tool)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsView()
}
