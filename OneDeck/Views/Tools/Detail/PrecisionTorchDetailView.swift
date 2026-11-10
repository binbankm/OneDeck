//
//  PrecisionTorchDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Micro-brightness torch, strobe tachometer, and softbox workspace.
//

import SwiftUI

struct PrecisionTorchDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.scenePhase) private var scenePhase
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - State
    @State private var isSoftboxFullscreen: Bool = false
    @State private var savedBrightness: CGFloat?

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: SpacingTheme.cardStack) {
                    // Mode Segmented Control
                    modeSelectorBar

                    if !tools.isTorchAvailable && tools.torch.currentMode != .softbox {
                        ToolNoticeBanner(
                            icon: "exclamationmark.triangle.fill",
                            message: L10n.Tools.torchHardwareUnavailable
                        )
                    }

                    Spacer(minLength: SpacingTheme.standard)

                    // Mode-specific Work Area
                    switch tools.torch.currentMode {
                    case .continuous:
                        continuousDimmerView
                    case .strobe:
                        strobeTachometerView
                    case .sos:
                        sosMorseView
                    case .softbox:
                        softboxSetupView
                    }

                    Spacer(minLength: SpacingTheme.standard)

                    // Master On/Off Toggle Button (hidden in Softbox mode which opens fullscreen softbox directly)
                    if tools.torch.currentMode != .softbox {
                        primaryToggleButton
                    }
                }
                .padding(.horizontal, SpacingTheme.cardStack)
                .padding(.vertical, SpacingTheme.rowStandard)
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .frame(maxWidth: .infinity, minHeight: geo.size.height)
            }
            .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        }
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.torchLab)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .torch)
        }
        .onDisappear {
            restoreSoftboxBrightness()
            tools.turnOffTorch()
            tools.leaveDetailView()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard isSoftboxFullscreen else { return }
            if newPhase == .active {
                boostScreenForSoftbox()
            } else {
                restoreSoftboxBrightness()
            }
        }
        .fullScreenCover(isPresented: $isSoftboxFullscreen) {
            fullscreenSoftboxCover
                .onAppear {
                    boostScreenForSoftbox()
                }
                .onDisappear {
                    restoreSoftboxBrightness()
                }
        }
    }

    // MARK: - Mode Selector Bar
    @ViewBuilder
    private var modeSelectorBar: some View {
        Picker(L10n.Tools.torchMode, selection: $tools.torch.currentMode) {
            Text(L10n.Tools.dimMode).tag(TorchWorkMode.continuous)
            Text(L10n.Tools.strobe).tag(TorchWorkMode.strobe)
            Text(L10n.Tools.sosMorse).tag(TorchWorkMode.sos)
            Text(L10n.Tools.softbox).tag(TorchWorkMode.softbox)
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .accessibilityLabel(L10n.Tools.torchMode)
        .onChange(of: tools.torch.currentMode) { _, newMode in
            if newMode == .softbox {
                tools.turnOffTorch()
            }
            tools.setTorchMode(newMode)
        }
    }

    // MARK: - 1. Continuous Linear Dimmer View
    @ViewBuilder
    private var continuousDimmerView: some View {
        let percent = Int((tools.torch.brightness * 100).rounded())
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: SpacingTheme.compact),
            count: dynamicTypeSize.isAccessibilitySize ? 3 : 5
        )

        VStack(spacing: SpacingTheme.cardStack) {
            // Percentage Big Readout
            VStack(spacing: SpacingTheme.micro) {
                Text("\(percent)%")
                    .font(Typography.displayHero)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(tools.torch.isTorchOn ? accentFg : Theme.textTertiary(for: colorScheme))

                Text(L10n.Tools.linearLumenRange)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Tools.linearLumen)
            .accessibilityValue("\(percent)%")

            // High Precision Slider
            Slider(value: Binding(
                get: { Double(tools.torch.brightness) },
                set: { tools.setTorchBrightness(Float($0)) }
            ), in: 0.01 ... 1.0)
                .tint(accentFg)
                .padding(.horizontal, SpacingTheme.rowStandard)
                .accessibilityLabel(L10n.Tools.linearLumen)
                .accessibilityValue("\(percent)%")

            // Preset Quick Buttons
            LazyVGrid(columns: columns, spacing: SpacingTheme.compact) {
                ForEach([0.1, 0.25, 0.5, 0.75, 1.0], id: \.self) { preset in
                    let isSelected = abs(Double(tools.torch.brightness) - preset) < 0.05

                    Button {
                        Haptics.selection()
                        tools.setTorchBrightness(Float(preset))
                    } label: {
                        Text("\(Int(preset * 100))%")
                            .font(Typography.badgeTagMonoMedium)
                            .foregroundStyle(isSelected ? Theme.contrastingForeground(for: appState.accentColor) : Theme.textPrimary(for: colorScheme))
                            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                            .background(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .fill(isSelected ? appState.accentColor : Theme.chipBackground(for: colorScheme))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .stroke(isSelected ? appState.accentColor : Theme.chipBorder(for: colorScheme), lineWidth: 0.8)
                            )
                            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous))
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
    }

    // MARK: - 2. Strobe Tachometer View
    @ViewBuilder
    private var strobeTachometerView: some View {
        let hzText = String(format: "%.1f Hz", tools.torch.strobeFrequencyHz)
        let rpm = Int(tools.torch.strobeFrequencyHz * 60.0)

        VStack(spacing: SpacingTheme.cardStack) {
            VStack(spacing: SpacingTheme.micro) {
                Text(hzText)
                    .font(Typography.displayHero)
                    .monospacedDigit()
                    .contentTransition(.numericText())
                    .foregroundStyle(accentFg)

                Text("\(rpm) RPM · \(L10n.Tools.strobeTachometer)")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Tools.strobeTachometer)
            .accessibilityValue("\(hzText), \(rpm) RPM")

            Slider(value: $tools.torch.strobeFrequencyHz, in: 0.5 ... 30.0, step: 0.5)
                .tint(accentFg)
                .padding(.horizontal, SpacingTheme.rowStandard)
                .accessibilityLabel(L10n.Tools.strobeTachometer)
                .accessibilityValue(hzText)
                .onChange(of: tools.torch.strobeFrequencyHz) { _, val in
                    tools.setStrobeFrequency(val)
                }

            // Quick Hz Steppers
            HStack(spacing: SpacingTheme.row) {
                Button {
                    Haptics.tick()
                    tools.setStrobeFrequency(max(0.5, tools.torch.strobeFrequencyHz - 1.0))
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(Typography.heroSubValue)
                        .foregroundStyle(accentFg)
                        .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                        .contentShape(Circle())
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(L10n.Tools.stepAdjustHz(-1))

                Spacer()

                Text("0.5Hz ~ 30Hz")
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))

                Spacer()

                Button {
                    Haptics.tick()
                    tools.setStrobeFrequency(min(30.0, tools.torch.strobeFrequencyHz + 1.0))
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(Typography.heroSubValue)
                        .foregroundStyle(accentFg)
                        .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                        .contentShape(Circle())
                }
                .buttonStyle(BentoCardButtonStyle())
                .accessibilityLabel(L10n.Tools.stepAdjustHz(1))
            }
            .padding(.horizontal, SpacingTheme.rowStandard)
        }
    }

    // MARK: - 3. SOS Morse Code View
    @ViewBuilder
    private var sosMorseView: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            VStack(spacing: SpacingTheme.tight) {
                Text("··· ——— ···")
                    .font(Typography.displayHero)
                    .foregroundStyle(Theme.readableRed(for: colorScheme))
                    .accessibilityHidden(true)

                Text(L10n.Tools.distressSignal)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            Text(L10n.Tools.morseStandardSub)
                .font(Typography.caption)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .multilineTextAlignment(.center)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(L10n.Tools.sosMorse)
        .accessibilityValue("\(L10n.Tools.distressSignal), \(L10n.Tools.morseStandardSub)")
    }

    // MARK: - 4. Softbox Setup View
    @ViewBuilder
    private var softboxSetupView: some View {
        let kelvin = Int(tools.torch.softboxKelvin)
        let softboxFill = kelvinColor(tools.torch.softboxKelvin)

        VStack(spacing: SpacingTheme.rowStandard) {
            VStack(spacing: SpacingTheme.micro) {
                HStack(spacing: SpacingTheme.compact) {
                    Circle()
                        .fill(softboxFill)
                        .frame(width: 14, height: 14)
                        .overlay(
                            Circle()
                                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 1.0)
                        )
                        .accessibilityHidden(true)

                    Text("\(kelvin)K")
                        .font(Typography.heroSubValueMono)
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }

                Text(L10n.Tools.correlatedColorTemp)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Tools.correlatedColorTemp)
            .accessibilityValue("\(kelvin)K")

            Slider(value: $tools.torch.softboxKelvin, in: 2700 ... 6500, step: 100)
                .tint(accentFg)
                .accessibilityLabel(L10n.Tools.correlatedColorTemp)
                .accessibilityValue("\(kelvin)K")

            Button {
                Haptics.selection()
                isSoftboxFullscreen = true
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)
                    Text(L10n.Tools.fullscreenSoftbox)
                        .font(Typography.calloutBold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                .foregroundStyle(Theme.contrastingForeground(for: softboxFill))
                .frame(maxWidth: .infinity, minHeight: 48)
                .background(softboxFill)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                        .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 1.0)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())
        }
        .padding(.horizontal, SpacingTheme.standard)
    }

    // MARK: - Primary Toggle Button
    @ViewBuilder
    private var primaryToggleButton: some View {
        let isOn = tools.torch.isTorchOn
        let buttonBg = isOn ? Theme.readableOrange(for: colorScheme) : appState.accentColor

        Button {
            tools.toggleTorch()
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isOn ? "flashlight.off.fill" : "flashlight.on.fill")
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)
                Text(isOn ? L10n.Tools.turnOff : L10n.Tools.activate)
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
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }

    // MARK: - Fullscreen Softbox Cover
    @ViewBuilder
    private var fullscreenSoftboxCover: some View {
        let softboxFill = kelvinColor(tools.torch.softboxKelvin)
        let closeFg = Theme.contrastingForeground(for: softboxFill)

        ZStack {
            softboxFill.ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button {
                        Haptics.selection()
                        isSoftboxFullscreen = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(Typography.title1)
                            .foregroundStyle(closeFg.opacity(0.75))
                            .frame(minWidth: LayoutTheme.minTapTarget, minHeight: LayoutTheme.minTapTarget)
                            .contentShape(Circle())
                    }
                    .buttonStyle(BentoCardButtonStyle())
                    .accessibilityLabel(L10n.Tools.closeSoftbox)
                    .padding(SpacingTheme.cardStack)
                }
                Spacer()
            }
        }
        .accessibilityAction(.escape) {
            Haptics.selection()
            isSoftboxFullscreen = false
        }
    }

    private func boostScreenForSoftbox() {
        guard let screen = SystemViewModel.activeDisplayScreen() else { return }
        if savedBrightness == nil {
            savedBrightness = screen.brightness
        }
        screen.brightness = 1.0
    }

    private func restoreSoftboxBrightness() {
        guard let original = savedBrightness else { return }
        if let screen = SystemViewModel.activeDisplayScreen() {
            screen.brightness = original
        }
        savedBrightness = nil
    }

    // MARK: - Kelvin to Color Approximation
    private func kelvinColor(_ kelvin: Double) -> Color {
        if kelvin <= 3200 {
            return Color(red: 1.0, green: 0.78, blue: 0.50) // 2700K~3200K Warm
        } else if kelvin <= 4500 {
            return Color(red: 1.0, green: 0.90, blue: 0.75) // 4000K Neutral Warm
        } else if kelvin <= 5500 {
            return Color(red: 1.0, green: 0.98, blue: 0.95) // 5000K Pure White
        } else {
            return Color(red: 0.85, green: 0.92, blue: 1.0) // 6500K Cool Daylight
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        PrecisionTorchDetailView()
    }
}
