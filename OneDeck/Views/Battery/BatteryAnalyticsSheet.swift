//
//  BatteryAnalyticsSheet.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Apple Diagnostics Log Parser Sheet: 1-Click File Importer & Text Scanner for BMS Gas Gauge Data.
//

import SwiftUI
import UniformTypeIdentifiers

struct BatteryAnalyticsSheet: View {
    @Bindable var appState = AppState.shared
    @Bindable var battery = BatteryService.shared
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var showFilePicker: Bool = false
    @State private var pastedText: String = ""
    @State private var errorMessage: String?
    @State private var successRecord: BatteryAnalyticsRecord?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - 1. Tutorial Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(appState.accentColor)
                            Text(L10n.Battery.guideTitle)
                                .font(.system(.headline, design: .rounded))
                                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text(L10n.Battery.guideStep1)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            Text(L10n.Battery.guideStep2)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                            Text(L10n.Battery.guideStep3)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                        }
                    }
                    .padding(14)
                    .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    // MARK: - 2. Action: File Picker
                    Button {
                        Haptics.impact(.medium)
                        showFilePicker = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "doc.badge.plus")
                                .font(.system(size: 14, weight: .semibold))
                            Text(L10n.Battery.selectFileButton)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(appState.accentColor)
                        .foregroundStyle(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    // Divider
                    HStack {
                        Rectangle().fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1)).frame(height: 0.5)
                        Text(L10n.Battery.orPasteSnippet)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                        Rectangle().fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1)).frame(height: 0.5)
                    }
                    .padding(.vertical, 4)

                    // MARK: - 3. Action: Text Paste
                    VStack(alignment: .leading, spacing: 10) {
                        TextEditor(text: $pastedText)
                            .font(.system(size: 11, design: .monospaced))
                            .frame(height: 120)
                            .padding(8)
                            .background(colorScheme == .dark ? Color.white.opacity(0.04) : Color.black.opacity(0.03))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(
                                Group {
                                    if pastedText.isEmpty {
                                        Text(L10n.Battery.pastePlaceholder)
                                            .font(.system(size: 11))
                                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                                            .padding(12)
                                            .allowsHitTesting(false)
                                    }
                                }
                            )

                        Button {
                            Haptics.impact(.medium)
                            handlePasteParse()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                Text(L10n.Battery.parseNow)
                            }
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .frame(height: 38)
                            .background(appState.accentColor.opacity(0.15))
                            .foregroundStyle(appState.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                        .disabled(pastedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }

                    // Result Preview Card (If parsed)
                    if let record = successRecord {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text(L10n.Common.success)
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(.green)
                            }

                            HStack(spacing: 14) {
                                statPill(label: L10n.Battery.cycleCount, val: "\(record.cycleCount) \(L10n.Battery.cyclesUnit)")
                                statPill(label: L10n.Battery.health, val: String(format: "%.1f%%", record.healthPercent))
                                statPill(label: L10n.Battery.currentMaxCapacity, val: "\(record.nominalChargeCapacityMah) mAh")
                            }
                        }
                        .padding(12)
                        .background(Color.green.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    if let err = errorMessage {
                        Text(err)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .padding(16)
            }
            .navigationTitle(L10n.Battery.guideTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        dismiss()
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(appState.accentColor)
                }
            }
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [.item, .text, .json],
                allowsMultipleSelection: false
            ) { result in
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
        }
    }

    private func handlePasteParse() {
        let result = battery.parseAnalyticsText(pastedText)
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

    @ViewBuilder
    private func statPill(label: String, val: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
            Text(val)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
    }
}

