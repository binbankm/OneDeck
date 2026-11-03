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
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - State
    @State private var lastFeedbackName: String = ""
    @State private var dialValue: Double = 50.0

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
        GeometryReader { _ in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    // Hero Motor Visualizer Card
                    motorTelemetryHero

                    // Section 1: Physical Impact Feedback
                    impactFeedbackCard

                    // Section 2: Notification Pulses
                    notificationFeedbackCard

                    // Section 3: Mechanical Selection Dial
                    selectionDialCard
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
            }
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.hapticLab)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView()
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
                .foregroundStyle(appState.accentColor)

            Text(L10n.Tools.hapticEngineTitle)
                .font(Typography.heroSubValueMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))

            Text("\(L10n.Tools.lastTrigger): \(lastFeedbackName)")
                .font(Typography.badgeTagMono)
                .foregroundStyle(appState.accentColor)
                .padding(.horizontal, SpacingTheme.standard)
                .padding(.vertical, SpacingTheme.micro)
                .background(appState.accentColor.opacity(0.12))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, SpacingTheme.heroPadding)
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - 1. Impact Feedback Card
    @ViewBuilder
    private var impactFeedbackCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.impactFeedback,
                icon: "hand.point.down.fill",
                subtitle: L10n.Tools.impactFeedbackSub
            )

            HStack(spacing: SpacingTheme.compact) {
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
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, SpacingTheme.standard)
                            .background(Theme.cardBackground(for: colorScheme).opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - 2. Notification Feedback Card
    @ViewBuilder
    private var notificationFeedbackCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.standard) {
            BentoSectionHeader(
                title: L10n.Tools.notificationFeedback,
                icon: "bell.badge.fill",
                subtitle: L10n.Tools.notificationFeedbackSub
            )

            HStack(spacing: SpacingTheme.standard) {
                ForEach(notificationStyles, id: \.title) { item in
                    Button {
                        let generator = UINotificationFeedbackGenerator()
                        generator.prepare()
                        generator.notificationOccurred(item.type)
                        lastFeedbackName = item.title
                    } label: {
                        HStack(spacing: SpacingTheme.tight) {
                            Image(systemName: notificationIcon(for: item.type))
                                .font(IconTheme.badgeInline)
                            Text(item.title)
                                .font(Typography.captionBold)
                        }
                        .foregroundStyle(notificationColor(for: item.type))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, SpacingTheme.rowStandard)
                        .background(notificationColor(for: item.type).opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                .stroke(notificationColor(for: item.type).opacity(0.3), lineWidth: 0.8)
                        )
                    }
                    .buttonStyle(.plain)
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
                    .foregroundStyle(appState.accentColor)

                Slider(value: Binding(
                    get: { dialValue },
                    set: { newVal in
                        if Int(newVal) != Int(dialValue) {
                            let generator = UISelectionFeedbackGenerator()
                            generator.prepare()
                            generator.selectionChanged()
                            lastFeedbackName = L10n.Tools.selectionFeedback
                        }
                        dialValue = newVal
                    }
                ), in: 0 ... 100, step: 1)
                    .tint(appState.accentColor)
                    .padding(.horizontal, SpacingTheme.standard)
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
        case .success: return Color.green
        case .warning: return Color.orange
        case .error: return Color.red
        @unknown default: return Color.gray
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        HapticLabDetailView()
    }
}
