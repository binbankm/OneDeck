//
//  TouchMatrixDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Capacitive touch digitizer and multi-touch inspection workspace.
//

import SwiftUI

struct TouchMatrixDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    private let columns = 8
    private let rows = 10

    // MARK: - Body
    var body: some View {
        VStack(spacing: SpacingTheme.standard) {
            // Top Progress HUD
            hudCard

            // Interactive Capacitive Grid
            GeometryReader { geo in
                interactiveMatrixGrid(width: geo.size.width, height: geo.size.height)
            }

            // Bottom Hint
            Text(L10n.Tools.sweepAllCells)
                .font(Typography.badgeTag)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
        .padding(.horizontal, SpacingTheme.cardStack)
        .padding(.vertical, SpacingTheme.standard)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.touchMatrix)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .touchMatrix)
        }
        .onDisappear {
            tools.leaveDetailView()
        }
    }

    // MARK: - Top HUD Card
    @ViewBuilder
    private var hudCard: some View {
        HStack(spacing: SpacingTheme.standard) {
            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(L10n.Tools.matrixCoverage)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                let passed = tools.touchMatrixPassedCount
                let total = columns * rows
                let percent = Int((Double(passed) / Double(total)) * 100.0)

                HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.tight) {
                    Text("\(percent)%")
                        .font(Typography.heroSubValueMono)
                        .foregroundStyle(percent == 100 ? Color.green : appState.accentColor)

                    Text("(\(passed)/\(total))")
                        .font(Typography.badgeTagMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }

            Spacer()

            Button {
                tools.resetTouchMatrix()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                    Text(L10n.Tools.resetTare)
                }
                .font(Typography.caption)
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.compact)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Interactive Matrix Grid
    @ViewBuilder
    private func interactiveMatrixGrid(width: CGFloat, height: CGFloat) -> some View {
        let cellWidth = width / CGFloat(columns)
        let cellHeight = height / CGFloat(rows)

        ZStack {
            VStack(spacing: SpacingTheme.micro) {
                ForEach(0 ..< rows, id: \.self) { r in
                    HStack(spacing: SpacingTheme.micro) {
                        ForEach(0 ..< columns, id: \.self) { c in
                            let index = r * columns + c
                            let isPassed = index < tools.touchMatrixCells.count && tools.touchMatrixCells[index]

                            Rectangle()
                                .fill(isPassed ? Color.green.opacity(0.8) : Theme.cardBackground(for: colorScheme).opacity(0.4))
                                .overlay(
                                    Rectangle()
                                        .stroke(isPassed ? Color.green : Theme.cardBorder(for: colorScheme).opacity(0.5), lineWidth: 0.5)
                                )
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let loc = value.location
                        let c = Int(loc.x / cellWidth)
                        let r = Int(loc.y / cellHeight)
                        if c >= 0 && c < columns && r >= 0 && r < rows {
                            let idx = r * columns + c
                            tools.touchMatrixHit(at: idx)
                        }
                    }
            )
        }
        .frame(width: width, height: height)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        TouchMatrixDetailView()
    }
}
