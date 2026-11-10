//
//  MotionHardwareProbe.swift
//  OneDeck
//
//  Created for OneDeck - iOS 17.0+
//  CoreMotion telemetry probe for gyroscope, accelerometer, and magnetometer.
//

import CoreLocation
import CoreMotion
import Foundation

@MainActor
public final class MotionHardwareProbe: NSObject, CLLocationManagerDelegate {
    public static let shared = MotionHardwareProbe()

    // MARK: - Persistence Keys
    private enum Keys {
        static let tareRoll = "onedeck_level_tare_roll"
        static let tarePitch = "onedeck_level_tare_pitch"
        static let tareVertical = "onedeck_level_tare_vertical"
    }

    let motionManager = CMMotionManager()
    private let altimeter = CMAltimeter()
    private var locationManager: CLLocationManager?
    private var compassHandler: ((CompassData) -> Void)?
    private var compassAuthHandler: ((CLAuthorizationStatus) -> Void)?
    private var compassEnableGps: Bool = false
    private var altimeterRetryWorkItem: DispatchWorkItem?

    // Hardware Capability & Authorization State
    public var isDeviceMotionAvailable: Bool { motionManager.isDeviceMotionAvailable }
    public var isMagnetometerAvailable: Bool { motionManager.isMagnetometerAvailable }
    public var isAltimeterAvailable: Bool { CMAltimeter.isRelativeAltitudeAvailable() }
    public var isHeadingHardwareAvailable: Bool { CLLocationManager.headingAvailable() }
    public private(set) var compassAuthStatus: CLAuthorizationStatus = .notDetermined

    // Motion State
    private(set) var isMotionActive: Bool = false
    private(set) var isMagnetometerActive: Bool = false
    private(set) var isAltimeterActive: Bool = false
    private(set) var isCompassActive: Bool = false

    // Spirit Level Calibration & Override
    public var orientationOverride: SpiritLevelOrientation?
    private var tareRollDeg: Double = 0.0
    private var tarePitchDeg: Double = 0.0
    private var tareVerticalDeg: Double = 0.0
    private var lastRawRollDeg: Double = 0.0
    private var lastRawPitchDeg: Double = 0.0
    private var lastRawVerticalDeg: Double = 0.0
    public private(set) var isSpiritLevelCalibrated: Bool = false

    // Smoothing & Baseline
    private var lastAltitudeMeters: Double = 0.0
    private var lastAltitudeTimestamp: Date = .init()
    private var lastCompassData = CompassData()

    override private init() {
        super.init()
        let defaults = UserDefaults.standard
        if defaults.object(forKey: Keys.tareRoll) != nil ||
            defaults.object(forKey: Keys.tarePitch) != nil ||
            defaults.object(forKey: Keys.tareVertical) != nil {
            self.tareRollDeg = defaults.double(forKey: Keys.tareRoll)
            self.tarePitchDeg = defaults.double(forKey: Keys.tarePitch)
            self.tareVerticalDeg = defaults.double(forKey: Keys.tareVertical)
            self.isSpiritLevelCalibrated = true
        }
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.headingFilter = 1.0
        manager.delegate = self
        self.locationManager = manager
        self.compassAuthStatus = manager.authorizationStatus
    }

    public func calibrateSpiritLevel() {
        tareRollDeg = lastRawRollDeg
        tarePitchDeg = lastRawPitchDeg
        tareVerticalDeg = lastRawVerticalDeg
        isSpiritLevelCalibrated = true
        UserDefaults.standard.set(tareRollDeg, forKey: Keys.tareRoll)
        UserDefaults.standard.set(tarePitchDeg, forKey: Keys.tarePitch)
        UserDefaults.standard.set(tareVerticalDeg, forKey: Keys.tareVertical)
    }

    public func resetSpiritLevelCalibration() {
        tareRollDeg = 0.0
        tarePitchDeg = 0.0
        tareVerticalDeg = 0.0
        isSpiritLevelCalibrated = false
        UserDefaults.standard.removeObject(forKey: Keys.tareRoll)
        UserDefaults.standard.removeObject(forKey: Keys.tarePitch)
        UserDefaults.standard.removeObject(forKey: Keys.tareVertical)
    }

