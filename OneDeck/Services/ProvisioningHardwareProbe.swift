//
//  ProvisioningHardwareProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  Certificate, mobile provisioning profile, and entitlement telemetry probe.
//

import CryptoKit
import Foundation
import Observation
import Security

@Observable
@MainActor
public final class ProvisioningHardwareProbe {
    public static let shared = ProvisioningHardwareProbe()

    // MARK: - Core Telemetry Properties
    public var hasProvisionProfile: Bool = false
    public var profileName: String = ""
    public var profileUUID: String = ""
    public var appIdentifier: String = Bundle.main.bundleIdentifier ?? "com.lbyan.OneDeck"
    public var creationDate: Date?
    public var expirationDate: Date?
    public var remainingDays: Int = 0
    public var remainingHours: Int = 0
    public var isExpired: Bool = false
    public var signingType: SigningType = .appStore
    public var isTrollStore: Bool = false

    // MARK: - Deep Cryptographic & Entitlements Telemetry
    public var certificateSubject: String = ""
    public var certificateSha1: String = ""
    public var certificateSha256: String = ""
    public var provisionedDevicesCount: Int = 0
    public var provisionsAllDevices: Bool = false
    public var isTaskAllowEnabled: Bool = false
    public var keychainAccessGroups: [String] = []
    public var rawEntitlements: [String: String] = [:]

    // Computed Health & Progress
    public var isExpiringSoon: Bool {
        hasProvisionProfile && !isExpired && remainingDays < 2
    }

    public var progressRatio: Double {
        if isExpired { return 0.0 }
        switch signingType {
        case .freePersonal:
            let totalHours = 7.0 * 24.0
            let leftHours = Double(remainingDays) * 24.0 + Double(remainingHours)
            return min(1.0, max(0.0, leftHours / totalHours))
        case .developer, .enterprise:
            return min(1.0, max(0.0, Double(remainingDays) / 365.0))
        case .trollStore, .appStore, .testFlight, .simulator:
            return 1.0
        }
    }

    public var statusText: String {
        if signingType == .trollStore {
            return L10n.Settings.certPermanent
        }
        if isExpired {
            return L10n.Settings.certExpired
        } else if isExpiringSoon {
            return L10n.Settings.certExpiringSoon
        } else if hasProvisionProfile {
            return L10n.Settings.certActive
        } else {
            return L10n.Settings.certPermanent
        }
    }

    public enum SigningType: String, Sendable, CaseIterable {
        case freePersonal
        case developer
        case enterprise
        case trollStore
        case testFlight
        case appStore
        case simulator

        public var localizedName: String {
            switch self {
            case .freePersonal:
                return L10n.Settings.certFreePersonal
            case .developer:
                return L10n.Settings.certDeveloper
            case .enterprise:
                return L10n.Settings.certEnterprise
            case .trollStore:
                return L10n.Settings.certTrollStore
            case .testFlight:
                return L10n.Settings.certTestFlight
            case .appStore:
                return L10n.Settings.certAppStore
            case .simulator:
                return L10n.Settings.certSimulator
            }
        }

        public var iconName: String {
            switch self {
            case .freePersonal:
                return "clock.badge.checkmark.fill"
            case .developer:
                return "person.badge.shield.checkmark.fill"
            case .enterprise:
                return "building.2.crop.circle.fill"
            case .trollStore:
                return "checkmark.shield.fill"
            case .testFlight:
                return "airplane.circle.fill"
            case .appStore:
                return "apple.logo"
            case .simulator:
                return "macbook.and.iphone"
            }
        }
    }

    public init() {
        refresh()
    }

