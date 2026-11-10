//
//  WaterEjectorDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Acoustic diaphragm water and dust ejection workspace.
//

import SwiftUI

struct WaterEjectorDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    // Mode Switcher Bar
                    modeSelectorBar

                    Spacer(minLength: SpacingTheme.standard)

                    // Center Acoustic Ring & Countdown (Clean single ring)
                    acousticPulsingRing(size: 200)

                    Spacer(minLength: SpacingTheme.standard)

                    // Instruction & Safety Notice
                    engineeringAdviceCard

                    // Prominent Play / Stop Button
                    actionButton
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .frame(maxWidth: .infinity, minHeight: geo.size.height)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.waterEjector)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .waterEjector)
        }
        .onDisappear {
            tools.stopWaterEjection()
            tools.leaveDetailView()
        }
    }

    // MARK: - Mode Switcher Bar
    @ViewBuilder
    private var modeSelectorBar: some View {
        Picker(L10n.Tools.waterEjectMode, selection: $tools.waterEjector.selectedMode) {
            Text(L10n.Tools.deepEject165).tag(WaterEjectorMode.deep165Hz)
            Text(L10n.Tools.dustClear440).tag(WaterEjectorMode.dustClear440Hz)
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .accessibilityLabel(L10n.Tools.waterEjectMode)
        .disabled(tools.waterEjector.isRunning)
        .onChange(of: tools.waterEjector.selectedMode) { _, _ in
            Haptics.selection()
        }
    }

    // MARK: - Center Acoustic Ring & Countdown (Single Clean Ring)
    @ViewBuilder
    private func acousticPulsingRing(size: CGFloat) -> some View {
        let isRunning = tools.waterEjector.isRunning
        let activeColor = isRunning ? Theme.readableCyan(for: colorScheme) : accentFg
        let safeProgress = tools.waterEjector.progress.isFinite ? min(1.0, max(0.0, tools.waterEjector.progress)) : 0.0
        let statusLabel = isRunning
            ? (tools.waterEjector.selectedMode == .deep165Hz ? L10n.Tools.ejecting : L10n.Tools.clearing)
            : L10n.Tools.ready
        let primaryReadout = isRunning
            ? "\(tools.waterEjector.remainingSeconds)s"
            : "\(Int(tools.waterEjector.selectedMode.targetFrequency)) Hz"

        ZStack {
            // Soft Background Disc strictly inside the circle
            Circle()
                .fill(activeColor.opacity(isRunning ? 0.08 : 0.03))
                .frame(width: size, height: size)

            // Outer Base Track Ring
            Circle()
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 6)
                .frame(width: size, height: size)

            // Active Progress Trim on the Ring
            Circle()
                .trim(from: 0.0, to: CGFloat(safeProgress))
                .stroke(
                    AngularGradient(
                        colors: [activeColor.opacity(0.4), activeColor],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)
                .animation(.linear(duration: 0.1), value: safeProgress)

            // Center Content (Strictly inside the ring)
            VStack(spacing: SpacingTheme.tight) {
                Image(systemName: isRunning ? "drop.degreesign.fill" : "drop.triangle.fill")
                    .font(IconTheme.emptyState)
                    .foregroundStyle(activeColor)
                    .symbolEffect(.pulse, isActive: isRunning)
                    .accessibilityHidden(true)

                if isRunning {
                    Text(primaryReadout)
                        .font(Typography.displayHero)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                } else {
                    Text(primaryReadout)
                        .font(Typography.title1)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }

                Text(statusLabel)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.Tools.waterEjector)
        .accessibilityValue("\(statusLabel), \(primaryReadout)")
    }

    // MARK: - Advice Card
    @ViewBuilder
    private var engineeringAdviceCard: some View {
        HStack(spacing: SpacingTheme.standard) {
            Image(systemName: "speaker.wave.3.fill")
                .font(IconTheme.actionButton)
                .foregroundStyle(accentFg)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                Text(L10n.Tools.waterEjectorSub)
                    .font(Typography.captionBold)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))

                Text(L10n.Tools.waterEjectAdvice)
                    .font(Typography.badgeTag)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, SpacingTheme.rowStandard)
        .padding(.vertical, SpacingTheme.row)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
        .accessibilityElement(children: .combine)
    }

    // MARK: - Prominent Action Button
    @ViewBuilder
    private var actionButton: some View {
        let isRunning = tools.waterEjector.isRunning
        let buttonBg = isRunning ? Theme.readableRed(for: colorScheme) : appState.accentColor

        Button {
            if isRunning {
                Haptics.selection()
            }
            tools.toggleWaterEjector()
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isRunning ? "stop.fill" : "play.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(isRunning ? L10n.Tools.stopEject : L10n.Tools.startEject)
                    .font(Typography.headlineValue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .foregroundStyle(Theme.contrastingForeground(for: buttonBg))
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                    .fill(buttonBg)
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        WaterEjectorDetailView()
    }
}
