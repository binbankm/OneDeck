//
//  GnssSatelliteProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  GNSS satellite telemetry and geodetic coordinate probe.
//

import CoreLocation
import Foundation

public final class GnssSatelliteProbe: NSObject, CLLocationManagerDelegate, @unchecked Sendable {
    public static let shared = GnssSatelliteProbe()

    private var locationManager: CLLocationManager?
    private var isTracking: Bool = false
    private var onUpdate: ((_ data: GnssHubData) -> Void)?

    override private init() {
        super.init()
    }

    public func startTracking(onUpdate: @escaping (GnssHubData) -> Void) {
        guard !isTracking else { return }
        self.onUpdate = onUpdate
        self.isTracking = true

        let manager = CLLocationManager()
        manager.desiredAccuracy = AppState.shared.isSensorPowerSaving ? kCLLocationAccuracyNearestTenMeters : kCLLocationAccuracyBest
        manager.distanceFilter = AppState.shared.isSensorPowerSaving ? 5.0 : kCLDistanceFilterNone
        manager.delegate = self
        self.locationManager = manager

        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    public func stopTracking() {
        guard isTracking else { return }
        isTracking = false
        locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
        locationManager = nil
        onUpdate = nil
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if isTracking {
                manager.startUpdatingLocation()
            }
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard isTracking, let loc = locations.last else { return }

        let lat = loc.coordinate.latitude
        let lon = loc.coordinate.longitude
        let altAmsl = loc.altitude
        let hAcc = max(0.0, loc.horizontalAccuracy)
        let vAcc = max(0.0, loc.verticalAccuracy)
        let speedKmh = max(0.0, loc.speed * 3.6)
        let course = max(0.0, loc.course)

        // Estimated Dilution of Precision (DOP)
        // Theoretical relationship: CEP = HDOP * User Equivalent Range Error (UERE ≈ 4.5m)
        let hdop = max(0.6, hAcc / 4.5)
        let vdop = max(0.8, vAcc / 4.5)

        // Multi-Standard Coordinate Transforms
        let (gcjLat, gcjLon) = Self.wgs84ToGcj02(lat: lat, lon: lon)
        let (bdLat, bdLon) = Self.gcj02ToBd09(lat: gcjLat, lon: gcjLon)
        let mgrs = Self.wgs84ToMgrs(lat: lat, lon: lon)

        let wgsStr = String(format: "%.6f°, %.6f°", lat, lon)
        let gcjStr = String(format: "%.6f°, %.6f°", gcjLat, gcjLon)
        let bdStr = String(format: "%.6f°, %.6f°", bdLat, bdLon)

        let result = GnssHubData(
            latitude: lat,
            longitude: lon,
            altitudeAmsl: altAmsl,
            horizontalAccuracyM: hAcc,
            verticalAccuracyM: vAcc,
            speedKmh: speedKmh,
            courseDeg: course,
            hdop: hdop,
            vdop: vdop,
            wgs84Formatted: wgsStr,
            gcj02Formatted: gcjStr,
            bd09Formatted: bdStr,
            mgrsFormatted: mgrs,
            isFixAcquired: hAcc > 0 && hAcc < 100.0
        )

        Task { @MainActor [weak self] in
            guard let self, self.isTracking else { return }
            self.onUpdate?(result)
        }
    }

    // MARK: - Geodetic Transformations (Krasovsky 1940 & Obfuscation Mathematics)
    private static let piConst = Double.pi
    private static let aAxis = 6_378_245.0
    private static let eeEccentricity = 0.00669342162296594323

    public static func wgs84ToGcj02(lat: Double, lon: Double) -> (Double, Double) {
        if isOutOfChina(lat: lat, lon: lon) { return (lat, lon) }

        var dLat = transformLat(x: lon - 105.0, y: lat - 35.0)
        var dLon = transformLon(x: lon - 105.0, y: lat - 35.0)
        let radLat = lat / 180.0 * piConst
        var magic = sin(radLat)
        magic = 1.0 - eeEccentricity * magic * magic
        let sqrtMagic = sqrt(magic)
        dLat = (dLat * 180.0) / ((aAxis * (1.0 - eeEccentricity)) / (magic * sqrtMagic) * piConst)
        dLon = (dLon * 180.0) / (aAxis / sqrtMagic * cos(radLat) * piConst)

        return (lat + dLat, lon + dLon)
    }

    public static func gcj02ToBd09(lat: Double, lon: Double) -> (Double, Double) {
        let x = lon
        let y = lat
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * (piConst * 3000.0 / 180.0))
        let theta = atan2(y, x) + 0.000003 * cos(x * (piConst * 3000.0 / 180.0))
        let bdLon = z * cos(theta) + 0.0065
        let bdLat = z * sin(theta) + 0.006
        return (bdLat, bdLon)
    }

    public static func wgs84ToMgrs(lat: Double, lon: Double) -> String {
        // Universal Transverse Mercator (UTM) Zone Computation
        let zone = Int((lon + 180.0) / 6.0) + 1
        let latLetters = "CDEFGHJKLMNPQRSTUVWX"
        let latIdx = max(0, min(19, Int((lat + 80.0) / 8.0)))
        let letter = latLetters[latLetters.index(latLetters.startIndex, offsetBy: latIdx)]

        let easting = Int(abs(lon).truncatingRemainder(dividingBy: 6.0) * 100_000) % 100_000
        let northing = Int(abs(lat).truncatingRemainder(dividingBy: 8.0) * 100_000) % 100_000

        return "\(zone)\(letter) \(String(format: "%05d %05d", easting, northing))"
    }

    private static func isOutOfChina(lat: Double, lon: Double) -> Bool {
        if lon < 72.004 || lon > 137.8347 { return true }
        if lat < 0.8293 || lat > 55.8271 { return true }
        return false
    }

    private static func transformLat(x: Double, y: Double) -> Double {
        var ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x))
        ret += (20.0 * sin(6.0 * x * piConst) + 20.0 * sin(2.0 * x * piConst)) * 2.0 / 3.0
        ret += (20.0 * sin(y * piConst) + 40.0 * sin(y / 3.0 * piConst)) * 2.0 / 3.0
        ret += (160.0 * sin(y / 12.0 * piConst) + 320.0 * sin(y * piConst / 30.0)) * 2.0 / 3.0
        return ret
    }

    private static func transformLon(x: Double, y: Double) -> Double {
        var ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x))
        ret += (20.0 * sin(6.0 * x * piConst) + 20.0 * sin(2.0 * x * piConst)) * 2.0 / 3.0
        ret += (20.0 * sin(x * piConst) + 40.0 * sin(x / 3.0 * piConst)) * 2.0 / 3.0
        ret += (150.0 * sin(x / 12.0 * piConst) + 300.0 * sin(x / 30.0 * piConst)) * 2.0 / 3.0
        return ret
    }
}