    public func refresh() {
        hasProvisionProfile = false
        profileName = ""
        profileUUID = ""
        appIdentifier = Bundle.main.bundleIdentifier ?? "com.lbyan.OneDeck"
        creationDate = nil
        expirationDate = nil
        remainingDays = 0
        remainingHours = 0
        isExpired = false
        isTrollStore = false
        certificateSubject = ""
        certificateSha1 = ""
        certificateSha256 = ""
        provisionedDevicesCount = 0
        provisionsAllDevices = false
        isTaskAllowEnabled = false
        keychainAccessGroups = []
        rawEntitlements = [:]

        #if targetEnvironment(simulator)
        self.signingType = .simulator
        self.hasProvisionProfile = false
        self.remainingDays = 365
        self.remainingHours = 0
        self.isExpired = false
        self.profileName = "iOS Simulator Runtime"
        #else
        let trollStoreDetected = detectTrollStore()
        self.isTrollStore = trollStoreDetected

        // Search for embedded.mobileprovision inside App Bundle
        guard let path = Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") ??
            Bundle.main.path(forResource: "embedded.mobileprovision", ofType: nil),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            // No embedded.mobileprovision present
            self.hasProvisionProfile = false
            if trollStoreDetected {
                self.signingType = .trollStore
                self.profileName = "TrollStore CoreTrust Fakesign"
            } else if let receiptUrl = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: receiptUrl.path) {
                if receiptUrl.lastPathComponent.contains("sandboxReceipt") {
                    self.signingType = .testFlight
                } else {
                    self.signingType = .appStore
                }
            } else {
                self.signingType = .appStore
            }
            self.remainingDays = 365
            self.remainingHours = 0
            self.isExpired = false
            return
        }

        parseMobileProvision(data: data, trollStoreDetected: trollStoreDetected)
        #endif
    }

    private func detectTrollStore() -> Bool {
        if ProcessInfo.processInfo.isiOSAppOnMac {
            return false
        }
        let fm = FileManager.default
        let markers = [
            "/var/mobile/Library/TrollStore",
            "/Applications/TrollStore.app",
            "/var/containers/Bundle/Application/.trollstore"
        ]
        for marker in markers {
            if fm.fileExists(atPath: marker) {
                return true
            }
        }
        let bundlePath = Bundle.main.bundlePath
        if bundlePath.hasPrefix("/Applications/") || bundlePath.hasPrefix("/private/var/staged_system_apps/") {
            return true
        }
        return false
    }

    private func parseMobileProvision(data: Data, trollStoreDetected: Bool) {
        guard let xmlData = Self.extractPlistXmlData(from: data),
              let plist = try? PropertyListSerialization.propertyList(from: xmlData, options: [], format: nil) as? [String: Any] else {
            self.hasProvisionProfile = false
            self.signingType = trollStoreDetected ? .trollStore : .appStore
            return
        }

        self.hasProvisionProfile = true

        if let name = plist["Name"] as? String {
            self.profileName = name
        }
        if let uuid = plist["UUID"] as? String {
            self.profileUUID = uuid
        }
        if let appName = plist["AppIDName"] as? String {
            self.appIdentifier = appName
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
        }

        // Provisioned Devices Count
        if let devices = plist["ProvisionedDevices"] as? [String] {
            self.provisionedDevicesCount = devices.count
        }

        // Provisions All Devices (Enterprise In-House flag)
        if let provisionsAll = plist["ProvisionsAllDevices"] as? Bool, provisionsAll {
            self.provisionsAllDevices = true
        }

        // Entitlements Extraction
        if let entitlements = plist["Entitlements"] as? [String: Any] {
            if let taskAllow = entitlements["get-task-allow"] as? Bool {
                self.isTaskAllowEnabled = taskAllow
            }
            if let appId = entitlements["application-identifier"] as? String {
                self.appIdentifier = appId
            }
            if let groups = entitlements["keychain-access-groups"] as? [String] {
                self.keychainAccessGroups = groups
            }
            var dict: [String: String] = [:]
            for (key, val) in entitlements {
                dict[key] = "\(val)"
            }
            self.rawEntitlements = dict
        }

        // Developer Certificates (X.509 DER Parsing & Fingerprint Hashing)
        if let certs = plist["DeveloperCertificates"] as? [Data], let firstCertData = certs.first {
            let sha1Digest = Insecure.SHA1.hash(data: firstCertData)
            self.certificateSha1 = sha1Digest.map { String(format: "%02X", $0) }.joined(separator: ":")

            let sha256Digest = SHA256.hash(data: firstCertData)
            self.certificateSha256 = sha256Digest.map { String(format: "%02X", $0) }.joined(separator: ":")

            if let secCert = SecCertificateCreateWithData(nil, firstCertData as CFData) {
                if let summary = SecCertificateCopySubjectSummary(secCert) as String? {
                    self.certificateSubject = summary
                }
            }
        }

        // Determine Signing Type
        if trollStoreDetected || profileName.lowercased().contains("trollstore") {
            self.signingType = .trollStore
        } else if self.provisionsAllDevices {
            self.signingType = .enterprise
        } else if let creation = self.creationDate, let expiration = self.expirationDate {
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

    internal nonisolated static func extractPlistXmlData(from data: Data) -> Data? {
        let startMarker = Data("<?xml".utf8)
        let endMarker = Data("</plist>".utf8)
        guard let startRange = data.range(of: startMarker),
              let endRange = data.range(of: endMarker, in: startRange.lowerBound ..< data.endIndex),
              startRange.lowerBound < endRange.upperBound else {
            return nil
        }
        return data[startRange.lowerBound ..< endRange.upperBound]
    }
}
