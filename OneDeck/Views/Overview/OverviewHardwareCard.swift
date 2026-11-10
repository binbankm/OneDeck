//
//  OverviewHardwareCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Hardware specifications category switcher and metrics card.
//

import SwiftUI

struct OverviewHardwareCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared

    // MARK: - State
    @State private var selectedCategory: HardwareCategory = .display

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.cardInternal) {
            headerRow
            categorySwitcher
            specDetailsList
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var headerRow: some View {
        OverviewSectionHeader(title: L10n.Overview.hardwareInventory, icon: "list.bullet.clipboard.fill")
    }

    @ViewBuilder
    private var categorySwitcher: some View {
        if dynamicTypeSize.isAccessibilitySize {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: SpacingTheme.compact),
                    GridItem(.flexible(), spacing: SpacingTheme.compact)
                ],
                spacing: SpacingTheme.compact
            ) {
                ForEach(HardwareCategory.allCases) { category in
                    categoryButton(for: category)
                }
            }
        } else {
            HStack(spacing: SpacingTheme.compact) {
                ForEach(HardwareCategory.allCases) { category in
                    categoryButton(for: category)
                }
            }
        }
    }

    @ViewBuilder
    private func categoryButton(for category: HardwareCategory) -> some View {
        let isSelected = (selectedCategory == category)

        Button {
            Haptics.selection()
            withAnimation(.snappy(duration: 0.16, extraBounce: 0)) {
                selectedCategory = category
            }
        } label: {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: category.icon)
                    .font(IconTheme.actionButton)
                    .accessibilityHidden(true)

                Text(category.title)
                    .font(Typography.calloutLabel)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
            .padding(.horizontal, SpacingTheme.tight)
            .background(
                isSelected
                    ? appState.accentColor
                    : Theme.chipBackground(for: colorScheme)
            )
            .foregroundStyle(
                isSelected
                    ? Theme.contrastingForeground(for: appState.accentColor)
                    : Theme.textSecondary(for: colorScheme)
            )
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(
                        isSelected ? Color.clear : Theme.chipBorder(for: colorScheme),
                        lineWidth: 0.5
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
        .accessibilityLabel(category.title)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }

    @ViewBuilder
    private var specDetailsList: some View {
        VStack(spacing: SpacingTheme.standard) {
            switch selectedCategory {
            case .display:
                displaySpecs
            case .soc:
                socSpecs
            case .gpu:
                gpuSpecs
            case .system:
                systemSpecs
            }
        }
        .id(selectedCategory)
        .transition(.opacity)
    }

    // MARK: - Category Sections
    @ViewBuilder
    private var displaySpecs: some View {
        specListRow(
            icon: "rectangle.portrait.arrowtriangle.2.inward",
            label: L10n.Overview.resolution,
            value: system.hardwareSpecs.physicalResolution
        )
        specListRow(
            icon: "bolt.badge.clock.fill",
            label: L10n.Overview.refreshRate,
            value: system.hardwareSpecs.maxRefreshRate,
            isHighlight: system.hardwareSpecs.maxFps >= 120
        )
        specListRow(
            icon: "circle.grid.2x2.fill",
            label: L10n.Overview.ppiScale,
            value: system.hardwareSpecs.ppiAndScale
        )
        specListRow(
            icon: "sparkles.tv.fill",
            label: L10n.Overview.displayTech,
            value: system.hardwareSpecs.displayTechnology
        )
    }

    @ViewBuilder
    private var socSpecs: some View {
        specListRow(
            icon: "atom",
            label: L10n.Overview.processNode,
            value: system.hardwareSpecs.processNode
        )
        specListRow(
            icon: "square.grid.2x2.fill",
            label: L10n.Overview.cpuClusterLabel,
            value: system.hardwareSpecs.cpuCluster
        )
        specListRow(
            icon: "cpu.fill",
            label: L10n.Overview.isaArch,
            value: system.hardwareSpecs.isaArchitecture
        )
        specListRow(
            icon: "brain.head.profile.fill",
            label: L10n.Overview.neuralEngine,
            value: system.hardwareSpecs.neuralEngineDetails
        )
        specListRow(
            icon: "archivebox.fill",
            label: L10n.Overview.cacheSizes,
            value: system.hardwareSpecs.cacheSizes
        )
        specListRow(
            icon: "doc.text.fill",
            label: L10n.Overview.pageSize,
            value: system.hardwareSpecs.pageSize
        )
    }

    @ViewBuilder
    private var gpuSpecs: some View {
        specListRow(
            icon: "gamecontroller.fill",
            label: L10n.Overview.metalRenderer,
            value: system.hardwareSpecs.gpuDeviceName
        )
        specListRow(
            icon: "square.2.layers.3d.fill",
            label: L10n.Overview.gpuCores,
            value: system.hardwareSpecs.gpuCoresDescription
        )
        specListRow(
            icon: "puzzlepiece.extension.fill",
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
            icon: "square.stack.3d.up.fill",
            label: L10n.Overview.meshShading,
            value: system.hardwareSpecs.supportsMeshShaders ? L10n.Overview.msSupported : L10n.Overview.msNotSupported,
            isHighlight: system.hardwareSpecs.supportsMeshShaders
        )
    }

    @ViewBuilder
    private var systemSpecs: some View {
        specListRow(
            icon: "barcode.viewfinder",
            label: L10n.Overview.deviceSerial,
            value: system.serialNumber == "N/A" ? L10n.Overview.sandboxProtected : system.serialNumber
        )
        specListRow(
            icon: "number.circle.fill",
            label: L10n.Overview.modelNumberLabel,
            value: system.modelNumber == "N/A" ? system.machineIdentifier : system.modelNumber
        )
        if system.regulatoryModel != "N/A" {
            specListRow(
                icon: "checkmark.seal.fill",
                label: L10n.Overview.regulatoryModelLabel,
                value: system.regulatoryModel
            )
        }
        specListRow(
            icon: "cpu.fill",
            label: L10n.Overview.boardId,
            value: system.boardId == "N/A" ? "--" : system.boardId
        )
        specListRow(
            icon: "clock.arrow.circlepath",
            label: L10n.Overview.uptime,
            value: system.uptimeFormatted
        )
        specListRow(
            icon: "power.circle.fill",
            label: L10n.Overview.bootTime,
            value: system.bootTimeFormatted
        )
        specListRow(
            icon: system.hardwareSpecs.biometryIconName,
            label: L10n.Overview.biometrics,
            value: system.hardwareSpecs.biometricsType
        )
        specListRow(
            icon: "lock.shield.fill",
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
            icon: "apple.terminal.fill",
            label: L10n.Overview.darwinKernel,
            value: system.hardwareSpecs.darwinKernel
        )
    }

    // MARK: - Spec Row Helper
    @ViewBuilder
    private func specListRow(icon: String, label: String, value: String, isHighlight: Bool = false) -> some View {
        let accent = readableAccent

        Group {
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                    HStack(spacing: SpacingTheme.standard) {
                        Image(systemName: icon)
                            .font(IconTheme.tileLeading)
                            .foregroundStyle(accent)
                            .frame(width: 20, height: 20, alignment: .center)
                            .accessibilityHidden(true)

                        Text(label)
                            .font(Typography.bodyMedium)
                            .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Text(value)
                        .font(Typography.bodyValue)
                        .monospacedDigit()
                        .foregroundStyle(isHighlight ? accent : Theme.textPrimary(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack(alignment: .center, spacing: SpacingTheme.standard) {
                    Image(systemName: icon)
                        .font(IconTheme.tileLeading)
                        .foregroundStyle(accent)
                        .frame(width: 20, height: 20, alignment: .center)
                        .accessibilityHidden(true)

                    Text(label)
                        .font(Typography.bodyMedium)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: SpacingTheme.standard)

                    Text(value)
                        .font(Typography.bodyValue)
                        .monospacedDigit()
                        .foregroundStyle(isHighlight ? accent : Theme.textPrimary(for: colorScheme))
                        .multilineTextAlignment(.trailing)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
            }
        }
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(value)
    }
}

// MARK: - Preview
#Preview {
    OverviewHardwareCard()
        .padding()
}
