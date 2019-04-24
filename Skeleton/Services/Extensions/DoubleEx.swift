import UIKit

extension Double {

    var degrees: Double {
        return self * 180.0 / .pi
    }

    var radians: CGFloat {
        return CGFloat(.pi * self / 180.0)
    }

    public static var random: Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }

    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }

}
