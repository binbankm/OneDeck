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
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - State
    @State private var isSoftboxFullscreen: Bool = false

    // MARK: - Body
    var body: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // Mode Segmented Control
            modeSelectorBar

            Spacer()

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

            Spacer()

            // Master On/Off Toggle Button
            primaryToggleButton
        }
        .padding(.horizontal, SpacingTheme.cardStack)
        .padding(.vertical, SpacingTheme.rowStandard)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.torchLab)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView()
        }
        .onDisappear {
            tools.leaveDetailView()
            if tools.torch.isTorchOn {
                tools.toggleTorch()
            }
        }
        .fullScreenCover(isPresented: $isSoftboxFullscreen) {
            fullscreenSoftboxCover
        }
    }

    // MARK: - Mode Selector Bar
    @ViewBuilder
    private var modeSelectorBar: some View {
        Picker("", selection: $tools.torch.currentMode) {
            Text(L10n.Tools.dimMode).tag(TorchWorkMode.continuous)
            Text(L10n.Tools.strobe).tag(TorchWorkMode.strobe)
            Text(L10n.Tools.sosMorse).tag(TorchWorkMode.sos)
            Text(L10n.Tools.softbox).tag(TorchWorkMode.softbox)
        }
        .pickerStyle(.segmented)
        .onChange(of: tools.torch.currentMode) { _, newMode in
            tools.setTorchMode(newMode)
        }
    }

    // MARK: - 1. Continuous Linear Dimmer View
    @ViewBuilder
    private var continuousDimmerView: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // Percentage Big Readout
            VStack(spacing: SpacingTheme.micro) {
                Text("\(Int(tools.torch.brightness * 100))%")
                    .font(Typography.displayHero)
                    .foregroundStyle(tools.torch.isTorchOn ? appState.accentColor : Theme.textTertiary(for: colorScheme))

                Text(L10n.Tools.linearLumenRange)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            // High Precision Slider
            Slider(value: Binding(
                get: { Double(tools.torch.brightness) },
                set: { tools.setTorchBrightness(Float($0)) }
            ), in: 0.01 ... 1.0)
                .tint(appState.accentColor)
                .padding(.horizontal, SpacingTheme.rowStandard)

            // Preset Quick Buttons
            HStack(spacing: SpacingTheme.compact) {
                ForEach([0.1, 0.25, 0.5, 0.75, 1.0], id: \.self) { preset in
                    Button {
                        Haptics.tick()
                        tools.setTorchBrightness(Float(preset))
                    } label: {
                        Text("\(Int(preset * 100))%")
                            .font(Typography.badgeTagMonoMedium)
                            .foregroundStyle(abs(Double(tools.torch.brightness) - preset) < 0.05 ? appState.accentColor : Theme.textSecondary(for: colorScheme))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, SpacingTheme.compact)
                            .background(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - 2. Strobe Tachometer View
    @ViewBuilder
    private var strobeTachometerView: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            VStack(spacing: SpacingTheme.micro) {
                Text(String(format: "%.1f Hz", tools.torch.strobeFrequencyHz))
                    .font(Typography.displayHero)
                    .foregroundStyle(appState.accentColor)

                let rpm = Int(tools.torch.strobeFrequencyHz * 60.0)
                Text("\(rpm) RPM · \(L10n.Tools.strobeTachometer)")
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            Slider(value: $tools.torch.strobeFrequencyHz, in: 0.5 ... 30.0, step: 0.5)
                .tint(appState.accentColor)
                .padding(.horizontal, SpacingTheme.rowStandard)
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
                        .foregroundStyle(appState.accentColor)
                }

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
                        .foregroundStyle(appState.accentColor)
                }
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
                    .foregroundStyle(Color.red)

                Text(L10n.Tools.distressSignal)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            Text(L10n.Tools.morseStandardSub)
                .font(Typography.caption)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
        }
    }

    // MARK: - 4. Softbox Setup View
    @ViewBuilder
    private var softboxSetupView: some View {
        VStack(spacing: SpacingTheme.rowStandard) {
            VStack(spacing: SpacingTheme.micro) {
                Text("\(Int(tools.torch.softboxKelvin))K")
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(kelvinColor(tools.torch.softboxKelvin))

                Text(L10n.Tools.correlatedColorTemp)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }

            Slider(value: $tools.torch.softboxKelvin, in: 2700 ... 6500, step: 100)
                .tint(kelvinColor(tools.torch.softboxKelvin))

            Button {
                Haptics.selection()
                isSoftboxFullscreen = true
            } label: {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(IconTheme.actionButton)
                    Text(L10n.Tools.fullscreenSoftbox)
                        .font(Typography.calloutBold)
                }
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(kelvinColor(tools.torch.softboxKelvin))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, SpacingTheme.standard)
    }

    // MARK: - Primary Toggle Button
    @ViewBuilder
    private var primaryToggleButton: some View {
        let isOn = tools.torch.isTorchOn

        Button {
            tools.toggleTorch()
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: isOn ? "flashlight.off.fill" : "flashlight.on.fill")
                    .font(IconTheme.actionButton)
                Text(isOn ? L10n.Tools.turnOff : L10n.Tools.activate)
                    .font(Typography.headlineValue)
            }
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                    .fill(isOn ? Color.orange : appState.accentColor)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Fullscreen Softbox Cover
    @ViewBuilder
    private var fullscreenSoftboxCover: some View {
        ZStack {
            kelvinColor(tools.torch.softboxKelvin).ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button {
                        isSoftboxFullscreen = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(Typography.title1)
                            .foregroundStyle(Color.black.opacity(0.6))
                            .padding()
                    }
                }
                Spacer()
            }
        }
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
