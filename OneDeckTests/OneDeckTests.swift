//
//  OneDeckTests.swift
//  OneDeckTests
//
//  Unit tests covering localization resolution, color hex clamping,
//  network counter rollover & OUI lookup, battery log parsing & PD curve,
//  geodesy transforms, and caliper/touch matrix utilities.
//

import CoreBluetooth
import CoreLocation
import Foundation
import SwiftUI
import UIKit
import XCTest
@testable import OneDeck

final class OneDeckTests: XCTestCase {
    func testResolveSystemLanguage() {
        let enChina = L10n.resolveSystemLanguage(
            preferredLanguages: ["en_CN"],
            currentLocale: Locale(identifier: "en_CN")
        )
        XCTAssertFalse(enChina.isZh)
        XCTAssertFalse(enChina.isHant)

        let enDashChina = L10n.resolveSystemLanguage(
            preferredLanguages: ["en-CN"],
            currentLocale: Locale(identifier: "en_CN")
        )
        XCTAssertFalse(enDashChina.isZh)
        XCTAssertFalse(enDashChina.isHant)

        let zhHans = L10n.resolveSystemLanguage(
            preferredLanguages: ["zh-Hans-CN"],
            currentLocale: Locale(identifier: "zh_CN")
        )
        XCTAssertTrue(zhHans.isZh)
        XCTAssertFalse(zhHans.isHant)

        let zhCn = L10n.resolveSystemLanguage(
            preferredLanguages: ["zh_CN"],
            currentLocale: Locale(identifier: "zh_CN")
        )
        XCTAssertTrue(zhCn.isZh)
        XCTAssertFalse(zhCn.isHant)

        let zhHantTw = L10n.resolveSystemLanguage(
            preferredLanguages: ["zh-Hant-TW"],
            currentLocale: Locale(identifier: "zh_TW")
        )
        XCTAssertTrue(zhHantTw.isZh)
        XCTAssertTrue(zhHantTw.isHant)

        let zhHk = L10n.resolveSystemLanguage(
            preferredLanguages: ["zh-HK"],
            currentLocale: Locale(identifier: "zh_HK")
        )
        XCTAssertTrue(zhHk.isZh)
        XCTAssertTrue(zhHk.isHant)

        let zhMo = L10n.resolveSystemLanguage(
            preferredLanguages: ["zh_MO"],
            currentLocale: Locale(identifier: "zh_MO")
        )
        XCTAssertTrue(zhMo.isZh)
        XCTAssertTrue(zhMo.isHant)

        let enUs = L10n.resolveSystemLanguage(
            preferredLanguages: ["en-US"],
            currentLocale: Locale(identifier: "en_US")
        )
        XCTAssertFalse(enUs.isZh)
        XCTAssertFalse(enUs.isHant)

        let fallbackHant = L10n.resolveSystemLanguage(
            preferredLanguages: [],
            currentLocale: Locale(identifier: "zh_Hant_TW")
        )
        XCTAssertTrue(fallbackHant.isZh)
        XCTAssertTrue(fallbackHant.isHant)

        let fallbackHans = L10n.resolveSystemLanguage(
            preferredLanguages: [],
            currentLocale: Locale(identifier: "zh_Hans_CN")
        )
        XCTAssertTrue(fallbackHans.isZh)
        XCTAssertFalse(fallbackHans.isHant)
    }

