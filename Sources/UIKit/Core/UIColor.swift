import UIKit

public extension UIColor {
    convenience init(colorReference hex: Int) {
        let components = [16, 8, 0].map { CGFloat((hex >> $0) & 255) / CGFloat(255) }
        self.init(red: components[0], green: components[1], blue: components[2], alpha: 1)
    }
}
