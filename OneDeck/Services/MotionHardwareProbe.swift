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

    let motionManager = CMMotionManager()
    private let altimeter = CMAltimeter()
    private var locationManager: CLLocationManager?
    private var compassHandler: ((CompassData) -> Void)?
    private var altimeterRetryWorkItem: DispatchWorkItem?

    // Motion State
    private(set) var isMotionActive: Bool = false
    private(set) var isMagnetometerActive: Bool = false
    private(set) var isAltimeterActive: Bool = false
    private(set) var isCompassActive: Bool = false

    // Smoothing & Baseline
    private var lastAltitudeMeters: Double = 0.0
    private var lastAltitudeTimestamp: Date = .init()

    override private init() {
        super.init()
    }

    // MARK: - 1. Spirit Level & Inclinometer (Adaptive Rate: 12Hz Preview / 60Hz Workspace)
    public func startMotionUpdates(interval: TimeInterval = 1.0 / 60.0, handler: @escaping (SpiritLevelData) -> Void) {
        guard motionManager.isDeviceMotionAvailable else { return }

        let effectiveInterval = AppState.shared.isSensorPowerSaving ? max(interval, 1.0 / 24.0) : interval
        motionManager.deviceMotionUpdateInterval = effectiveInterval
        isMotionActive = true

        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] motion, error in
            guard self != nil, let motion, error == nil else { return }

            let rollRad = motion.attitude.roll
            let pitchRad = motion.attitude.pitch

            let rollDeg = rollRad * (180.0 / .pi)
            let pitchDeg = pitchRad * (180.0 / .pi)

            // Combined tilt angle relative to gravity vector
            let gx = motion.gravity.x
            let gy = motion.gravity.y
            let gz = motion.gravity.z
            let totalG = max(0.001, sqrt(gx * gx + gy * gy + gz * gz))

            // Phone orientation determination:
            // Vertical wall ruler mode is ONLY valid when the screen plane is held perpendicular
            // to the ground (|gz| < 0.28) and resting on portrait (|gy| > 0.80) or landscape (|gx| > 0.80) edge.
            let isVerticalWall = abs(gz) < 0.28 && (abs(gy) > 0.80 || abs(gx) > 0.80)
            let orientation: SpiritLevelOrientation = isVerticalWall ? .vertical : .flat

            let tiltDeg: Double
            let isLevel: Bool

            if isVerticalWall {
                // Wall vertical ruler edge tilt
                if abs(gx) > abs(gy) {
                    // Standing on landscape side edge: pitch measures deviation of edge from horizontal
                    tiltDeg = abs(pitchDeg)
                } else {
                    // Standing on portrait bottom/top edge: roll measures deviation of edge from horizontal
                    tiltDeg = abs(rollDeg)
                }
                isLevel = tiltDeg <= 0.35
            } else {
                // 2D surface / inclinometer mode:
                // True 3D tilt is the deviation of the gravity vector from the phone's Z normal (table plane).
                // Both roll and pitch contribute to deviation from level.
                let xyMagnitude = sqrt(gx * gx + gy * gy)
                tiltDeg = asin(min(1.0, xyMagnitude / totalG)) * (180.0 / .pi)
                isLevel = tiltDeg <= 0.35
            }

            // Slope percentage (rise over run) - safe bounded calculation
            let safeTilt = min(89.5, max(0.0, tiltDeg))
            let radForSlope = (safeTilt * .pi) / 180.0
            let rawSlope = tan(radForSlope) * 100.0
            let slope = rawSlope.isFinite ? min(999.0, max(0.0, rawSlope)) : 999.0

            let data = SpiritLevelData(
                rollDegrees: rollDeg,
                pitchDegrees: pitchDeg,
                tiltDegrees: tiltDeg,
                isLevel: isLevel,
                orientation: orientation,
                slopePercent: slope
            )

            handler(data)
        }
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
    public func startAltimeterUpdates(handler: @escaping (Double, Double, Double, PressureTrend) -> Void) {
        guard CMAltimeter.isRelativeAltitudeAvailable() else { return }
        guard !isAltimeterActive else { return }

        isAltimeterActive = true
        lastAltitudeTimestamp = Date()
        lastAltitudeMeters = 0.0

        altimeter.startRelativeAltitudeUpdates(to: .main) { [weak self] data, error in
            guard let self else { return }
            if error != nil {
                self.isAltimeterActive = false
                if CMAltimeter.authorizationStatus() == .notDetermined {
                    self.scheduleAltimeterRetry(handler: handler)
                }
                return
            }
            guard let data else { return }

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

    private func scheduleAltimeterRetry(handler: @escaping (Double, Double, Double, PressureTrend) -> Void) {
        altimeterRetryWorkItem?.cancel()
        let item = DispatchWorkItem { [weak self] in
            guard let self, !self.isAltimeterActive else { return }
            let status = CMAltimeter.authorizationStatus()
            if status == .authorized || status == .notDetermined {
                self.startAltimeterUpdates(handler: handler)
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
    public func startCompassUpdates(enableGpsLocation: Bool = false, handler: @escaping (CompassData) -> Void) {
        self.compassHandler = handler
        self.isCompassActive = true

        if locationManager == nil {
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyHundredMeters // Power-efficient
            manager.headingFilter = 1.0
            manager.delegate = self
            self.locationManager = manager
        }

        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingHeading()
        if enableGpsLocation {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        }
    }

    public func setCompassGpsActive(_ active: Bool) {
        guard isCompassActive else { return }
        if active {
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
        isCompassActive = false
    }

    // CLLocationManagerDelegate
    public nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            Task { @MainActor in
                if self.isCompassActive {
                    manager.startUpdatingHeading()
                    manager.startUpdatingLocation()
                }
            }
        }
    }

    public nonisolated func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        Task { @MainActor in
            guard let handler = self.compassHandler else { return }
            let mag = newHeading.magneticHeading
            let tru = newHeading.trueHeading > 0 ? newHeading.trueHeading : mag
            let card = self.cardinalDirection(from: tru)
            var data = CompassData()
            data.magneticHeading = mag
            data.trueHeading = tru
            data.headingAccuracy = newHeading.headingAccuracy
            data.cardinalDirection = card
            if let loc = manager.location {
                data.latitude = loc.coordinate.latitude
                data.longitude = loc.coordinate.longitude
                data.altitudeMeters = loc.altitude
            }
            handler(data)
        }
    }

    private func cardinalDirection(from deg: Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let index = Int((deg + 11.25).truncatingRemainder(dividingBy: 360.0) / 22.5)
        return directions[max(0, min(directions.count - 1, index))]
    }
}
