//
//  HapticLabDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Taptic Engine actuator waveforms and haptic diagnostics workspace.
//

import SwiftUI
import UIKit

struct HapticLabDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - State
    @State private var lastFeedbackName: String = ""
    @State private var dialValue: Double = 50.0
    @State private var selectionGenerator = UISelectionFeedbackGenerator()

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // Impact Styles
    private var impactStyles: [(title: String, style: UIImpactFeedbackGenerator.FeedbackStyle)] {
        [
            (L10n.Tools.lightImpact, .light),
            (L10n.Tools.mediumImpact, .medium),
            (L10n.Tools.heavyImpact, .heavy),
            (L10n.Tools.rigidImpact, .rigid),
            (L10n.Tools.softImpact, .soft)
        ]
    }

    // Notification Styles
    private var notificationStyles: [(title: String, type: UINotificationFeedbackGenerator.FeedbackType)] {
        [
            (L10n.Tools.successPulse, .success),
            (L10n.Tools.warningPulse, .warning),
            (L10n.Tools.errorPulse, .error)
        ]
    }

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                if !tools.isHapticHardwareAvailable {
                    ToolNoticeBanner(
                        icon: "exclamationmark.triangle.fill",
                        message: L10n.Tools.hapticHardwareUnavailable
                    )
                }

                // Hero Motor Visualizer Card
                motorTelemetryHero

                // Section 1: Physical Impact Feedback
                impactFeedbackCard

                // Section 2: Notification Pulses
                notificationFeedbackCard

                // Section 3: Mechanical Selection Dial
                selectionDialCard
            }
            .frame(maxWidth: LayoutTheme.maxContentWidth)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.hapticLab)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .hapticLab)
            selectionGenerator.prepare()
            if lastFeedbackName.isEmpty {
                lastFeedbackName = L10n.Tools.ready
            }
        }
        .onDisappear {
            tools.leaveDetailView()
        }
    }

    // MARK: - Motor Telemetry Hero
    @ViewBuilder
    private var motorTelemetryHero: some View {
        VStack(spacing: SpacingTheme.standard) {
            Image(systemName: "sensor.tag.radiowaves.forward.fill")
                .font(Typography.displayHero)
                .foregroundStyle(accentFg)
                .accessibilityHidden(true)

            Text(L10n.Tools.hapticEngineTitle)
                .font(Typography.heroSubValueMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .multilineTextAlignment(.center)

            Text("\(L10n.Tools.lastTrigger): \(lastFeedbackName)")
                .font(Typography.badgeTagMono)
                .foregroundStyle(accentFg)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.tight)
                .background(accentFg.opacity(0.14))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SpacingTheme.standard)
        .bentoCard(accent: appState.accentColor)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Tools.hapticEngineTitle)
        .accessibilityValue("\(L10n.Tools.lastTrigger): \(lastFeedbackName)")
    }

    // MARK: - 1. Impact Feedback Card
    @ViewBuilder
    private var impactFeedbackCard: some View {
        let minColWidth: CGFloat = dynamicTypeSize.isAccessibilitySize ? 130 : 62
        let columns = [GridItem(.adaptive(minimum: minColWidth), spacing: SpacingTheme.compact)]

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.impactFeedback,
                icon: "hand.point.down.fill",
                subtitle: L10n.Tools.impactFeedbackSub
            )

            LazyVGrid(columns: columns, spacing: SpacingTheme.compact) {
                ForEach(impactStyles, id: \.title) { item in
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: item.style)
                        generator.prepare()
                        generator.impactOccurred()
                        lastFeedbackName = item.title
                    } label: {
                        Text(item.title)
                            .font(Typography.badgeTagMonoMedium)
                            .foregroundStyle(Theme.textPrimary(for: colorScheme))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                            .padding(.horizontal, SpacingTheme.tight)
                            .background(Theme.tileBackground(for: colorScheme))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .accessibilityLabel("\(L10n.Tools.impactFeedback): \(item.title)")
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - 2. Notification Feedback Card
    @ViewBuilder
    private var notificationFeedbackCard: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.compact))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.notificationFeedback,
                icon: "bell.badge.fill",
                subtitle: L10n.Tools.notificationFeedbackSub
            )

            layout {
                ForEach(notificationStyles, id: \.title) { item in
                    let toneColor = notificationColor(for: item.type)

                    Button {
                        let generator = UINotificationFeedbackGenerator()
                        generator.prepare()
                        generator.notificationOccurred(item.type)
                        lastFeedbackName = item.title
                    } label: {
                        HStack(spacing: SpacingTheme.tight) {
                            Image(systemName: notificationIcon(for: item.type))
                                .font(IconTheme.badgeInline)
                                .accessibilityHidden(true)
                            Text(item.title)
                                .font(Typography.captionBold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .foregroundStyle(toneColor)
                        .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                        .padding(.horizontal, SpacingTheme.standard)
                        .background(toneColor.opacity(0.14))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .stroke(toneColor.opacity(0.32), lineWidth: 0.8)
                        )
                        .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .accessibilityLabel("\(L10n.Tools.notificationFeedback): \(item.title)")
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - 3. Mechanical Selection Dial
    @ViewBuilder
    private var selectionDialCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.selectionFeedback,
                icon: "dial.low.fill",
                subtitle: L10n.Tools.selectionFeedbackSub
            )

            VStack(spacing: SpacingTheme.compact) {
                Text("\(Int(dialValue))")
                    .font(Typography.heroSubValueMono)
                    .monospacedDigit()
                    .foregroundStyle(accentFg)

                Slider(value: Binding(
                    get: { dialValue },
                    set: { newVal in
                        if Int(newVal) != Int(dialValue) {
                            selectionGenerator.selectionChanged()
                            selectionGenerator.prepare()
                            lastFeedbackName = L10n.Tools.selectionFeedback
                        }
                        dialValue = newVal
                    }
                ), in: 0 ... 100, step: 1)
                    .tint(accentFg)
                    .padding(.horizontal, SpacingTheme.standard)
                    .accessibilityLabel(L10n.Tools.selectionFeedback)
                    .accessibilityValue("\(Int(dialValue))")
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // Helpers
    private func notificationIcon(for type: UINotificationFeedbackGenerator.FeedbackType) -> String {
        switch type {
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.octagon.fill"
        @unknown default: return "circle.fill"
        }
    }

    private func notificationColor(for type: UINotificationFeedbackGenerator.FeedbackType) -> Color {
        switch type {
        case .success: return Theme.readableGreen(for: colorScheme)
        case .warning: return Theme.readableOrange(for: colorScheme)
        case .error: return Theme.readableRed(for: colorScheme)
        @unknown default: return Theme.textSecondary(for: colorScheme)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        HapticLabDetailView()
    }
}
