//
//  OverviewMemoryStorageCard.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Memory & Storage Bento: Smooth Continuous Segmented Bars, 2x2 Memory Breakdown & Tactile Cleaner.
//

import SwiftUI

struct OverviewMemoryStorageCard: View {
    @Bindable var appState = AppState.shared
    @Bindable var system = SystemService.shared
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: SpacingTheme.cardInternal) {
            // MARK: - 1. Physical Memory (RAM) Section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    OverviewSectionHeader(title: L10n.Overview.memory, icon: "memorychip.fill")

                    Spacer()

                    Text(system.totalPhysicalMemory.formattedBytes)
                        .font(Typography.bodyValue)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                }

                // Smooth Segmented Memory Capsule
                GeometryReader { proxy in
                    let total = max(1, Double(system.totalPhysicalMemory))
                    let w = proxy.size.width
                    let activeW = max(2, CGFloat(Double(system.activeMemory) / total) * w)
                    let wiredW = max(2, CGFloat(Double(system.wiredMemory) / total) * w)
                    let compW = max(2, CGFloat(Double(system.compressedMemory) / total) * w)
                    let usedW = activeW + wiredW + compW
                    let freeW = max(2, w - usedW - 6)

                    HStack(spacing: 2) {
                        Rectangle()
                            .fill(appState.accentColor)
                            .frame(width: activeW)

                        Rectangle()
                            .fill(appState.accentColor.opacity(0.65))
                            .frame(width: wiredW)

                        Rectangle()
                            .fill(appState.accentColor.opacity(0.35))
                            .frame(width: compW)

                        Rectangle()
                            .fill(colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08))
                            .frame(width: freeW)
                    }
                    .clipShape(Capsule())
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: system.activeMemory)
                }
                .frame(height: 8)

                // 2x2 Bento Stat Grid (Rock-Solid Geometry, Zero Line-Breaks)
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
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

                    HStack(spacing: 10) {
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
                .padding(.top, 2)
            }

            Divider().opacity(0.25)

            // MARK: - 2. Disk Storage Section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    OverviewSectionHeader(title: L10n.Overview.storage, icon: "internaldrive.fill")

                    Spacer()

                    Text(system.totalDiskSpace.formattedBytes)
                        .font(Typography.bodyValue)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(1)
                }

                // Storage Segmented Bar
                GeometryReader { proxy in
                    let total = max(1, Double(system.totalDiskSpace))
                    let w = proxy.size.width
                    let used = max(0, Double(system.totalDiskSpace - system.availableDiskSpace))
                    let usedW = min(w - 4, max(2, CGFloat(used / total) * w))
                    let availW = max(2, w - usedW - 2)

                    HStack(spacing: 2) {
                        Rectangle()
                            .fill(appState.accentColor)
                            .frame(width: usedW)

                        Rectangle()
                            .fill(colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08))
                            .frame(width: availW)
                    }
                    .clipShape(Capsule())
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: system.availableDiskSpace)
                }
                .frame(height: 8)

                // Used vs Available Metrics
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
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

                    VStack(alignment: .trailing, spacing: 2) {
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

                // Full-Width Tactile Action Button (Zero Truncation)
                Button {
                    Task {
                        await system.cleanSystemCache()
                    }
                } label: {
                    HStack(spacing: 6) {
                        if system.isCleaningCache {
                            ProgressView()
                                .tint(appState.accentColor)
                                .scaleEffect(0.8)

                            Text(L10n.Overview.cleaningCache)
                                .font(Typography.calloutLabel)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                        } else {
                            Image(systemName: "sparkles")
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
        .bentoCard(accent: appState.accentColor)
    }

// MARK: - Subviews (Extracted Struct to Prevent Type-Checker Bottlenecks)
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
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(colorScheme == .dark ? Color.white.opacity(0.035) : Color.black.opacity(0.025))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
    }
}
}

