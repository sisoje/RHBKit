import Foundation

public func combineHashValue<T: FixedWidthInteger>(_ h1: T, _ h2: T) -> T {
    return (h1 << 5) &+ h1 &+ h2
}

public extension Sequence where Element: Hashable {
    func combinedHashValue() -> Int {
        return reduce(5381) { combineHashValue($0, $1.hashValue) }
    }
}

public extension Sequence where Self: Hashable, Element: Hashable {
    var hashValue: Int {
        return self.combinedHashValue()
    }
}

public extension Sequence where Self: Equatable, Element: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return Array(lhs) == Array(rhs)
    }
}

public protocol TwoDimensionalProtocol: MutableCollection {}
public extension TwoDimensionalProtocol {
    var startIndex: Int {
        return 0
    }
    var endIndex: Int {
        return 2
    }
    func index(after i: Int) -> Int {
        return i+1
    }
}

public protocol PointProtocol {
    associatedtype T
    var x: T { get set }
    var y: T { get set }
}

public protocol SizeProtocol {
    associatedtype T
    var width: T { get set }
    var height: T { get set }
}

public protocol VectorProtocol {
    associatedtype T
    var dx: T { get set }
    var dy: T { get set }
}

public protocol LocationProtocol {
    associatedtype T
    var latitude: T { get set }
    var longitude: T { get set }
}

public extension PointProtocol where Self: MutableCollection {
    subscript(_ index: Int) -> T {
        get {
            return index == 0 ? x : y
        }
        set {
            if index == 0 {
                x = newValue
            } else {
                y = newValue
            }
        }
    }
}

public extension SizeProtocol where Self: MutableCollection {
    subscript(_ index: Int) -> T {
        get {
            return index == 0 ? width : height
        }
        set {
            if index == 0 {
                width = newValue
            } else {
                height = newValue
            }
        }
    }
}

public extension VectorProtocol where Self: MutableCollection {
    subscript(_ index: Int) -> T {
        get {
            return index == 0 ? dx : dy
        }
        set {
            if index == 0 {
                dx = newValue
            } else {
                dy = newValue
            }
        }
    }
}

public extension LocationProtocol where Self: MutableCollection {
    subscript(_ index: Int) -> T {
        get {
            return index == 0 ? latitude : longitude
        }
        set {
            if index == 0 {
                latitude = newValue
            } else {
                longitude = newValue
            }
        }
    }
}

