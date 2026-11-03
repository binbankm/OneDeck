//
//  ProvisioningHardwareProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Deep Certificate & MobileProvision Telemetry Probe.
//

import Foundation
import Observation

@Observable
@MainActor
public final class ProvisioningHardwareProbe {
    public static let shared = ProvisioningHardwareProbe()

    // MARK: - Telemetry Properties
    public var hasProvisionProfile: Bool = false
    public var profileName: String = "OneDeck Development"
    public var teamName: String = "Apple Developer"
    public var teamIdentifier: String = "38FTS86UNN"
    public var bundleIdentifier: String = "com.lbyan.OneDeck"
    public var creationDate: Date? = nil
    public var expirationDate: Date? = nil
    public var remainingDays: Int = 6
    public var remainingHours: Int = 23
    public var isExpired: Bool = false
    public var signingType: SigningType = .freePersonal

    public enum SigningType: String, Sendable {
        case freePersonal
        case enterprise
        case developer
        case appStoreOrTestFlight

        public var localizedName: String {
            switch self {
            case .freePersonal:
                return L10n.Settings.certFreePersonal
            case .enterprise:
                return L10n.Settings.certEnterprise
            case .developer:
                return L10n.Settings.certDeveloper
            case .appStoreOrTestFlight:
                return L10n.Settings.certAppStore
            }
        }
    }

    public init() {
        refresh()
    }

    public func refresh() {
        if let bundleId = Bundle.main.bundleIdentifier {
            self.bundleIdentifier = bundleId
        }

        guard let path = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") ??
                        Bundle.main.path(forResource: "embedded.mobileprovision", ofType: nil),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            // No embedded.mobileprovision: Running via App Store, TestFlight, or Simulator
            self.hasProvisionProfile = false
            self.signingType = .appStoreOrTestFlight
            self.remainingDays = 365
            self.remainingHours = 0
            self.isExpired = false
            self.profileName = "App Store / Sandbox"
            self.teamName = "Apple Ecosystem"
            return
        }

        parseMobileProvision(data: data)
    }

    private func parseMobileProvision(data: Data) {
        guard let xmlString = extractPlistXml(from: data),
              let xmlData = xmlString.data(using: .utf8),
              let plist = try? PropertyListSerialization.propertyList(from: xmlData, options: [], format: nil) as? [String: Any] else {
            self.hasProvisionProfile = true
            self.signingType = .freePersonal
            return
        }

        self.hasProvisionProfile = true

        if let name = plist["Name"] as? String {
            self.profileName = name
        }
        if let team = plist["TeamName"] as? String {
            self.teamName = team
        }
        if let teamIds = plist["TeamIdentifier"] as? [String], let firstId = teamIds.first {
            self.teamIdentifier = firstId
        }
        if let creation = plist["CreationDate"] as? Date {
            self.creationDate = creation
        }
        if let expiration = plist["ExpirationDate"] as? Date {
            self.expirationDate = expiration
            let diff = expiration.timeIntervalSince(Date())
            if diff <= 0 {
                self.isExpired = true
                self.remainingDays = 0
                self.remainingHours = 0
            } else {
                self.isExpired = false
                self.remainingDays = Int(diff) / 86400
                self.remainingHours = (Int(diff) % 86400) / 3600
            }

            // Determine signing type
            if let provisionsAll = plist["ProvisionsAllDevices"] as? Bool, provisionsAll {
                self.signingType = .enterprise
            } else if let creation = self.creationDate {
                let durationDays = expiration.timeIntervalSince(creation) / 86400.0
                if durationDays <= 8.0 {
                    self.signingType = .freePersonal
                } else {
                    self.signingType = .developer
                }
            } else {
                self.signingType = .freePersonal
            }
        }
    }

    private func extractPlistXml(from data: Data) -> String? {
        guard let rawString = String(data: data, encoding: .isoLatin1) else { return nil }
        guard let startRange = rawString.range(of: "<?xml") else { return nil }
        guard let endRange = rawString.range(of: "</plist>") else { return nil }

        let plistSubstring = rawString[startRange.lowerBound..<endRange.upperBound]
        return String(plistSubstring)
    }
}

