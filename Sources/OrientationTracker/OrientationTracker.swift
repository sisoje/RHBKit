import CoreMotion


public class OrientationTracker {
    public private(set) var deviceRotation: Double = .nan {
        didSet {
            if oldValue != deviceRotation && !deviceRotation.isNaN {
                orientationChanged?(self)
            }
        }
    }
    var snappedRotation: Double = .nan {
        didSet {
            if !snappedRotation.isNaN {
                deviceRotation = snappedRotation
            }
        }
    }
    let axisThreshold: Double
    let snapAngle: Double
    var orientationChanged: ((OrientationTracker) -> Void)?
    let motionManager = CMMotionManager()
    public init(axisThreshold: Double = 0.85, snapAngle: Double = .pi / 16) {
        assert((0.0..<1.0).contains(axisThreshold))
        assert((0.0..<(.pi / 4)).contains(snapAngle))
        self.axisThreshold = axisThreshold
        self.snapAngle = snapAngle
    }
    deinit {
        stopTracking()
    }
}

public extension OrientationTracker {
    func startTracking(_ block: @escaping (OrientationTracker) -> Void) {
        orientationChanged = block
        snappedRotation = .nan
        deviceRotation = .nan
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] accelerometerData, error in
            guard let accelerometerData = accelerometerData else {
                Executer.debug?.execute { print(error ?? "no accelerometer data") }
                return
            }
            self?.updateRotation(acceleration: accelerometerData.acceleration)
        }
    }

    func stopTracking() {
        orientationChanged = nil
        motionManager.stopAccelerometerUpdates()
    }
}

extension OrientationTracker {
    func updateRotation(acceleration: CMAcceleration) {
        snappedRotation = snappedRotation(acceleration: acceleration)
    }
    func snappedRotation(acceleration: CMAcceleration) -> Double {
        if abs(acceleration.z) > axisThreshold {
            return .nan
        }
        let angle = acceleration.rotation()
        let keepRotation = [snapAngle, -snapAngle].contains { snappedRotation == (angle+$0).roundedRotation() }
        return keepRotation ? snappedRotation : angle.roundedRotation()
    }
}

extension CMAcceleration {
    func rotation() -> Double {
        return atan2(x, -y)
    }
}

extension FloatingPoint {
    func roundedRotation() -> Self {
        let t = (self * 2 / .pi).rounded()
        return (t == -2 ? 2 : t) * .pi / 2
    }
}
