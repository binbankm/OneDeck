//
//  Haptics.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Leica-grade Taptic feedback engine for physical instruments and dials.
//

import UIKit

@MainActor
public enum Haptics {
    private static let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private static let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private static let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private static let softImpact = UIImpactFeedbackGenerator(style: .soft)
    private static let rigidImpact = UIImpactFeedbackGenerator(style: .rigid)
    private static let selectionFeedback = UISelectionFeedbackGenerator()
    private static let notificationFeedback = UINotificationFeedbackGenerator()

    // MARK: - Impact Styles
    public static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        switch style {
        case .light:
            lightImpact.prepare()
            lightImpact.impactOccurred()
        case .medium:
            mediumImpact.prepare()
            mediumImpact.impactOccurred()
        case .heavy:
            heavyImpact.prepare()
            heavyImpact.impactOccurred()
        case .soft:
            softImpact.prepare()
            softImpact.impactOccurred()
        case .rigid:
            rigidImpact.prepare()
            rigidImpact.impactOccurred()
        @unknown default:
            mediumImpact.prepare()
            mediumImpact.impactOccurred()
        }
    }

    // MARK: - Mechanical Wheel / Dial Tick
    public static func tick() {
        rigidImpact.prepare()
        rigidImpact.impactOccurred(intensity: 0.8)
    }

    // MARK: - Spirit Level Zero-Lock (Mechanical lock sensation)
    public static func snapLock() {
        rigidImpact.prepare()
        rigidImpact.impactOccurred(intensity: 1.0)
    }

    // MARK: - Selection change
    public static func selection() {
        selectionFeedback.prepare()
        selectionFeedback.selectionChanged()
    }

    // MARK: - Notifications
    public static func success() {
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(.success)
    }

    public static func warning() {
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(.warning)
    }

    public static func error() {
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(.error)
    }
}