    // MARK: - 1. Spirit Level & Inclinometer (Adaptive Rate: 12Hz Preview / 60Hz Workspace)
    public func startMotionUpdates(interval: TimeInterval = 1.0 / 60.0, handler: @escaping (SpiritLevelData) -> Void) {
        guard motionManager.isDeviceMotionAvailable else { return }

        let effectiveInterval = AppState.shared.isSensorPowerSaving ? max(interval, 1.0 / 24.0) : interval
        motionManager.deviceMotionUpdateInterval = effectiveInterval
        isMotionActive = true

        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] motion, error in
            guard let self, let motion, error == nil else { return }

            let rawRollDeg = motion.attitude.roll * (180.0 / .pi)
            let rawPitchDeg = motion.attitude.pitch * (180.0 / .pi)
            self.lastRawRollDeg = rawRollDeg
            self.lastRawPitchDeg = rawPitchDeg

            let rollDeg = Self.wrapDegrees(rawRollDeg - self.tareRollDeg)
            let pitchDeg = Self.wrapDegrees(rawPitchDeg - self.tarePitchDeg)

            // Combined tilt angle relative to gravity vector (gimbal-lock-free in vertical upright orientation)
            let gx = motion.gravity.x
            let gy = motion.gravity.y
            let gz = motion.gravity.z
            let totalG = max(0.001, sqrt(gx * gx + gy * gy + gz * gz))
            let rawVerticalDeg = Self.computeVerticalTiltDegrees(gx: gx, gy: gy)
            self.lastRawVerticalDeg = rawVerticalDeg

            // Phone orientation determination (respect manual override when active):
            let isAutoVerticalWall = abs(gz) < 0.28 && (abs(gy) > 0.80 || abs(gx) > 0.80)
            let orientation: SpiritLevelOrientation = self.orientationOverride ?? (isAutoVerticalWall ? .vertical : .flat)
            let isVerticalWall = (orientation == .vertical)

            let tiltDeg: Double
            let outRollDeg: Double
            let outPitchDeg: Double
            let isLevel: Bool

            if isVerticalWall {
                let calibratedVertical = Self.wrapDegrees(rawVerticalDeg - self.tareVerticalDeg)
                tiltDeg = min(90.0, abs(calibratedVertical))
                outRollDeg = calibratedVertical
                outPitchDeg = pitchDeg
                isLevel = tiltDeg <= 0.35
            } else {
                // 2D surface / inclinometer mode:
                if self.isSpiritLevelCalibrated {
                    let rRad = (rollDeg * .pi) / 180.0
                    let pRad = (pitchDeg * .pi) / 180.0
                    let cosCombined = max(-1.0, min(1.0, cos(rRad) * cos(pRad)))
                    tiltDeg = acos(cosCombined) * (180.0 / .pi)
                } else {
                    let xyMagnitude = sqrt(gx * gx + gy * gy)
                    tiltDeg = asin(min(1.0, xyMagnitude / totalG)) * (180.0 / .pi)
                }
                outRollDeg = rollDeg
                outPitchDeg = pitchDeg
                isLevel = tiltDeg <= 0.35
            }

            // Slope percentage (rise over run) - safe bounded calculation
            let safeTilt = min(89.5, max(0.0, tiltDeg))
            let radForSlope = (safeTilt * .pi) / 180.0
            let rawSlope = tan(radForSlope) * 100.0
            let slope = rawSlope.isFinite ? min(999.0, max(0.0, rawSlope)) : 999.0

            let data = SpiritLevelData(
                rollDegrees: outRollDeg,
                pitchDegrees: outPitchDeg,
                tiltDegrees: tiltDeg,
                isLevel: isLevel,
                orientation: orientation,
                slopePercent: slope
            )

