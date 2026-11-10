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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var appState = AppState.shared
    @Bindable private var battery = BatteryViewModel.shared

    // MARK: - State
    @State private var pastedText: String = ""
    @State private var errorMessage: String?
    @State private var successRecord: BatteryAnalyticsRecord?
    @State private var isShowingFilePicker: Bool = false
    @State private var autoDismissTask: Task<Void, Never>?
    @FocusState private var isPasteEditorFocused: Bool

    private var readableAccent: Color {
        Theme.readableAccent(appState.accentColor, for: colorScheme)
    }

    private var isPasteEmpty: Bool {
        pastedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

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
                .frame(maxWidth: LayoutTheme.maxContentWidth)
                .frame(maxWidth: .infinity)
                .padding(SpacingTheme.cardStack)
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollDismissesKeyboard(.interactively)
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
                    .foregroundStyle(readableAccent)
                }

                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(L10n.Common.done) {
                        isPasteEditorFocused = false
                    }
                    .font(Typography.sectionHeader)
                    .foregroundStyle(readableAccent)
                }
            }
            .onDisappear {
                autoDismissTask?.cancel()
                autoDismissTask = nil
            }
        }
        .presentationDragIndicator(.visible)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var guideSection: some View {
        let accent = readableAccent

        VStack(alignment: .leading, spacing: SpacingTheme.row) {
            HStack(spacing: SpacingTheme.standard) {
                Image(systemName: "info.circle.fill")
                    .font(IconTheme.sectionHeader)
                    .foregroundStyle(accent)
                    .accessibilityHidden(true)

                Text(L10n.Battery.guideStepsHeader)
                    .font(Typography.sectionHeader)
                    .foregroundStyle(Theme.textPrimary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                Text(L10n.Battery.guideStep1)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(L10n.Battery.guideStep2)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(L10n.Battery.guideStep3)
                    .font(Typography.caption)
                    .foregroundStyle(Theme.textSecondary(for: colorScheme))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(SpacingTheme.cardInternal)
        .background(Theme.tileBackground(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.prominent, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadiusTheme.prominent, style: .continuous)
                .stroke(Theme.tileBorder(for: colorScheme), lineWidth: 0.6)
        )
        .accessibilityElement(children: .combine)
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
                    .accessibilityHidden(true)

                Text(L10n.Battery.selectFileButton)
                    .font(Typography.sectionHeader)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .padding(.horizontal, SpacingTheme.row)
            .background(appState.accentColor)
            .foregroundStyle(Theme.contrastingForeground(for: appState.accentColor))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
        }
        .buttonStyle(BentoCardButtonStyle())
    }

    @ViewBuilder
    private var dividerSection: some View {
        HStack(spacing: SpacingTheme.rowStandard) {
            BentoHairlineDivider()

            Text(L10n.Battery.orPasteSnippet)
                .font(Typography.caption)
                .foregroundStyle(Theme.textTertiary(for: colorScheme))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)

            BentoHairlineDivider()
        }
        .padding(.vertical, SpacingTheme.tight)
    }

    @ViewBuilder
    private var textPasteSection: some View {
        let accent = readableAccent

        VStack(alignment: .leading, spacing: SpacingTheme.row) {
            TextEditor(text: $pastedText)
                .focused($isPasteEditorFocused)
                .scrollContentBackground(.hidden)
                .font(Typography.captionMono)
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .tint(accent)
                .frame(minHeight: 120, maxHeight: 160)
                .padding(SpacingTheme.standard)
                .background(Theme.tileBackground(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(isPasteEditorFocused ? accent.opacity(0.6) : Theme.tileBorder(for: colorScheme), lineWidth: isPasteEditorFocused ? 1.0 : 0.6)
                )
                .overlay(alignment: .topLeading) {
                    if pastedText.isEmpty {
                        Text(L10n.Battery.pastePlaceholder)
                            .font(Typography.captionRegular)
                            .foregroundStyle(Theme.textTertiary(for: colorScheme))
                            .padding(SpacingTheme.rowStandard)
                            .allowsHitTesting(false)
                            .accessibilityHidden(true)
                    }
                }
                .accessibilityLabel(L10n.Battery.pasteLogButton)
                .accessibilityHint(L10n.Battery.pastePlaceholder)

            Button {
                Haptics.impact(.medium)
                handlePasteParse()
            } label: {
                HStack(spacing: SpacingTheme.compact) {
                    Image(systemName: "doc.badge.gearshape.fill")
                        .font(IconTheme.actionButton)
                        .accessibilityHidden(true)

                    Text(L10n.Battery.parseNow)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                .font(Typography.calloutBold)
                .frame(maxWidth: .infinity, minHeight: LayoutTheme.minTapTarget)
                .padding(.horizontal, SpacingTheme.row)
                .background(accent.opacity(0.14))
                .foregroundStyle(accent)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous)
                        .stroke(accent.opacity(0.28), lineWidth: 0.6)
                )
                .contentShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
            }
            .buttonStyle(BentoCardButtonStyle())
            .disabled(isPasteEmpty)
            .opacity(isPasteEmpty ? 0.5 : 1.0)
        }
    }

    @ViewBuilder
    private var resultSection: some View {
        let green = Theme.readableGreen(for: colorScheme)
        let red = Theme.readableRed(for: colorScheme)

        if let record = successRecord {
            VStack(alignment: .leading, spacing: SpacingTheme.standard) {
                HStack(spacing: SpacingTheme.compact) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(IconTheme.actionButton)
                        .foregroundStyle(green)
                        .accessibilityHidden(true)

                    Text(L10n.Common.success)
                        .font(Typography.sectionHeader)
                        .foregroundStyle(green)
                }

                Group {
                    if dynamicTypeSize.isAccessibilitySize {
                        VStack(alignment: .leading, spacing: SpacingTheme.compact) {
                            statPill(label: L10n.Battery.cycleCount, val: "\(record.cycleCount) \(L10n.Battery.cyclesUnit)")
                            statPill(label: L10n.Battery.health, val: String(format: "%.1f%%", record.healthPercent))
                            statPill(label: L10n.Battery.currentMaxCapacity, val: "\(record.nominalChargeCapacityMah) mAh")
                        }
                    } else {
                        HStack(spacing: SpacingTheme.cardInternal) {
                            statPill(label: L10n.Battery.cycleCount, val: "\(record.cycleCount) \(L10n.Battery.cyclesUnit)")
                            statPill(label: L10n.Battery.health, val: String(format: "%.1f%%", record.healthPercent))
                            statPill(label: L10n.Battery.currentMaxCapacity, val: "\(record.nominalChargeCapacityMah) mAh")
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(SpacingTheme.rowStandard)
            .background(green.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadiusTheme.button, style: .continuous)
                    .stroke(green.opacity(0.3), lineWidth: 0.6)
            )
            .accessibilityElement(children: .combine)
        }

        if let err = errorMessage {
            Text(err)
                .font(Typography.calloutLabel)
                .foregroundStyle(red)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, SpacingTheme.row)
                .padding(.vertical, SpacingTheme.standard)
                .background(red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusTheme.tile, style: .continuous))
                .accessibilityLabel("\(L10n.Common.failed): \(err)")
        }
    }

    @ViewBuilder
    private func statPill(label: String, val: String) -> some View {
        VStack(alignment: .leading, spacing: SpacingTheme.micro) {
            Text(label)
                .font(Typography.caption)
                .foregroundStyle(Theme.textSecondary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Text(val)
                .font(Typography.bodyValue)
                .monospacedDigit()
                .foregroundStyle(Theme.textPrimary(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label)
        .accessibilityValue(val)
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
