//
//  GnssHubDetailView.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  GNSS satellite constellation and geodetic coordinate workspace.
//

import SwiftUI
import UIKit

struct GnssHubDetailView: View {
    // MARK: - Dependencies & Environment
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    @State private var copiedDatum: String?
    @State private var copyToastTask: Task<Void, Never>?

    private var accentFg: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                if tools.isGnssLocationDenied {
                    ToolPermissionDeniedBanner(
                        icon: "location.slash.fill",
                        message: L10n.Tools.locationPermissionDenied,
                        onOpenSettings: tools.openAppSettings
                    )
                }

                // Dual KPI Hero Cards
                dualMetricsHero

                // Coordinate Datums Conversion Cards
                coordinateDatumsCard

                // Precision DOP Matrix Card
                dopMatrixCard
            }
            .frame(maxWidth: LayoutTheme.maxContentWidth)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
        .scrollBounceBehavior(.basedOnSize, axes: .vertical)
        .background(Theme.background(for: colorScheme).ignoresSafeArea())
        .navigationTitle(L10n.Tools.gnssHub)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tools.enterDetailView(tool: .gnss)
            tools.startGnssHub()
        }
        .onDisappear {
            copyToastTask?.cancel()
            copyToastTask = nil
            tools.stopGnssHub()
            tools.leaveDetailView()
        }
    }

    // MARK: - Dual Metrics Hero
    @ViewBuilder
    private var dualMetricsHero: some View {
        let fixHeadline = tools.gnssHub.isFixAcquired ? L10n.Tools.gnss3dFix : L10n.Tools.gnssSearching
        let fixColor = tools.gnssHub.isFixAcquired ? Theme.readableGreen(for: colorScheme) : Theme.readableOrange(for: colorScheme)
        let safeSpeed = tools.gnssHub.speedKmh.isFinite ? tools.gnssHub.speedKmh : 0.0
        let speedString = String(format: "%.1f", safeSpeed)
        let safeAlt = tools.gnssHub.altitudeM.isFinite ? tools.gnssHub.altitudeM : 0.0
        let altString = String(format: "%@: %.1f m", L10n.Tools.elevation, safeAlt)

        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: SpacingTheme.standard))
            : AnyLayout(HStackLayout(spacing: SpacingTheme.standard))

        layout {
            // Fix Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.satelliteFixStatus)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(fixHeadline)
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(fixColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(tools.gnssHub.fixStatusText)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.tileBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Tools.satelliteFixStatus)
            .accessibilityValue("\(fixHeadline), \(tools.gnssHub.fixStatusText)")

            // Speed & Elevation Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.speedElevation)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                HStack(alignment: .firstTextBaseline, spacing: SpacingTheme.tight) {
                    Text(speedString)
                        .font(Typography.heroSubValueMono)
                        .monospacedDigit()
                        .foregroundStyle(accentFg)
                        .lineLimit(1)

                    Text(L10n.Tools.gnssSpeedUnit)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .lineLimit(1)
                }

                Text(altString)
                    .font(Typography.captionMono)
                    .monospacedDigit()
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.tileBackground(for: colorScheme))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel(L10n.Tools.speedElevation)
            .accessibilityValue("\(speedString) \(L10n.Tools.gnssSpeedUnit), \(altString)")
        }
    }

    // MARK: - Coordinate Datums Conversion Cards
    @ViewBuilder
    private var coordinateDatumsCard: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            Text(L10n.Tools.coordinateConversionTitle)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            datumRow(title: L10n.Tools.wgs84Desc, value: tools.gnssHub.wgs84Formatted, icon: "globe.desk.fill")
            BentoHairlineDivider()

            datumRow(title: L10n.Tools.gcj02Desc, value: tools.gnssHub.gcj02Formatted, icon: "map.fill")
            BentoHairlineDivider()

            datumRow(title: L10n.Tools.bd09Desc, value: tools.gnssHub.bd09Formatted, icon: "location.fill")
            BentoHairlineDivider()

            datumRow(title: L10n.Tools.mgrsDesc, value: tools.gnssHub.mgrsFormatted.isEmpty ? "--" : tools.gnssHub.mgrsFormatted, icon: "cross.circle.fill")
        }
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    @ViewBuilder
    private func datumRow(title: String, value: String, icon: String) -> some View {
        let isCopyable = value != "--" && !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        Button {
            guard isCopyable else { return }
            UIPasteboard.general.string = value
            Haptics.success()
            copiedDatum = title
            copyToastTask?.cancel()
            copyToastTask = Task { @MainActor in
                try? await Task.sleep(for: .seconds(1.5))
                guard !Task.isCancelled else { return }
                if copiedDatum == title {
                    copiedDatum = nil
                }
            }
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: icon)
                    .font(IconTheme.badgeInline)
                    .foregroundStyle(accentFg)
                    .frame(width: 22)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    Text(title)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)

                    Text(value)
                        .font(Typography.captionMono)
                        .monospacedDigit()
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                }

                Spacer(minLength: SpacingTheme.compact)

                if isCopyable {
                    Image(systemName: copiedDatum == title ? "checkmark.circle.fill" : "doc.on.doc.fill")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(copiedDatum == title ? Theme.readableGreen(for: colorScheme) : Theme.textTertiary(for: colorScheme))
                        .accessibilityHidden(true)
                }
            }
            .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(BentoCardButtonStyle())
        .disabled(!isCopyable)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(copiedDatum == title ? L10n.Common.copied : value)
        .accessibilityHint(isCopyable ? L10n.Common.copyValue : "")
    }

    // MARK: - Precision DOP Matrix Card
    @ViewBuilder
    private var dopMatrixCard: some View {
        let safeHdop = tools.gnssHub.hdop.isFinite ? tools.gnssHub.hdop : 1.0
        let safeVdop = tools.gnssHub.vdop.isFinite ? tools.gnssHub.vdop : 1.0
        let hdopString = String(format: "%.2f", safeHdop)
        let vdopString = String(format: "%.2f", safeVdop)

        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            Text(L10n.Tools.dopTitle)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            Group {
                if dynamicTypeSize.isAccessibilitySize {
                    VStack(alignment: .leading, spacing: SpacingTheme.row) {
                        dopCell(title: L10n.Tools.horizontalDop, value: hdopString, isGood: safeHdop <= 2.0)
                        BentoHairlineDivider()
                        dopCell(title: L10n.Tools.verticalDop, value: vdopString, isGood: safeVdop <= 3.0)
                    }
                } else {
                    HStack(spacing: SpacingTheme.standard) {
                        dopCell(title: L10n.Tools.horizontalDop, value: hdopString, isGood: safeHdop <= 2.0)

                        Rectangle()
                            .fill(Theme.cardBorder(for: colorScheme))
                            .frame(width: 0.5, height: 36)
                            .accessibilityHidden(true)

                        dopCell(title: L10n.Tools.verticalDop, value: vdopString, isGood: safeVdop <= 3.0)
                    }
                }
            }
            .padding(.top, SpacingTheme.tight)
        }
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.tileBackground(for: colorScheme))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    @ViewBuilder
    private func dopCell(title: String, value: String, isGood: Bool) -> some View {
        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
            Text(title)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)

            Text(value)
                .font(Typography.headlineValue)
                .fontDesign(.monospaced)
                .monospacedDigit()
                .foregroundStyle(isGood ? Theme.readableGreen(for: colorScheme) : Theme.readableOrange(for: colorScheme))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(value)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        GnssHubDetailView()
    }
}
