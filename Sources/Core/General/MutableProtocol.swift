import Foundation


func mutateObject<T>(_ t: T, _ block: (T) -> Void) -> T {
    block(t)
    return t
}

public protocol MutableProtocol: class {

    associatedtype T: AnyObject
    func mutate(_ block: (T) -> Void) -> T
}

public extension MutableProtocol where T == Self {

    @discardableResult
    func mutate(_ block: (Self) -> Void) -> Self {
        return mutateObject(self, block)
    }
}
