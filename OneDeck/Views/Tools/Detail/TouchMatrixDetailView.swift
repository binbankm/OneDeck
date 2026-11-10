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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    private let columns = 8
    private let rows = 10

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: SpacingTheme.standard) {
            // Top Progress HUD
            hudCard
                .frame(maxWidth: LayoutTheme.maxContentWidth)

            // Interactive Capacitive Grid
            GeometryReader { geo in
                interactiveMatrixGrid(width: geo.size.width, height: geo.size.height)
            }
            .frame(maxWidth: LayoutTheme.maxContentWidth)

            // Bottom Hint
            Text(L10n.Tools.sweepAllCells)
                .font(Typography.badgeTag)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: LayoutTheme.maxContentWidth)
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
        let passed = tools.touchMatrixPassedCount
        let total = columns * rows
        let percent = Int((Double(passed) / Double(total)) * 100.0)
        let greenAccent = Theme.readableGreen(for: colorScheme)

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(alignment: .center, spacing: SpacingTheme.standard))

        layout {
            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(L10n.Tools.matrixCoverage)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.tight) {
                    Text("\(percent)%")
                        .font(Typography.heroSubValueMono)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .foregroundStyle(percent == 100 ? greenAccent : accentFg)

                    Text("(\(passed)/\(total))")
                        .font(Typography.badgeTagMono)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Tools.matrixCoverage)
            .accessibilityValue("\(percent)%, \(passed)/\(total)")

            if !dynamicTypeSize.isAccessibilitySize {
                Spacer(minLength: 0)
            }

            Button {
                tools.resetTouchMatrix()
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                    Text(L10n.Tools.resetTare)
                        .font(Typography.captionBold)
                }
                .foregroundStyle(accentFg)
                .padding(.horizontal, SpacingTheme.row)
                .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                .background(accentFg.opacity(0.14))
                .clipShape(Capsule())
                .contentShape(Capsule())
            }
            .buttonStyle(BentoCardButtonStyle())
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Interactive Matrix Grid
    @ViewBuilder
    private func interactiveMatrixGrid(width: CGFloat, height: CGFloat) -> some View {
        let safeWidth = max(1.0, width)
        let safeHeight = max(1.0, height)
        let cellWidth = safeWidth / CGFloat(columns)
        let cellHeight = safeHeight / CGFloat(rows)
        let greenAccent = Theme.readableGreen(for: colorScheme)

        ZStack {
            VStack(spacing: SpacingTheme.micro) {
                ForEach(0 ..< rows, id: \.self) { r in
                    HStack(spacing: SpacingTheme.micro) {
                        ForEach(0 ..< columns, id: \.self) { c in
                            let index = r * columns + c
                            let isPassed = index < tools.touchMatrixCells.count && tools.touchMatrixCells[index]

                            Rectangle()
                                .fill(isPassed ? greenAccent.opacity(0.8) : Theme.tileBackground(for: colorScheme))
                                .overlay(
                                    Rectangle()
                                        .stroke(isPassed ? greenAccent : Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
                                )
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
            )
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let loc = value.location
                        guard loc.x.isFinite, loc.y.isFinite, cellWidth > 0, cellHeight > 0 else { return }
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Tools.touchMatrix)
        .accessibilityValue("\(tools.touchMatrixPassedCount)/\(columns * rows)")
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        TouchMatrixDetailView()
    }
}