    func testColorHexConversionAndClamping() {
        XCTAssertEqual(ThemePreset.defaultPreset.hex, "#3B82F6")
        XCTAssertEqual(ThemePreset.emerald.hex, "#00DC82")
        XCTAssertEqual(Color(hex: "#3B82F6").toHex(), "#3B82F6")
        XCTAssertEqual(Color(hex: "#00DC82").toHex(), "#00DC82")
        XCTAssertEqual(Color(hex: "F0A").toHex(), "#FF00AA")

        // Display P3 saturated primary can yield extended sRGB components > 1.0 or < 0.0; toHex() must clamp cleanly
        let p3Red = Color(.displayP3, red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0).toHex()
        XCTAssertEqual(p3Red.count, 7)
        XCTAssertTrue(p3Red.hasPrefix("#"))

        let extended = Color(uiColor: UIColor(red: 1.35, green: -0.25, blue: 0.5, alpha: 1.0))
        XCTAssertEqual(extended.toHex(), "#FF0080")

        XCTAssertEqual(Color.normalizedValidHex("3b82f6"), "#3B82F6")
        XCTAssertEqual(Color.normalizedValidHex(" #f0a "), "#F0A")
        XCTAssertEqual(Color.normalizedValidHex("80abcdef"), "#80ABCDEF")
        XCTAssertNil(Color.normalizedValidHex(""))
        XCTAssertNil(Color.normalizedValidHex("#12345"))
        XCTAssertNil(Color.normalizedValidHex("not-hex"))
        XCTAssertEqual(Color(hex: "ZZZZZZ").toHex(), "#3B82F6")
    }

    func testThemeContrastingForegroundAndCoreLoad() {
        XCTAssertEqual(Theme.contrastingForeground(for: Color(hex: "#111114")).toHex(), "#FFFFFF")
        XCTAssertEqual(Theme.contrastingForeground(for: .black).toHex(), "#FFFFFF")
        XCTAssertEqual(Theme.contrastingForeground(for: .white).toHex(), "#000000")
        XCTAssertEqual(Theme.contrastingForeground(for: Color(hex: "#EAB308")).toHex(), "#000000")

        let load = CoreLoad(user: UInt32.max, system: 1, idle: 2, nice: 3)
        XCTAssertEqual(load.total, UInt64(UInt32.max) + 6)
    }

    func testComputeCounterDelta() {
        XCTAssertEqual(SystemViewModel.computeCounterDelta(current: 1500, previous: 500), 1000)
        XCTAssertEqual(SystemViewModel.computeCounterDelta(current: 42, previous: 42), 0)
        XCTAssertEqual(SystemViewModel.computeCounterDelta(current: 0x0000_0100, previous: 0xFFFF_FF00), 512)
        XCTAssertEqual(SystemViewModel.computeCounterDelta(current: 0, previous: UInt32.max), 1)
        // Drop exceeding 2 GiB indicates interface counter reset rather than 32-bit wraparound
        XCTAssertEqual(SystemViewModel.computeCounterDelta(current: 123, previous: 0x1000_0000), 123)
    }

    func testNetworkKernelProbeAndRoutingHelpers() {
        XCTAssertEqual(NetworkKernelProbe.lookupMacVendor(mac: "a4:83:e7:11:22:33"), "Apple")
        XCTAssertEqual(NetworkKernelProbe.lookupMacVendor(mac: "A4:83:E7:00:00:01"), "Apple")
        XCTAssertEqual(NetworkKernelProbe.lookupMacVendor(mac: "02:11:22:33:44:55"), "Private MAC")
        XCTAssertEqual(NetworkKernelProbe.lookupMacVendor(mac: "da:11:22:33:44:55"), "Private MAC")
        XCTAssertEqual(NetworkKernelProbe.lookupMacVendor(mac: "00:aa:bb:cc:dd:ee"), "LAN Host")

        let wifi7 = NetworkKernelProbe.detectWifiHardware(machine: "iPhone18,1")
        XCTAssertEqual(wifi7.generation, "Wi-Fi 7")
        XCTAssertEqual(wifi7.standard, "802.11be")

        let wifi6e = NetworkKernelProbe.detectWifiHardware(machine: "iPhone16,1")
        XCTAssertEqual(wifi6e.generation, "Wi-Fi 6E")
        XCTAssertEqual(wifi6e.standard, "802.11ax 6GHz")

        let wifi5 = NetworkKernelProbe.detectWifiHardware(machine: "iPhone10,3")
        XCTAssertEqual(wifi5.generation, "Wi-Fi 5")
        XCTAssertEqual(wifi5.standard, "802.11ac")

        XCTAssertEqual(NetworkViewModel.deriveDefaultGateway(from: "192.168.50.88"), "192.168.50.1")
        XCTAssertEqual(NetworkViewModel.deriveDefaultGateway(from: "--"), "--")
        XCTAssertEqual(NetworkViewModel.deriveBroadcast(ip: "10.0.1.5", mask: "255.255.0.0"), "10.0.255.255")
        XCTAssertEqual(NetworkViewModel.deriveBroadcast(ip: "192.168.1.42", mask: "255.255.255.0"), "192.168.1.255")
    }

