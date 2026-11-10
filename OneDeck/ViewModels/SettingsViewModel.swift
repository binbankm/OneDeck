//
//  SettingsViewModel.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  State management view model mediating settings & code-signing telemetry.
//

import Foundation
import Observation

@Observable
@MainActor
public final class SettingsViewModel {
    public static let shared = SettingsViewModel()

    private let provisioningProbe = ProvisioningHardwareProbe.shared

    private init() {}

    // MARK: - Code Signing & Provisioning Telemetry
    public var hasProvisionProfile: Bool { provisioningProbe.hasProvisionProfile }
    public var profileName: String { provisioningProbe.profileName }
    public var profileUUID: String { provisioningProbe.profileUUID }
    public var appIdentifier: String { provisioningProbe.appIdentifier }
    public var creationDate: Date? { provisioningProbe.creationDate }
    public var expirationDate: Date? { provisioningProbe.expirationDate }
    public var remainingDays: Int { provisioningProbe.remainingDays }
    public var remainingHours: Int { provisioningProbe.remainingHours }
    public var isExpired: Bool { provisioningProbe.isExpired }
    public var isExpiringSoon: Bool { provisioningProbe.isExpiringSoon }
    public var isTrollStore: Bool { provisioningProbe.isTrollStore }
    public var isTrollStoreSigning: Bool { provisioningProbe.signingType == .trollStore }
    public var signingIconName: String { provisioningProbe.signingType.iconName }
    public var statusText: String { provisioningProbe.statusText }
    public var progressRatio: Double { provisioningProbe.progressRatio }

    public var certificateSubject: String { provisioningProbe.certificateSubject }
    public var certificateSha1: String { provisioningProbe.certificateSha1 }
    public var certificateSha256: String { provisioningProbe.certificateSha256 }
    public var provisionedDevicesCount: Int { provisioningProbe.provisionedDevicesCount }
    public var provisionsAllDevices: Bool { provisioningProbe.provisionsAllDevices }
    public var isTaskAllowEnabled: Bool { provisioningProbe.isTaskAllowEnabled }
    public var keychainAccessGroups: [String] { provisioningProbe.keychainAccessGroups }
    public var rawEntitlements: [String: String] { provisioningProbe.rawEntitlements }

    public func refreshSigningInfo() {
        provisioningProbe.refresh()
    }
}

