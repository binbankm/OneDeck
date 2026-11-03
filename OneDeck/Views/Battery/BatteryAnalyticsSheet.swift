//
//  BatteryAnalyticsSheet.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Apple diagnostic analytics log importer and parsing sheet.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

// MARK: - Document Picker Coordinator
final class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
    private let onPick: (URL) -> Void
    private let onDismiss: (() -> Void)?

    init(onPick: @escaping (URL) -> Void, onDismiss: (() -> Void)? = nil) {
        self.onPick = onPick
        self.onDismiss = onDismiss
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        onPick(url)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        onDismiss?()
    }
}

// MARK: - View Controller Presentation Helper
extension UIApplication {
    @MainActor
    fileprivate func topMostViewController(base: UIViewController? = nil) -> UIViewController? {
        let baseVC = base ?? connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .rootViewController

        if let nav = baseVC as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }
        if let tab = baseVC as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topMostViewController(base: selected)
            }
        }
        if let presented = baseVC?.presentedViewController {
            return topMostViewController(base: presented)
        }
        return baseVC
    }
}

struct BatteryAnalyticsSheet: View {
    // MARK: - Dependencies & Environment
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    // MARK: - State
    @State private var pastedText: String = ""
    @State private var errorMessage: String?
    @State private var successRecord: BatteryAnalyticsRecord?
    @State private var pickerCoordinator: DocumentPickerCoordinator?

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
            openFilePicker()
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
        .buttonStyle(.plain)
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
                    Image(systemName: "doc.badge.gearshape.fill")
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
            .buttonStyle(.plain)
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
    private func openFilePicker() {
        Haptics.impact(.medium)

        let types: [UTType] = [
            .item,
            .content,
            .data,
            .text,
            .plainText,
            .json,
            UTType(filenameExtension: "ips") ?? .data,
            UTType(filenameExtension: "synced") ?? .data,
            UTType(filenameExtension: "ca") ?? .data,
            UTType(filenameExtension: "log") ?? .data
        ]

        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        picker.allowsMultipleSelection = false

        let coordinator = DocumentPickerCoordinator(
            onPick: { url in
                handleFileImport(url: url)
            },
            onDismiss: {
                self.pickerCoordinator = nil
            }
        )
        self.pickerCoordinator = coordinator
        picker.delegate = coordinator

        guard let topVC = UIApplication.shared.topMostViewController() else { return }
        topVC.present(picker, animated: true)
    }

    private func handleFileImport(url: URL) {
        self.pickerCoordinator = nil
        Task {
            let parseResult = await battery.parseAnalyticsFile(url: url)
            switch parseResult {
            case let .success(rec):
                Haptics.success()
                self.successRecord = rec
                self.errorMessage = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    dismiss()
                }
            case let .failure(err):
                Haptics.error()
                self.errorMessage = err.localizedDescription
            }
        }
    }

    private func handlePasteParse() {
        let text = pastedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let result = battery.parseAnalyticsText(text, sourceName: "Manual Paste")
        switch result {
        case let .success(rec):
            Haptics.success()
            self.successRecord = rec
            self.errorMessage = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                dismiss()
            }
        case let .failure(err):
            Haptics.error()
            self.errorMessage = err.localizedDescription
        }
    }
}

// MARK: - Preview
#Preview {
    BatteryAnalyticsSheet()
}