    func testBatteryAnalyticsParsingAndDynamicPower() {
        let vm = BatteryViewModel.shared
        let savedRecordData = UserDefaults.standard.data(forKey: "onedeck_battery_analytics_json")
        let previousRecord = vm.analyticsRecord
        defer {
            vm.analyticsRecord = previousRecord
            if let savedRecordData {
                UserDefaults.standard.set(savedRecordData, forKey: "onedeck_battery_analytics_json")
            } else {
                UserDefaults.standard.removeObject(forKey: "onedeck_battery_analytics_json")
            }
        }

        let ipsIntHealth = """
        {
          "last_value_CycleCount": 148,
          "last_value_NominalChargeCapacity": 3120,
          "MaximumFCC": 3274,
          "last_value_MaximumCapacityPercent": 95
        }
        """
        switch vm.parseAnalyticsText(ipsIntHealth, sourceName: "Analytics-Test.ips") {
        case let .success(record):
            XCTAssertEqual(record.cycleCount, 148)
            XCTAssertEqual(record.nominalChargeCapacityMah, 3120)
            XCTAssertEqual(record.maximumFccMah, 3274)
            XCTAssertEqual(record.healthPercent, 95.0, accuracy: 0.01)
            XCTAssertEqual(record.sourceFileName, "Analytics-Test.ips")
        case let .failure(error):
            XCTFail("Expected success parsing valid IPS payload, got error: \(error)")
        }

        let ipsDecimalHealth = """
        {
          "CycleCount": 312,
          "NominalChargeCapacity": 4010,
          "MaximumFCC": 4422,
          "MaximumCapacityPercent": 90.7
        }
        """
        switch vm.parseAnalyticsText(ipsDecimalHealth, sourceName: "Analytics-Decimal.ips") {
        case let .success(record):
            XCTAssertEqual(record.cycleCount, 312)
            XCTAssertEqual(record.healthPercent, 90.7, accuracy: 0.01)
        case let .failure(error):
            XCTFail("Expected success parsing decimal health IPS payload, got error: \(error)")
        }

        let malformed = "{ \"unrelated_metric\": 42 }"
        switch vm.parseAnalyticsText(malformed, sourceName: "Invalid.ips") {
        case .success:
            XCTFail("Expected failure on malformed IPS payload missing battery metrics")
        case .failure:
            break
        }

        let missingCycle = "{ \"MaximumCapacityPercent\": 94 }"
        switch vm.parseAnalyticsText(missingCycle, sourceName: "NoCycle.ips") {
        case .success:
            XCTFail("Expected failure when CycleCount is missing even if MaximumCapacityPercent exists")
        case .failure:
            break
        }

        XCTAssertEqual(BatteryViewModel.lookupDesignCapacity(identifier: "iPhone17,1"), 3582)
        XCTAssertEqual(BatteryViewModel.lookupDesignCapacity(identifier: "iPhone16,2"), 4422)
        XCTAssertEqual(BatteryViewModel.lookupDesignCapacity(identifier: "UnknownDevice99,1"), 3000)

        XCTAssertEqual(HardwareBatteryProbe.computeDynamicPDWattage(ratedWatts: 20, batteryLevel: 1.0, temperatureCelsius: 25.0), 0.0)
        XCTAssertEqual(HardwareBatteryProbe.computeDynamicPDWattage(ratedWatts: 20, batteryLevel: 0.25, temperatureCelsius: 25.0), 18.4, accuracy: 0.01)
        XCTAssertEqual(HardwareBatteryProbe.computeDynamicPDWattage(ratedWatts: 20, batteryLevel: 0.80, temperatureCelsius: 25.0), 7.0, accuracy: 0.01)
        XCTAssertEqual(HardwareBatteryProbe.computeDynamicPDWattage(ratedWatts: 20, batteryLevel: 0.25, temperatureCelsius: 40.5), 14.7, accuracy: 0.01)
    }

