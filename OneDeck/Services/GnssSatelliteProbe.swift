//
//  GnssSatelliteProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  GNSS satellite telemetry and geodetic coordinate probe.
//

import CoreLocation
import Foundation

@MainActor
public final class GnssSatelliteProbe: NSObject, CLLocationManagerDelegate {
    public static let shared = GnssSatelliteProbe()

    private var locationManager: CLLocationManager?
    public private(set) var isTracking: Bool = false
    private var onUpdate: ((_ data: GnssHubData) -> Void)?
    private var onAuthorizationChange: ((_ status: CLAuthorizationStatus) -> Void)?
    public private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override private init() {
        super.init()
        let manager = CLLocationManager()
        manager.delegate = self
        self.locationManager = manager
        self.authorizationStatus = manager.authorizationStatus
    }

    public func startTracking(
        isPowerSaving: Bool = false,
        onAuthorizationChange: ((CLAuthorizationStatus) -> Void)? = nil,
        onUpdate: @escaping (GnssHubData) -> Void
    ) {
        self.onUpdate = onUpdate
        self.onAuthorizationChange = onAuthorizationChange

        if locationManager == nil {
            let manager = CLLocationManager()
            manager.delegate = self
            self.locationManager = manager
        }

        guard let manager = locationManager else { return }
        authorizationStatus = manager.authorizationStatus
        onAuthorizationChange?(authorizationStatus)

        manager.desiredAccuracy = isPowerSaving ? kCLLocationAccuracyNearestTenMeters : kCLLocationAccuracyBest
        manager.distanceFilter = isPowerSaving ? 5.0 : kCLDistanceFilterNone

        guard !isTracking else { return }
        self.isTracking = true

        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    public func stopTracking() {
        guard isTracking else { return }
        isTracking = false
        locationManager?.stopUpdatingLocation()
        onUpdate = nil
        onAuthorizationChange = nil
    }

    public nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.authorizationStatus = status
            self.onAuthorizationChange?(status)
            if (status == .authorizedWhenInUse || status == .authorizedAlways) && self.isTracking {
                manager.startUpdatingLocation()
            }
        }
    }

    public nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }

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
    private nonisolated static let piConst = Double.pi
    private nonisolated static let aAxis = 6_378_245.0
    private nonisolated static let eeEccentricity = 0.00669342162296594323

    public nonisolated static func wgs84ToGcj02(lat: Double, lon: Double) -> (Double, Double) {
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

    public nonisolated static func gcj02ToBd09(lat: Double, lon: Double) -> (Double, Double) {
        let x = lon
        let y = lat
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * (piConst * 3000.0 / 180.0))
        let theta = atan2(y, x) + 0.000003 * cos(x * (piConst * 3000.0 / 180.0))
        let bdLon = z * cos(theta) + 0.0065
        let bdLat = z * sin(theta) + 0.006
        return (bdLat, bdLon)
    }

    public nonisolated static func wgs84ToMgrs(lat: Double, lon: Double) -> String {
        guard lat.isFinite && lon.isFinite else { return "--" }
        guard lat >= -80.0 && lat <= 84.0 else {
            return lat > 84.0 ? "UPS N" : "UPS S"
        }

        // Normalize longitude into [-180, 180], keeping +180 in Zone 60
        var normLon = lon.truncatingRemainder(dividingBy: 360.0)
        if normLon > 180.0 { normLon -= 360.0 }
        if normLon < -180.0 { normLon += 360.0 }

        var zone = max(1, min(60, Int(floor((normLon + 180.0) / 6.0)) + 1))

        // Norway & Svalbard UTM grid exceptions
        if lat >= 56.0 && lat < 64.0 && normLon >= 3.0 && normLon < 12.0 {
            zone = 32
        } else if lat >= 72.0 && lat < 84.0 {
            if normLon >= 0.0 && normLon < 9.0 {
                zone = 31
            } else if normLon >= 9.0 && normLon < 21.0 {
                zone = 33
            } else if normLon >= 21.0 && normLon < 33.0 {
                zone = 35
            } else if normLon >= 33.0 && normLon < 42.0 {
                zone = 37
            }
        }

        let latLetters = Array("CDEFGHJKLMNPQRSTUVWX")
        let latIdx = max(0, min(latLetters.count - 1, Int(floor((lat + 80.0) / 8.0))))
        let bandLetter = latLetters[latIdx]

        // WGS84 Ellipsoid Transverse Mercator (UTM) projection
        let a = 6_378_137.0
        let f = 1.0 / 298.257223563
        let e2 = 2.0 * f - f * f
        let e4 = e2 * e2
        let e6 = e4 * e2
        let ePrime2 = e2 / (1.0 - e2)
        let k0 = 0.9996

        let phi = lat * Double.pi / 180.0
        let lambda = normLon * Double.pi / 180.0
        let lonOriginDeg = Double(zone - 1) * 6.0 - 180.0 + 3.0
        let lambda0 = lonOriginDeg * Double.pi / 180.0

        let sinPhi = sin(phi)
        let cosPhi = cos(phi)
        let tanPhi = tan(phi)

        let nVal = a / sqrt(1.0 - e2 * sinPhi * sinPhi)
        let tVal = tanPhi * tanPhi
        let cVal = ePrime2 * cosPhi * cosPhi
        let aCoef = cosPhi * (lambda - lambda0)

        let mVal = a * (
            (1.0 - e2 / 4.0 - 3.0 * e4 / 64.0 - 5.0 * e6 / 256.0) * phi
                - (3.0 * e2 / 8.0 + 3.0 * e4 / 32.0 + 45.0 * e6 / 1024.0) * sin(2.0 * phi)
                + (15.0 * e4 / 256.0 + 45.0 * e6 / 1024.0) * sin(4.0 * phi)
                - (35.0 * e6 / 3072.0) * sin(6.0 * phi)
        )

        let a2 = aCoef * aCoef
        let a3 = a2 * aCoef
        let a4 = a3 * aCoef
        let a5 = a4 * aCoef
        let a6 = a5 * aCoef

        let easting = k0 * nVal * (
            aCoef
                + (1.0 - tVal + cVal) * (a3 / 6.0)
                + (5.0 - 18.0 * tVal + tVal * tVal + 72.0 * cVal - 58.0 * ePrime2) * (a5 / 120.0)
        ) + 500_000.0

        var northing = k0 * (
            mVal + nVal * tanPhi * (
                a2 / 2.0
                    + (5.0 - tVal + 9.0 * cVal + 4.0 * cVal * cVal) * (a4 / 24.0)
                    + (61.0 - 58.0 * tVal + tVal * tVal + 600.0 * cVal - 330.0 * ePrime2) * (a6 / 720.0)
            )
        )
        if lat < 0.0 {
            northing += 10_000_000.0
        }

        // 100km Grid Square Digraph (AA Scheme)
        let colSets = [
            Array("STUVWXYZ"), // zone % 3 == 0 (Set 3/6)
            Array("ABCDEFGH"), // zone % 3 == 1 (Set 1/4)
            Array("JKLMNPQR")  // zone % 3 == 2 (Set 2/5)
        ]
        let rowLetters = Array("ABCDEFGHJKLMNPQRSTUV")

        let e100k = max(1, min(8, Int(floor(easting / 100_000.0))))
        let n100k = Int(floor(northing / 100_000.0))

        let colSet = colSets[zone % 3]
        let colChar = colSet[max(0, min(colSet.count - 1, e100k - 1))]

        let rowOffset = (zone % 2 == 0) ? 5 : 0
        let rowIndex = ((n100k + rowOffset) % 20 + 20) % 20
        let rowChar = rowLetters[rowIndex]

        let eGrid = ((Int(floor(easting)) % 100_000) + 100_000) % 100_000
        let nGrid = ((Int(floor(northing)) % 100_000) + 100_000) % 100_000

        return "\(zone)\(bandLetter) \(colChar)\(rowChar) \(String(format: "%05d %05d", eGrid, nGrid))"
    }

    private nonisolated static func isOutOfChina(lat: Double, lon: Double) -> Bool {
        if lon < 72.004 || lon > 137.8347 { return true }
        if lat < 0.8293 || lat > 55.8271 { return true }
        return false
    }

    private nonisolated static func transformLat(x: Double, y: Double) -> Double {
        var ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x))
        ret += (20.0 * sin(6.0 * x * piConst) + 20.0 * sin(2.0 * x * piConst)) * 2.0 / 3.0
        ret += (20.0 * sin(y * piConst) + 40.0 * sin(y / 3.0 * piConst)) * 2.0 / 3.0
        ret += (160.0 * sin(y / 12.0 * piConst) + 320.0 * sin(y * piConst / 30.0)) * 2.0 / 3.0
        return ret
    }

    private nonisolated static func transformLon(x: Double, y: Double) -> Double {
        var ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x))
        ret += (20.0 * sin(6.0 * x * piConst) + 20.0 * sin(2.0 * x * piConst)) * 2.0 / 3.0
        ret += (20.0 * sin(x * piConst) + 40.0 * sin(x / 3.0 * piConst)) * 2.0 / 3.0
        ret += (150.0 * sin(x / 12.0 * piConst) + 300.0 * sin(x / 30.0 * piConst)) * 2.0 / 3.0
        return ret
    }
}