            handler(data)
        }
    }

    internal nonisolated static func computeVerticalTiltDegrees(gx: Double, gy: Double) -> Double {
        if abs(gx) > abs(gy) {
            return atan2(-gy, abs(gx)) * (180.0 / .pi)
        } else {
            return atan2(gx, max(0.0001, abs(gy))) * (180.0 / .pi)
        }
    }

    private nonisolated static func wrapDegrees(_ deg: Double) -> Double {
        var wrapped = (deg + 180.0).truncatingRemainder(dividingBy: 360.0)
        if wrapped < 0.0 {
            wrapped += 360.0
        }
        return wrapped - 180.0
    }

    public func stopMotionUpdates() {
        guard isMotionActive else { return }
        motionManager.stopDeviceMotionUpdates()
        isMotionActive = false
    }

    public func setMotionInterval(_ interval: TimeInterval) {
        guard isMotionActive else { return }
        motionManager.deviceMotionUpdateInterval = interval
    }

    // MARK: - 2. Magnetometer & Metal Detector (Adaptive Rate: 10Hz Preview / 30Hz Workspace)
    public func startMagnetometerUpdates(interval: TimeInterval = 1.0 / 30.0, handler: @escaping (Double, Double, Double, Double) -> Void) {
        guard motionManager.isMagnetometerAvailable else { return }

        let effectiveInterval = AppState.shared.isSensorPowerSaving ? max(interval, 1.0 / 15.0) : interval
        motionManager.magnetometerUpdateInterval = effectiveInterval
        isMagnetometerActive = true

        motionManager.startMagnetometerUpdates(to: .main) { [weak self] data, error in
            guard self != nil, let data, error == nil else { return }

            let x = data.magneticField.x
            let y = data.magneticField.y
            let z = data.magneticField.z
            let total = sqrt(x * x + y * y + z * z)

            handler(x, y, z, total)
        }
    }

    public func stopMagnetometerUpdates() {
        guard isMagnetometerActive else { return }
        motionManager.stopMagnetometerUpdates()
        isMagnetometerActive = false
    }

    public func setMagnetometerInterval(_ interval: TimeInterval) {
        guard isMagnetometerActive else { return }
        motionManager.magnetometerUpdateInterval = interval
    }

    // MARK: - 3. Barometer & Relative Altimeter
    public func startAltimeterUpdates(
        onStatus: ((Bool) -> Void)? = nil,
        handler: @escaping (Double, Double, Double, PressureTrend) -> Void
    ) {
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            onStatus?(false)
            return
        }
        guard !isAltimeterActive else {
            onStatus?(true)
            return
        }

        isAltimeterActive = true
        lastAltitudeTimestamp = Date()
        lastAltitudeMeters = 0.0

        altimeter.startRelativeAltitudeUpdates(to: .main) { [weak self] data, error in
            guard let self, self.isAltimeterActive else { return }
            if error != nil {
                self.isAltimeterActive = false
                let authStatus = CMAltimeter.authorizationStatus()
                if authStatus == .notDetermined {
                    self.scheduleAltimeterRetry(onStatus: onStatus, handler: handler)
                } else {
                    onStatus?(false)
                }
                return
            }
            guard let data else { return }
            onStatus?(true)

            // Pressure from kPa to hPa (1 kPa = 10 hPa)
            let pressureHpa = data.pressure.doubleValue * 10.0
            let altitudeM = data.relativeAltitude.doubleValue

            // Compute vertical rate of climb (m/s)
            let now = Date()
            let timeDelta = max(0.1, now.timeIntervalSince(self.lastAltitudeTimestamp))
            let altDelta = altitudeM - self.lastAltitudeMeters
            let verticalSpeed = altDelta / timeDelta

            self.lastAltitudeMeters = altitudeM
            self.lastAltitudeTimestamp = now

            // Determine trend
            let trend: PressureTrend = if verticalSpeed > 0.05 {
                .falling // going up means lower atmospheric pressure
            } else if verticalSpeed < -0.05 {
                .rising // going down means higher atmospheric pressure
            } else {
                .steady
            }

            handler(pressureHpa, altitudeM, verticalSpeed, trend)
        }
    }

    private func scheduleAltimeterRetry(
        onStatus: ((Bool) -> Void)? = nil,
        handler: @escaping (Double, Double, Double, PressureTrend) -> Void
    ) {
        altimeterRetryWorkItem?.cancel()
        let item = DispatchWorkItem { [weak self] in
            guard let self, !self.isAltimeterActive else { return }
            let status = CMAltimeter.authorizationStatus()
            if status == .authorized || status == .notDetermined {
                self.startAltimeterUpdates(onStatus: onStatus, handler: handler)
            } else {
                onStatus?(false)
            }
        }
        altimeterRetryWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: item)
    }

    public func stopAltimeterUpdates() {
        altimeterRetryWorkItem?.cancel()
        altimeterRetryWorkItem = nil
        guard isAltimeterActive else { return }
        altimeter.stopRelativeAltitudeUpdates()
        isAltimeterActive = false
    }

    // MARK: - 4. 3D Electronic Compass & Azimuth Heading (GPS on Demand)
    public func startCompassUpdates(
        enableGpsLocation: Bool = false,
        onAuthorizationChange: ((CLAuthorizationStatus) -> Void)? = nil,
        handler: @escaping (CompassData) -> Void
    ) {
        self.compassHandler = handler
        self.compassAuthHandler = onAuthorizationChange
        self.compassEnableGps = enableGpsLocation
        self.isCompassActive = true

        if locationManager == nil {
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            manager.headingFilter = 1.0
            manager.delegate = self
            self.locationManager = manager
        }

        if let manager = locationManager {
            compassAuthStatus = manager.authorizationStatus
            onAuthorizationChange?(compassAuthStatus)
            if enableGpsLocation {
                manager.requestWhenInUseAuthorization()
            }
            if CLLocationManager.headingAvailable() {
                manager.startUpdatingHeading()
            }
            if enableGpsLocation {
                manager.desiredAccuracy = kCLLocationAccuracyBest
                manager.startUpdatingLocation()
            } else {
                manager.stopUpdatingLocation()
            }
        }
    }

    public func setCompassGpsActive(_ active: Bool) {
        compassEnableGps = active
        guard isCompassActive else { return }
        if active {
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        } else {
            locationManager?.stopUpdatingLocation()
        }
    }

    public func stopCompassUpdates() {
        guard isCompassActive else { return }
        locationManager?.stopUpdatingHeading()
        locationManager?.stopUpdatingLocation()
        compassHandler = nil
        compassAuthHandler = nil
        compassEnableGps = false
        isCompassActive = false
    }

    // CLLocationManagerDelegate
    public nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.compassAuthStatus = status
            self.compassAuthHandler?(status)
            if (status == .authorizedWhenInUse || status == .authorizedAlways) && self.isCompassActive {
                if CLLocationManager.headingAvailable() {
                    manager.startUpdatingHeading()
                }
                if self.compassEnableGps {
                    manager.startUpdatingLocation()
                }
            }
        }
    }

    public nonisolated func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let mag = newHeading.magneticHeading
        let rawTrue = newHeading.trueHeading
        let accuracy = newHeading.headingAccuracy
        let loc = manager.location

        Task { @MainActor in
            guard let handler = self.compassHandler else { return }
            let tru = rawTrue >= 0 ? rawTrue : mag
            let card = self.cardinalDirection(from: tru)
            self.lastCompassData.magneticHeading = mag
            self.lastCompassData.trueHeading = tru
            self.lastCompassData.headingAccuracy = accuracy
            self.lastCompassData.cardinalDirection = card
            if let loc {
                self.lastCompassData.latitude = loc.coordinate.latitude
                self.lastCompassData.longitude = loc.coordinate.longitude
                self.lastCompassData.altitudeMeters = loc.altitude
            }
            handler(self.lastCompassData)
        }
    }

    public nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        let lat = loc.coordinate.latitude
        let lon = loc.coordinate.longitude
        let alt = loc.altitude

        Task { @MainActor in
            guard let handler = self.compassHandler else { return }
            self.lastCompassData.latitude = lat
            self.lastCompassData.longitude = lon
            self.lastCompassData.altitudeMeters = alt
            handler(self.lastCompassData)
        }
    }

    private func cardinalDirection(from deg: Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let normalized = deg.truncatingRemainder(dividingBy: 360.0)
        let positive = normalized < 0.0 ? normalized + 360.0 : normalized
        let index = Int((positive + 11.25) / 22.5) % directions.count
        return directions[index]
    }
}
