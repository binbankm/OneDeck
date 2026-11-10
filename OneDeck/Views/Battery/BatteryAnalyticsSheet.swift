//
//  BatteryAnalyticsSheet.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Apple diagnostic analytics log importer and parsing sheet.
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
    @State private var pastedText: String = ""
    @State private var errorMessage: String?
    @State private var successRecord: BatteryAnalyticsRecord?
    @State private var isShowingFilePicker: Bool = false
    @State private var autoDismissTask: Task<Void, Never>?
    @FocusState private var isPasteEditorFocused: Bool

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
            .background(Theme.background(for: colorScheme).ignoresSafeArea())
            .navigationTitle(L10n.Battery.guideTitle)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingFilePicker) {
                DocumentPickerRepresentable(
                    allowedTypes: [
                        .data,
                        .text,
                        .plainText,
                        .json,
                        UTType(filenameExtension: "ips") ?? .data,
                        UTType(filenameExtension: "synced") ?? .data,
                        UTType(filenameExtension: "ca") ?? .data,
                        UTType(filenameExtension: "log") ?? .data
                    ],
                    onPick: { url in
                        handleFileImport(url: url)
                    },
                    onCancel: {
                        isShowingFilePicker = false
                    }
                )
                .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.Common.done) {
                        dismiss()
                    }
                    .font(Typography.sectionHeader)
                    .foregroundStyle(appState.accentColor)
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(L10n.Common.done) {
                        isPasteEditorFocused = false
                    }
                }
            }
            .onDisappear {
                autoDismissTask?.cancel()
                autoDismissTask = nil
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
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                Text(L10n.Battery.guideStep2)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                Text(L10n.Battery.guideStep3)
                    .font(Typography.caption)
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
            isShowingFilePicker = true
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
            .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
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
                .focused($isPasteEditorFocused)
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
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
            Text(val)
                .font(Typography.bodyValue)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
        }
    }

    // MARK: - Handlers
    private func handleFileImport(url: URL) {
        isPasteEditorFocused = false
        autoDismissTask?.cancel()
        autoDismissTask = Task { @MainActor in
            let parseResult = await battery.parseAnalyticsFile(url: url)
            guard !Task.isCancelled else { return }
            switch parseResult {
            case let .success(rec):
                Haptics.success()
                self.successRecord = rec
                self.errorMessage = nil
                try? await Task.sleep(for: .seconds(1.2))
                guard !Task.isCancelled else { return }
                dismiss()
            case let .failure(err):
                Haptics.error()
                self.errorMessage = err.localizedDescription
            }
        }
    }

    private func handlePasteParse() {
        isPasteEditorFocused = false
        let text = pastedText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let result = battery.parseAnalyticsText(text, sourceName: L10n.Battery.pasteLogButton)
        switch result {
        case let .success(rec):
            Haptics.success()
            self.successRecord = rec
            self.errorMessage = nil
            autoDismissTask?.cancel()
            autoDismissTask = Task { @MainActor in
                try? await Task.sleep(for: .seconds(1.2))
                guard !Task.isCancelled else { return }
                dismiss()
            }
        case let .failure(err):
            Haptics.error()
            self.errorMessage = err.localizedDescription
        }
    }
}

// MARK: - Native Document Picker Representable
private struct DocumentPickerRepresentable: UIViewControllerRepresentable {
    let allowedTypes: [UTType]
    let onPick: (URL) -> Void
    let onCancel: () -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedTypes, asCopy: true)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }

    func updateUIViewController(_: UIDocumentPickerViewController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPickerRepresentable

        init(_ parent: DocumentPickerRepresentable) {
            self.parent = parent
        }

        func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.onPick(url)
        }

        func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
            parent.onCancel()
        }
    }
}

// MARK: - Preview
#Preview {
    BatteryAnalyticsSheet()
}