    func testGnssCoordinateTransformsAndMgrs() {
        let beijingLat = 39.9042
        let beijingLon = 116.4074
        let (gcjLat, gcjLon) = GnssSatelliteProbe.wgs84ToGcj02(lat: beijingLat, lon: beijingLon)
        XCTAssertGreaterThan(abs(gcjLat - beijingLat), 0.0001)
        XCTAssertGreaterThan(abs(gcjLon - beijingLon), 0.0001)

        let sfLat = 37.7749
        let sfLon = -122.4194
        let (sfOutLat, sfOutLon) = GnssSatelliteProbe.wgs84ToGcj02(lat: sfLat, lon: sfLon)
        XCTAssertEqual(sfOutLat, sfLat, accuracy: 1e-9)
        XCTAssertEqual(sfOutLon, sfLon, accuracy: 1e-9)

        let (bdLat, bdLon) = GnssSatelliteProbe.gcj02ToBd09(lat: gcjLat, lon: gcjLon)
        XCTAssertGreaterThan(bdLat, gcjLat)
        XCTAssertGreaterThan(bdLon, gcjLon)

        let mgrs180 = GnssSatelliteProbe.wgs84ToMgrs(lat: 10.0, lon: 180.0)
        XCTAssertTrue(mgrs180.hasPrefix("60P "), "Expected Zone 60 at +180 longitude, got \(mgrs180)")

        let mgrsNorway = GnssSatelliteProbe.wgs84ToMgrs(lat: 60.0, lon: 5.0)
        XCTAssertTrue(mgrsNorway.hasPrefix("32V "), "Expected Norway Zone 32V, got \(mgrsNorway)")

        let mgrsSvalbard = GnssSatelliteProbe.wgs84ToMgrs(lat: 78.0, lon: 15.0)
        XCTAssertTrue(mgrsSvalbard.hasPrefix("33X "), "Expected Svalbard Zone 33X, got \(mgrsSvalbard)")

        let mgrsBeijing = GnssSatelliteProbe.wgs84ToMgrs(lat: beijingLat, lon: beijingLon)
        XCTAssertTrue(mgrsBeijing.hasPrefix("50S "), "Expected Beijing Zone 50S, got \(mgrsBeijing)")

        XCTAssertEqual(GnssSatelliteProbe.wgs84ToMgrs(lat: 85.0, lon: 0.0), "UPS N")
        XCTAssertEqual(GnssSatelliteProbe.wgs84ToMgrs(lat: -82.0, lon: 0.0), "UPS S")
        XCTAssertEqual(GnssSatelliteProbe.wgs84ToMgrs(lat: Double.nan, lon: 0.0), "--")
    }

