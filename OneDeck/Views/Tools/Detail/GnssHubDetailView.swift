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
    @Bindable private var appState = AppState.shared
    @Bindable private var tools = ToolsViewModel.shared

    @State private var copiedDatum: String? = nil
    @State private var copyToastTask: Task<Void, Never>?

    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: SpacingTheme.cardStack) {
                if tools.isGnssLocationDenied {
                    locationDeniedBanner
                }

                // Dual KPI Hero Cards
                dualMetricsHero

                // Coordinate Datums Conversion Cards
                coordinateDatumsCard

                // Precision DOP Matrix Card
                dopMatrixCard
            }
            .padding(.horizontal, SpacingTheme.cardStack)
            .padding(.vertical, SpacingTheme.rowStandard)
        }
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
        HStack(spacing: SpacingTheme.standard) {
            // Fix Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.satelliteFixStatus)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(tools.gnssHub.isFixAcquired ? "3D FIX" : "SEARCH")
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(tools.gnssHub.isFixAcquired ? Color.green : Color.orange)
                    .lineLimit(1)

                Text(tools.gnssHub.fixStatusText)
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )

            // Speed & Elevation Tile
            VStack(alignment: .leading, spacing: SpacingTheme.tight) {
                Text(L10n.Tools.speedElevation)
                    .font(Typography.badgeTagMono)
                    .foregroundStyle(Theme.textTertiary(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                let safeSpeed = tools.gnssHub.speedKmh.isFinite ? tools.gnssHub.speedKmh : 0.0
                Text(String(format: "%.1f", safeSpeed))
                    .font(Typography.heroSubValueMono)
                    .foregroundStyle(appState.accentColor)
                    .lineLimit(1)

                let safeAlt = tools.gnssHub.altitudeM.isFinite ? tools.gnssHub.altitudeM : 0.0
                Text(String(format: "%@: %.1f m", L10n.Tools.relativeElevation, safeAlt))
                    .font(Typography.captionMono)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                    .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
            )
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
            Divider().foregroundStyle(Theme.cardBorder(for: colorScheme))

            datumRow(title: L10n.Tools.gcj02Desc, value: tools.gnssHub.gcj02Formatted, icon: "map.fill")
            Divider().foregroundStyle(Theme.cardBorder(for: colorScheme))

            datumRow(title: L10n.Tools.bd09Desc, value: tools.gnssHub.bd09Formatted, icon: "location.fill")
            Divider().foregroundStyle(Theme.cardBorder(for: colorScheme))

            datumRow(title: L10n.Tools.mgrsDesc, value: tools.gnssHub.mgrsFormatted.isEmpty ? "--" : tools.gnssHub.mgrsFormatted, icon: "cross.circle.fill")
        }
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
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
                    .foregroundStyle(appState.accentColor)
                    .frame(width: 22)

                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    Text(title)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))

                    Text(value)
                        .font(Typography.captionMono)
                        .foregroundStyle(Theme.textPrimary(for: colorScheme))
                }

                Spacer()

                if isCopyable {
                    Image(systemName: copiedDatum == title ? "checkmark.circle.fill" : "doc.on.doc.fill")
                        .font(IconTheme.badgeInline)
                        .foregroundStyle(copiedDatum == title ? Color.green : Theme.textTertiary(for: colorScheme))
                }
            }
            .padding(.vertical, SpacingTheme.compact)
        }
        .buttonStyle(.plain)
        .disabled(!isCopyable)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue(value)
        .accessibilityHint(isCopyable ? L10n.Common.copyValue : "")
    }

    // MARK: - Precision DOP Matrix Card
    @ViewBuilder
    private var dopMatrixCard: some View {
        let safeHdop = tools.gnssHub.hdop.isFinite ? tools.gnssHub.hdop : 1.0
        let safeVdop = tools.gnssHub.vdop.isFinite ? tools.gnssHub.vdop : 1.0

        VStack(alignment: .leading, spacing: SpacingTheme.tight) {
            Text(L10n.Tools.dopTitle)
                .font(Typography.badgeTagMono)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))

            HStack(spacing: SpacingTheme.standard) {
                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    Text(L10n.Tools.horizontalDop)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    Text(String(format: "%.2f", safeHdop))
                        .font(Typography.headlineValue)
                        .fontDesign(.monospaced)
                        .foregroundStyle(safeHdop <= 2.0 ? Color.green : Color.orange)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Divider()
                    .frame(height: 36)

                VStack(alignment: .leading, spacing: SpacingTheme.micro) {
                    Text(L10n.Tools.verticalDop)
                        .font(Typography.caption)
                        .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    Text(String(format: "%.2f", safeVdop))
                        .font(Typography.headlineValue)
                        .fontDesign(.monospaced)
                        .foregroundStyle(safeVdop <= 3.0 ? Color.green : Color.orange)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, SpacingTheme.tight)
        }
        .padding(SpacingTheme.rowStandard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                .stroke(Theme.cardBorder(for: colorScheme), lineWidth: 0.8)
        )
    }

    @ViewBuilder
    private var locationDeniedBanner: some View {
        VStack(spacing: SpacingTheme.compact) {
            HStack(spacing: SpacingTheme.tight) {
                Image(systemName: "location.slash.fill")
                    .foregroundStyle(Color.orange)
                Text(L10n.Tools.locationPermissionDenied)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
                    .multilineTextAlignment(.leading)
            }

            Button {
                tools.openAppSettings()
            } label: {
                Text(L10n.Tools.openSettings)
                    .font(Typography.captionBold)
                    .padding(.horizontal, SpacingTheme.standard)
                    .padding(.vertical, SpacingTheme.tight)
                    .background(Color.orange)
                    .foregroundStyle(Color.white)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(SpacingTheme.cardInternal)
        .background(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .fill(Theme.cardBackground(for: colorScheme).opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.standard, style: .continuous)
                .stroke(Color.orange.opacity(0.4), lineWidth: 0.8)
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        GnssHubDetailView()
    }
}
