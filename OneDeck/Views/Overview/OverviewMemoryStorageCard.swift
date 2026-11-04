//
//  OverviewMemoryStorageCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Physical memory distribution and flash storage partition card.
//

import SwiftUI

struct OverviewMemoryStorageCard: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared

    // MARK: - Body
    var body: some View {
        VStack(spacing: SpacingTheme.cardInternal) {
            physicalMemorySection
            Divider().opacity(0.25)
            diskStorageSection
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var physicalMemorySection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.row) {
            HStack {
                OverviewSectionHeader(title: L10n.Overview.memory, icon: "memorychip.fill")

                Spacer()

                Text(system.totalPhysicalMemory.formattedBytes)
                    .font(Typography.bodyValue)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
            }

            // Smooth Segmented Memory Capsule (Single Canvas Draw)
            Canvas { context, size in
                let total = max(1, Double(system.totalPhysicalMemory))
                let w = size.width
                let h = size.height
                let spacing: CGFloat = 2
                let totalSpacing = spacing * 3

                let activeRatio = CGFloat(Double(system.activeMemory) / total)
                let wiredRatio = CGFloat(Double(system.wiredMemory) / total)
                let compRatio = CGFloat(Double(system.compressedMemory) / total)

                let availableW = max(0, w - totalSpacing)
                let activeW = max(2, availableW * activeRatio)
                let wiredW = max(2, availableW * wiredRatio)
                let compW = max(2, availableW * compRatio)

                var currentX: CGFloat = 0

                // 1. Active Memory Segment
                context.fill(Path(CGRect(x: currentX, y: 0, width: activeW, height: h)), with: .color(appState.accentColor))
                currentX += activeW + spacing

                // 2. Wired Memory Segment
                context.fill(Path(CGRect(x: currentX, y: 0, width: wiredW, height: h)), with: .color(appState.accentColor.opacity(0.65)))
                currentX += wiredW + spacing

                // 3. Compressed Memory Segment
                context.fill(Path(CGRect(x: currentX, y: 0, width: compW, height: h)), with: .color(appState.accentColor.opacity(0.35)))
                currentX += compW + spacing

                // 4. Free Memory Segment
                let freeColor = colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08)
                context.fill(Path(CGRect(x: currentX, y: 0, width: max(0, w - currentX), height: h)), with: .color(freeColor))
            }
            .clipShape(Capsule())
            .frame(height: 8)
            .animation(.easeInOut(duration: 0.25), value: system.activeMemory)

            // 2x2 Bento Stat Grid
            VStack(spacing: SpacingTheme.standard) {
                HStack(spacing: SpacingTheme.row) {
                    MemoryStatCell(
                        label: L10n.Overview.memoryActive,
                        color: appState.accentColor,
                        value: system.activeMemory.formattedBytes
                    )

                    MemoryStatCell(
                        label: L10n.Overview.memoryWired,
                        color: appState.accentColor.opacity(0.65),
                        value: system.wiredMemory.formattedBytes
                    )
                }

                HStack(spacing: SpacingTheme.row) {
                    MemoryStatCell(
                        label: L10n.Overview.memoryCompressed,
                        color: appState.accentColor.opacity(0.35),
                        value: system.compressedMemory.formattedBytes
                    )

                    MemoryStatCell(
                        label: L10n.Overview.memoryFree,
                        color: colorScheme == .dark ? Color.white.opacity(0.35) : Color.black.opacity(0.35),
                        value: system.freeMemory.formattedBytes
                    )
                }
            }
            .padding(.top, SpacingTheme.micro)
        }
    }

    @ViewBuilder
    private var diskStorageSection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.row) {
            HStack {
                OverviewSectionHeader(title: L10n.Overview.storage, icon: "internaldrive.fill")

                Spacer()

                Text(system.totalDiskSpace.formattedBytes)
                    .font(Typography.bodyValue)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
            }

            // Storage Native Progress Bar
            let totalDisk = Double(max(1, system.totalDiskSpace))
            let usedDisk = Double(max(0, system.totalDiskSpace - system.availableDiskSpace))
            ProgressView(value: min(1.0, max(0.0, usedDisk / totalDisk)))
                .tint(appState.accentColor)
                .scaleEffect(x: 1, y: 1.6, anchor: .center)
                .frame(height: 8)

            // Used vs Available Metrics
            HStack {
                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    Text(L10n.Overview.storageUsed)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)

                    Text(system.usedDiskSpace.formattedBytes)
                        .font(Typography.bodyValue)
                        .monospacedDigit()
                        .lineLimit(1)
                        .contentTransition(.numericText())
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: SpacingTheme.micro) {
                    Text(L10n.Overview.storageAvailable)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)

                    Text(system.availableDiskSpace.formattedBytes)
                        .font(Typography.bodyValue)
                        .monospacedDigit()
                        .lineLimit(1)
                        .contentTransition(.numericText())
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
            }

            // Full-Width Tactile Action Button
            Button {
                Task {
                    await system.cleanSystemCache()
                }
            } label: {
                HStack(spacing: SpacingTheme.compact) {
                    if system.isCleaningCache {
                        ProgressView()
                            .tint(appState.accentColor)
                            .scaleEffect(0.8)

                        Text(L10n.Overview.cleaningCache)
                            .font(Typography.calloutLabel)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(IconTheme.actionButton)

                        Text(L10n.Overview.cleanPurged)
                            .font(Typography.calloutLabel)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(appState.accentColor.opacity(0.12))
                .foregroundStyle(appState.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(appState.accentColor.opacity(0.25), lineWidth: 0.5)
                )
            }
            .disabled(system.isCleaningCache)
        }
    }
}

// MARK: - Extracted Component
private struct MemoryStatCell: View {
    let label: String
    let color: Color
    let value: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            HStack(spacing: SpacingTheme.tight) {
                Circle()
                    .fill(color)
                    .frame(width: 6, height: 6)

                Text(label)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }

            Text(value)
                .font(Typography.bodyValue)
                .monospacedDigit()
                .lineLimit(1)
                .contentTransition(.numericText())
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
    }
}

// MARK: - Preview
#Preview {
    OverviewMemoryStorageCard()
        .padding()
}
