//
//  ToolsView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Tools Tab: Hardware Diagnostic Instruments & Dedicated Professional Workspaces.
//

import SwiftUI

struct ToolsView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    // MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    cardStack
                        .padding(.horizontal, SpacingTheme.cardStack)
                        .padding(.vertical, SpacingTheme.rowStandard)
                        .frame(width: geometry.size.width)
                }
                .scrollBounceBehavior(.basedOnSize, axes: .vertical)
            }
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Tools.title)
            .onAppear {
                tools.onTabAppear()
            }
            .onDisappear {
                tools.onTabDisappear()
            }
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var cardStack: some View {
        VStack(spacing: SpacingTheme.cardStack) {
            // 1. Dual-Axis Spirit Level & Inclinometer
            ToolsSpiritLevelCard()

            // 2. 1:1 Hardware Native Screen Caliper
            ToolsScreenRulerCard()

            // 3. 165Hz Acoustic Membrane Water & Dust Ejector
            ToolsWaterEjectorCard()

            // 4. Precision Torch, Strobe Tachometer & Softbox
            ToolsPrecisionTorchCard()

            // 5. Magnetic Flux & Ferromagnetic Stud / Wire Detector
            ToolsMetalDetectorCard()

            // 6. Atmospheric Barometer & Relative Altimeter / Climb Speed
            ToolsBarometerCard()

            // 7. 20Hz-20kHz Pure Tone Generator & Synth
            ToolsToneGeneratorCard()

            // 8. OLED Dead Pixel Inspection & 120Hz Touch Digitizer
            ToolsScreenQualityCard()

            // 9. Apple Taptic Engine & Haptic Actuator Lab
            ToolsHapticLabCard()

            // 10. Real-Time Acoustic Sound Level & Decibel Meter
            ToolsDecibelMeterCard()

            // 11. 3D Electronic Compass & Geographic True North
            ToolsCompassCard()

            // 12. Stereo Speaker Separation & Acoustic Phase Diagnostics
            ToolsSpeakerLabCard()

            // 13. Fullscreen Capacitive Touch Matrix Grid Test
            ToolsTouchMatrixCard()
        }
    }
}

// MARK: - Preview
#Preview {
    ToolsView()
}
