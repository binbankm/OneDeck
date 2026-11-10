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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var system = SystemViewModel.shared

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: SpacingTheme.cardInternal) {
            physicalMemorySection
            BentoHairlineDivider()
            diskStorageSection
        }
        .bentoCard(accent: appState.accentColor)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var physicalMemorySection: some View {
        let accent = readableAccent

        VStack(alignment: .leading, spacing: SpacingTheme.row) {
            HStack(spacing: SpacingTheme.standard) {
                OverviewSectionHeader(title: L10n.Overview.memory, icon: "memorychip.fill")
                    .layoutPriority(1)

                Spacer(minLength: SpacingTheme.compact)

                Text(system.totalPhysicalMemory.formattedBytes)
                    .font(Typography.bodyValue)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            // Smooth Segmented Memory Capsule (Single Canvas Draw)
            Canvas { context, size in
                let w = size.width
                let h = size.height
                guard w > 0, h > 0 else { return }

                let inactiveColor = colorScheme == .dark ? Color.white.opacity(0.32) : Color.black.opacity(0.24)
                let freeColor = colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08)

                let segments: [(bytes: UInt64, color: Color)] = [
                    (system.activeMemory, accent),
                    (system.wiredMemory, accent.opacity(0.65)),
                    (system.compressedMemory, accent.opacity(0.35)),
                    (system.inactiveMemory, inactiveColor),
                    (system.freeMemory, freeColor)
                ]

                let accounted = segments.reduce(UInt64(0)) { $0 + $1.bytes }
                let total = max(1.0, Double(max(system.totalPhysicalMemory, accounted)))
                let spacing: CGFloat = 2.0
                let nonZeroCount = segments.filter { $0.bytes > 0 }.count
                let totalSpacing = spacing * CGFloat(max(0, nonZeroCount - 1))
                let drawableWidth = max(0.0, w - totalSpacing)

                var currentX: CGFloat = 0.0
                for seg in segments where seg.bytes > 0 {
                    let ratio = CGFloat(Double(seg.bytes) / total)
                    let segWidth = min(max(0.0, w - currentX), drawableWidth * ratio)
                    if segWidth > 0 {
                        context.fill(Path(CGRect(x: currentX, y: 0, width: segWidth, height: h)), with: .color(seg.color))
                        currentX += segWidth + spacing
                    }
                }
                if currentX < w {
                    context.fill(Path(CGRect(x: currentX, y: 0, width: w - currentX, height: h)), with: .color(freeColor))
                }
            }
            .clipShape(Capsule())
            .frame(height: 8)
            .animation(.easeInOut(duration: 0.25), value: system.activeMemory)
            .accessibilityHidden(true)

            // Memory Breakdown Bento Stat Grid
            VStack(spacing: SpacingTheme.standard) {
                let inactiveChipColor = colorScheme == .dark ? Color.white.opacity(0.32) : Color.black.opacity(0.24)

                if dynamicTypeSize.isAccessibilitySize {
                    VStack(spacing: SpacingTheme.standard) {
                        MemoryStatCell(
                            label: L10n.Overview.memoryActive,
                            color: accent,
                            value: system.activeMemory.formattedBytes
                        )
                        MemoryStatCell(
                            label: L10n.Overview.memoryWired,
                            color: accent.opacity(0.65),
                            value: system.wiredMemory.formattedBytes
                        )
                        MemoryStatCell(
                            label: L10n.Overview.memoryCompressed,
                            color: accent.opacity(0.35),
                            value: system.compressedMemory.formattedBytes
                        )
                        MemoryStatCell(
                            label: L10n.Overview.memoryInactive,
                            color: inactiveChipColor,
                            value: system.inactiveMemory.formattedBytes
                        )
                    }
                } else {
                    HStack(spacing: SpacingTheme.row) {
                        MemoryStatCell(
                            label: L10n.Overview.memoryActive,
                            color: accent,
                            value: system.activeMemory.formattedBytes
                        )

                        MemoryStatCell(
                            label: L10n.Overview.memoryWired,
                            color: accent.opacity(0.65),
                            value: system.wiredMemory.formattedBytes
                        )
                    }

                    HStack(spacing: SpacingTheme.row) {
                        MemoryStatCell(
                            label: L10n.Overview.memoryCompressed,
                            color: accent.opacity(0.35),
                            value: system.compressedMemory.formattedBytes
                        )

                        MemoryStatCell(
                            label: L10n.Overview.memoryInactive,
                            color: inactiveChipColor,
                            value: system.inactiveMemory.formattedBytes
                        )
                    }
                }

                HStack(spacing: SpacingTheme.tight) {
                    Circle()
                        .fill(colorScheme == .dark ? Color.white.opacity(0.24) : Color.black.opacity(0.18))
                        .frame(width: 6, height: 6)
                        .accessibilityHidden(true)

                    Text(L10n.Overview.memoryFree)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: SpacingTheme.compact)

                    Text(system.freeMemory.formattedBytes)
                        .font(Typography.bodyValue)
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                        .contentTransition(.numericText())
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.standard)
                .background(Theme.tileBackground(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.5)
                )
                .accessibilityElement(children: .combine)
                .accessibilityLabel(L10n.Overview.memoryFree)
                .accessibilityValue(system.freeMemory.formattedBytes)
            }
            .padding(.top, SpacingTheme.micro)
        }
    }

    @ViewBuilder
    private var diskStorageSection: some View {
        let accent = readableAccent
        let totalDisk = Double(max(1, system.totalDiskSpace))
        let usedDisk = Double(max(0, system.totalDiskSpace - system.availableDiskSpace))

        VStack(alignment: .leading, spacing: SpacingTheme.row) {
            HStack(spacing: SpacingTheme.standard) {
                OverviewSectionHeader(title: L10n.Overview.storage, icon: "internaldrive.fill")
                    .layoutPriority(1)

                Spacer(minLength: SpacingTheme.compact)

                Text(system.totalDiskSpace.formattedBytes)
                    .font(Typography.bodyValue)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            // Storage Progress Bar
            BentoCapsuleProgressBar(
                value: min(1.0, max(0.0, usedDisk / totalDisk)),
                tint: accent,
                height: 8,
                accessibilityLabel: L10n.Overview.storage,
                accessibilityValue: "\(system.usedDiskSpace.formattedBytes) / \(system.totalDiskSpace.formattedBytes)"
            )

            // Used vs Available Metrics
            if dynamicTypeSize.isAccessibilitySize {
                VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                    storageStatRow(
                        label: L10n.Overview.storageUsed,
                        value: system.usedDiskSpace.formattedBytes,
                        alignment: .leading
                    )
                    storageStatRow(
                        label: L10n.Overview.storageAvailable,
                        value: system.availableDiskSpace.formattedBytes,
                        alignment: .leading
                    )
                }
            } else {
                HStack {
                    storageStatRow(
                        label: L10n.Overview.storageUsed,
                        value: system.usedDiskSpace.formattedBytes,
                        alignment: .leading
                    )

                    Spacer(minLength: SpacingTheme.standard)

                    storageStatRow(
                        label: L10n.Overview.storageAvailable,
                        value: system.availableDiskSpace.formattedBytes,
                        alignment: .trailing
                    )
                }
            }

            // Full-Width Tactile Action Button (ViewModel owns haptic triggers)
            Button {
                Task {
                    await system.cleanSystemCache()
                }
            } label: {
                HStack(spacing: SpacingTheme.compact) {
                    if system.isCleaningCache {
                        ProgressView()
                            .controlSize(.small)
                            .tint(accent)

                        Text(L10n.Overview.cleaningCache)
                            .font(Typography.calloutBold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .font(IconTheme.actionButton)
                            .accessibilityHidden(true)

                        Text(L10n.Overview.cleanPurged)
                            .font(Typography.calloutBold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                .padding(.horizontal, SpacingTheme.row)
                .background(accent.opacity(0.12))
                .foregroundStyle(accent)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(accent.opacity(0.25), lineWidth: 0.6)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())
            .disabled(system.isCleaningCache)
            .accessibilityLabel(system.isCleaningCache ? L10n.Overview.cleaningCache : L10n.Overview.cleanPurged)

            if let purgedAt = system.lastCachePurgedAt {
                HStack(spacing: SpacingTheme.tight) {
                    Image(systemName: "sparkles")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(accent)
                        .accessibilityHidden(true)

                    Text(L10n.Overview.cachePurgedToast)
                        .font(Typography.badgeTag)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)

                    Spacer(minLength: SpacingTheme.compact)

                    Text(purgedAt, format: .dateTime.hour().minute().second())
                        .font(Typography.badgeTagMono)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        .lineLimit(1)
                }
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.tight)
                .background(accent.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .transition(.opacity)
                .accessibilityElement(children: .combine)
            }
        }
    }

    @ViewBuilder
    private func storageStatRow(label: String, value: String, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: SpacingTheme.micro) {
            Text(label)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Text(value)
                .font(Typography.bodyValue)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .contentTransition(.numericText())
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(value)
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
                    .accessibilityHidden(true)

                Text(label)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Text(value)
                .font(Typography.bodyValue)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .contentTransition(.numericText())
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, SpacingTheme.row)
        .padding(.vertical, SpacingTheme.standard)
        .background(Theme.tileBackground(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
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
    OverviewMemoryStorageCard()
        .padding()
}