    func testCaliperFormattingAndTouchMatrixBounds() {
        XCTAssertEqual(ToolsViewModel.formatCaliperMeasurement(mm: 25.4, unit: .mm), "25.4 mm")
        XCTAssertEqual(ToolsViewModel.formatCaliperMeasurement(mm: 25.4, unit: .cm), "2.54 cm")
        XCTAssertEqual(ToolsViewModel.formatCaliperMeasurement(mm: 25.4, unit: .inch), "1.000 in")

        let tools = ToolsViewModel.shared
        let savedCells = tools.touchMatrixCells
        let savedRecords = tools.caliperRecords
        let savedRawSpan = tools.caliperRawSpanMm
        let savedTareOffset = tools.caliperTareOffsetMm
        let savedUnit = tools.caliperUnit
        let savedDefaults = UserDefaults.standard.data(forKey: "onedeck_caliper_records")
        defer {
            tools.touchMatrixCells = savedCells
            tools.caliperRecords = savedRecords
            tools.setCaliperRawMm(savedRawSpan)
            tools.caliperTareOffsetMm = savedTareOffset
            tools.caliperUnit = savedUnit
            if let savedDefaults {
                UserDefaults.standard.set(savedDefaults, forKey: "onedeck_caliper_records")
            } else {
                UserDefaults.standard.removeObject(forKey: "onedeck_caliper_records")
            }
        }

        tools.resetTouchMatrix()
        XCTAssertEqual(tools.touchMatrixPassedCount, 0)

        tools.touchMatrixHit(at: -1)
        tools.touchMatrixHit(at: 80)
        XCTAssertEqual(tools.touchMatrixPassedCount, 0)

        tools.touchMatrixHit(at: 0)
        tools.touchMatrixHit(at: 79)
        tools.touchMatrixHit(at: 0)
        XCTAssertEqual(tools.touchMatrixPassedCount, 2)

        tools.resetTouchMatrix()
        XCTAssertEqual(tools.touchMatrixPassedCount, 0)

        tools.caliperUnit = .mm
        tools.resetTare()
        tools.setCaliperRawMm(50.0)
        tools.tareCaliper()
        XCTAssertEqual(tools.caliperCurrentMm, 0.0, accuracy: 0.001)

        tools.setCaliperRawMm(75.4)
        XCTAssertEqual(tools.caliperCurrentMm, 25.4, accuracy: 0.001)

        tools.saveCurrentCaliperMeasurement()
        XCTAssertEqual(tools.caliperRecords.first?.valueMm ?? -1, 25.4, accuracy: 0.001)

        tools.resetTare()
        XCTAssertEqual(tools.caliperCurrentMm, 75.4, accuracy: 0.001)
    }

    @MainActor
    func testViewModelMvvMBoundaryHelpers() {
        let tools = ToolsViewModel.shared
        let savedBleState = tools.bleRadar.bluetoothState
        let savedGnssAuth = tools.gnssAuthStatus
        let savedCompassAuth = tools.compassAuthStatus
        defer {
            tools.bleRadar.bluetoothState = savedBleState
            tools.gnssAuthStatus = savedGnssAuth
            tools.compassAuthStatus = savedCompassAuth
        }

        tools.bleRadar.bluetoothState = .unauthorized
        XCTAssertEqual(tools.bleBannerStatus, .unauthorized)

        tools.bleRadar.bluetoothState = .poweredOff
        XCTAssertEqual(tools.bleBannerStatus, .poweredOff)

        tools.bleRadar.bluetoothState = .unsupported
        XCTAssertEqual(tools.bleBannerStatus, .unsupported)

        tools.bleRadar.bluetoothState = .poweredOn
        XCTAssertEqual(tools.bleBannerStatus, .normal)

        tools.gnssAuthStatus = .denied
        XCTAssertTrue(tools.isGnssLocationDenied)
        tools.gnssAuthStatus = .restricted
        XCTAssertTrue(tools.isGnssLocationDenied)
        tools.gnssAuthStatus = .authorizedWhenInUse
        XCTAssertFalse(tools.isGnssLocationDenied)

        tools.compassAuthStatus = .denied
        XCTAssertTrue(tools.isCompassLocationDenied)
        tools.compassAuthStatus = .restricted
        XCTAssertTrue(tools.isCompassLocationDenied)
        tools.compassAuthStatus = .authorizedAlways
        XCTAssertFalse(tools.isCompassLocationDenied)

        let settings = SettingsViewModel.shared
        let probe = ProvisioningHardwareProbe.shared
        XCTAssertEqual(settings.hasProvisionProfile, probe.hasProvisionProfile)
        XCTAssertEqual(settings.isTrollStoreSigning, probe.signingType == .trollStore)
        XCTAssertEqual(settings.signingIconName, probe.signingType.iconName)
        XCTAssertEqual(settings.statusText, probe.statusText)
    }
}

