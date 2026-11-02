//
//  OverviewHardwareCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Hardware Specifications Bento Card: 4-Segment Switcher & Harmonious Bento Metric Rows.
//

import SwiftUI

struct OverviewHardwareCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var system = SystemService.shared
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedCategory: HardwareCategory = .display

    enum HardwareCategory: Int, CaseIterable, Identifiable {
        case display = 0
        case soc = 1
        case gpu = 2
        case system = 3

        var id: Int { rawValue }

        var title: String {
            switch self {
            case .display: return L10n.Overview.catDisplay
            case .soc: return L10n.Overview.catSoC
            case .gpu: return L10n.Overview.catGPU
            case .system: return L10n.Overview.catSystem
            }
        }

        var icon: String {
            switch self {
            case .display: return "display"
            case .soc: return "cpu"
            case .gpu: return "gamecontroller.fill"
            case .system: return "gearshape.2.fill"
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header Row
            OverviewSectionHeader(title: L10n.Overview.hardwareInventory, icon: "wrench.and.screwdriver.fill")

            // Segmented Category Switcher
            HStack(spacing: 6) {
                ForEach(HardwareCategory.allCases) { category in
                    Button {
                        Haptics.tick()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            selectedCategory = category
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: category.icon)
                                .font(.system(size: 11, weight: .semibold))
                            Text(category.title)
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(
                            selectedCategory == category
                            ? appState.accentColor
                            : (colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.04))
                        )
                        .foregroundStyle(
                            selectedCategory == category
                            ? Color.black
                            : Theme.textSecondary(for: colorScheme)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }

            // Switchable Spec Details List (Structured Bento Rows with Strict 13pt Harmonized Type Hierarchy)
            VStack(spacing: 7) {
                switch selectedCategory {
                case .display:
                    specListRow(
                        icon: "rectangle.portrait.arrowtriangle.2.inward",
                        label: L10n.Overview.resolution,
                        value: system.hardwareSpecs.physicalResolution
                    )
                    specListRow(
                        icon: "bolt.badge.clock",
                        label: L10n.Overview.refreshRate,
                        value: system.hardwareSpecs.maxRefreshRate,
                        isHighlight: system.hardwareSpecs.maxFps >= 120
                    )
                    specListRow(
                        icon: "circle.grid.2x2",
                        label: L10n.Overview.ppiScale,
                        value: system.hardwareSpecs.ppiAndScale
                    )
                    specListRow(
                        icon: "sparkles.tv",
                        label: L10n.Overview.displayTech,
                        value: system.hardwareSpecs.displayTechnology
                    )

                case .soc:
                    specListRow(
                        icon: "atom",
                        label: L10n.Overview.processNode,
                        value: system.hardwareSpecs.processNode
                    )
                    specListRow(
                        icon: "square.grid.2x2",
                        label: L10n.Overview.cpuClusterLabel,
                        value: system.hardwareSpecs.cpuCluster
                    )
                    specListRow(
                        icon: "cpu",
                        label: L10n.Overview.isaArch,
                        value: system.hardwareSpecs.isaArchitecture
                    )
                    specListRow(
                        icon: "brain.head.profile",
                        label: L10n.Overview.neuralEngine,
                        value: system.hardwareSpecs.neuralEngineDetails
                    )
                    specListRow(
                        icon: "archivebox",
                        label: L10n.Overview.cacheSizes,
                        value: system.hardwareSpecs.cacheSizes
                    )
                    specListRow(
                        icon: "doc.text",
                        label: L10n.Overview.pageSize,
                        value: system.hardwareSpecs.pageSize
                    )

                case .gpu:
                    specListRow(
                        icon: "gamecontroller",
                        label: L10n.Overview.metalRenderer,
                        value: system.hardwareSpecs.gpuDeviceName
                    )
                    specListRow(
                        icon: "square.3.layers.3d.down.right",
                        label: L10n.Overview.gpuCores,
                        value: system.hardwareSpecs.gpuCoresDescription
                    )
                    specListRow(
                        icon: "puzzlepiece.extension",
                        label: L10n.Overview.metalFeatureSet,
                        value: system.hardwareSpecs.metalFeatureSet
                    )
                    specListRow(
                        icon: "rays",
                        label: L10n.Overview.raytracing,
                        value: system.hardwareSpecs.supportsRayTracing ? L10n.Overview.rtSupported : L10n.Overview.rtNotSupported,
                        isHighlight: system.hardwareSpecs.supportsRayTracing
                    )
                    specListRow(
                        icon: "square.stack.3d.up",
                        label: L10n.Overview.meshShading,
                        value: system.hardwareSpecs.supportsMeshShaders ? L10n.Overview.msSupported : L10n.Overview.msNotSupported,
                        isHighlight: system.hardwareSpecs.supportsMeshShaders
                    )

                case .system:
                    specListRow(
                        icon: "barcode",
                        label: L10n.Overview.deviceSerial,
                        value: system.serialNumber == "N/A" ? L10n.Overview.sandboxProtected : system.serialNumber
                    )
                    specListRow(
                        icon: "number",
                        label: L10n.Overview.modelNumberLabel,
                        value: system.modelNumber == "N/A" ? system.machineIdentifier : system.modelNumber
                    )
                    if system.regulatoryModel != "N/A" {
                        specListRow(
                            icon: "checkmark.seal",
                            label: L10n.Overview.regulatoryModelLabel,
                            value: system.regulatoryModel
                        )
                    }
                    specListRow(
                        icon: "cpu",
                        label: L10n.Overview.boardId,
                        value: system.boardId == "N/A" ? "--" : system.boardId
                    )
                    specListRow(
                        icon: "clock.arrow.circlepath",
                        label: L10n.Overview.uptime,
                        value: system.uptimeFormatted
                    )
                    specListRow(
                        icon: "power",
                        label: L10n.Overview.bootTime,
                        value: system.bootTimeFormatted
                    )
                    specListRow(
                        icon: system.hardwareSpecs.biometryIconName,
                        label: L10n.Overview.biometrics,
                        value: system.hardwareSpecs.biometricsType
                    )
                    specListRow(
                        icon: "lock.shield",
                        label: L10n.Overview.secureEnclave,
                        value: system.hardwareSpecs.secureEnclave
                    )
                    specListRow(
                        icon: "cable.connector",
                        label: L10n.Overview.usbPortSpeed,
                        value: system.hardwareSpecs.physicalPort
                    )
                    specListRow(
                        icon: "camera.metering.matrix",
                        label: L10n.Overview.lidarScanner,
                        value: system.hardwareSpecs.lidarStatus,
                        isHighlight: system.hardwareSpecs.hasLiDAR
                    )
                    specListRow(
                        icon: "apple.terminal",
                        label: L10n.Overview.darwinKernel,
                        value: system.hardwareSpecs.darwinKernel
                    )
                }
            }
            .animation(.easeInOut(duration: 0.2), value: selectedCategory)
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Harmonious Bento Spec Row (Strict 13pt Baseline, Zero Jumping, Zero Truncation)
    @ViewBuilder
    private func specListRow(icon: String, label: String, value: String, isHighlight: Bool = false) -> some View {
        HStack(alignment: .center, spacing: 8) {
            // Tinted Micro Icon Platter (Matches Card Section Headers)
            ZStack {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(appState.accentColor.opacity(0.12))
                    .frame(width: 24, height: 24)
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(appState.accentColor)
            }

            // Balanced Label: 13pt Medium with Secondary Tone
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Spacer(minLength: 8)

            // Balanced Value: 13pt Semibold Rounded / Monospaced (Strictly Unified 13pt Font, Zero Shrinking, Zero Jumping)
            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(isHighlight ? appState.accentColor : Theme.textPrimary(for: colorScheme))
                .multilineTextAlignment(.trailing)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        )
    }
}
