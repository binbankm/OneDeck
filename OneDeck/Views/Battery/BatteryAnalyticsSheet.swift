//
//  BatteryAnalyticsSheet.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Analytics File Importer & Text Parser Sheet for Battery Diagnostics.
//

import SwiftUI
import UniformTypeIdentifiers

struct BatteryAnalyticsSheet: View {
    // MARK: - Dependencies & Environment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    // MARK: - State
    @State private var showFilePicker: Bool = false
    @State private var pastedText: String = ""
    @State private var errorMessage: String?
    @State private var successRecord: BatteryAnalyticsRecord?

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: SpacingTheme.cardStack) {
                    guideSection
                    filePickerSection
                    dividerSection
                    textPasteSection
                    resultSection
                }
                .padding(SpacingTheme.cardStack)
            }
            .navigationTitle(L10n.Battery.guideTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        dismiss()
                    }
                    .font(Typography.sectionHeader)
                    .foregroundStyle(appState.accentColor)
                }
            }
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [.item, .text, .json],
                allowsMultipleSelection: false
            ) { result in
                handleFileImport(result: result)
            }
        }
    }

    // MARK: - Subviews
    @ViewBuilder
    private var guideSection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.row) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(IconTheme.sectionHeader)
                    .foregroundStyle(appState.accentColor)
                Text(L10n.Battery.guideStepsHeader)
                    .font(Typography.sectionHeader)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                Text(L10n.Battery.guideStep1)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                Text(L10n.Battery.guideStep2)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                Text(L10n.Battery.guideStep3)
                    .font(Typography.calloutLabel)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
            }
        }
        .padding(SpacingTheme.cardInternal)
        .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.prominent, style: .continuous))
    }

    @ViewBuilder
    private var filePickerSection: some View {
        Button {
            Haptics.impact(.medium)
            showFilePicker = true
        } label: {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: "doc.fill.badge.plus")
                    .font(IconTheme.actionButton)
                Text(L10n.Battery.selectFileButton)
                    .font(Typography.sectionHeader)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(appState.accentColor)
            .foregroundStyle(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
        }
    }

    @ViewBuilder
    private var dividerSection: some View {
        HStack(spacing: SpacingTheme.rowStandard) {
            Rectangle()
                .fill(colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.12))
                .frame(height: 0.5)

            Text(L10n.Battery.orPasteSnippet)
                .font(Typography.caption)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)

            Rectangle()
                .fill(colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.12))
                .frame(height: 0.5)
        }
        .padding(.vertical, SpacingTheme.tight)
    }

    @ViewBuilder
    private var textPasteSection: some View {
        VStack(alignment: .leading, spacing: SpacingTheme.row) {
            TextEditor(text: $pastedText)
                .scrollContentBackground(.hidden)
                .font(Typography.captionMono)
                .frame(height: 120)
                .padding(SpacingTheme.standard)
                .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(alignment: .topLeading) {
                    if pastedText.isEmpty {
                        Text(L10n.Battery.pastePlaceholder)
                            .font(Typography.captionRegular)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                            .padding(SpacingTheme.rowStandard)
                            .allowsHitTesting(false)
                    }
                }

            Button {
                Haptics.impact(.medium)
                handlePasteParse()
            } label: {
                HStack(spacing: SpacingTheme.compact) {
                    Image(systemName: "sparkles")
                        .font(IconTheme.actionButton)
                    Text(L10n.Battery.parseNow)
                }
                .font(Typography.bodyValue)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(appState.accentColor.opacity(0.15))
                .foregroundStyle(appState.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .disabled(pastedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    @ViewBuilder
    private var resultSection: some View {
        if let record = successRecord {
            VStack(alignment: .leading, spacing: SpacingTheme.standard) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(IconTheme.actionButton)
                        .foregroundStyle(.green)
                    Text(L10n.Common.success)
                        .font(Typography.sectionHeader)
                        .foregroundStyle(.green)
                }

                HStack(spacing: SpacingTheme.cardInternal) {
                    statPill(label: L10n.Battery.cycleCount, val: "\(record.cycleCount) \(L10n.Battery.cyclesUnit)")
                    statPill(label: L10n.Battery.health, val: String(format: "%.1f%%", record.healthPercent))
                    statPill(label: L10n.Battery.currentMaxCapacity, val: "\(record.nominalChargeCapacityMah) mAh")
                }
            }
            .padding(SpacingTheme.rowStandard)
            .background(Color.green.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
        }

        if let err = errorMessage {
            Text(err)
                .font(Typography.calloutLabel)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func statPill(label: String, val: String) -> some View {
        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
            Text(label)
                .font(Typography.badgeTagMedium)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
            Text(val)
                .font(Typography.bodyValue)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
    }

    // MARK: - Handlers
    private func handleFileImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            Task {
                let parseResult = await battery.parseAnalyticsFile(url: url)
                switch parseResult {
                case .success(let rec):
                    Haptics.success()
                    self.successRecord = rec
                    self.errorMessage = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        dismiss()
                    }
                case .failure(let err):
                    Haptics.error()
                    self.errorMessage = err.localizedDescription
                }
            }
        case .failure(let err):
            self.errorMessage = err.localizedDescription
        }
    }

    private func handlePasteParse() {
        let text = pastedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let result = battery.parseAnalyticsText(text, sourceName: "Manual Paste")
        switch result {
        case .success(let rec):
            Haptics.success()
            self.successRecord = rec
            self.errorMessage = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                dismiss()
            }
        case .failure(let err):
            Haptics.error()
            self.errorMessage = err.localizedDescription
        }
    }
}

// MARK: - Preview
#Preview {
    BatteryAnalyticsSheet()
}
