import Foundation


public extension NSPredicate {
    convenience init(key: String, op: String, value: Any) {
        self.init(format: [key, op, "%@"].joined(separator: " "), argumentArray: [value])
    }
}
