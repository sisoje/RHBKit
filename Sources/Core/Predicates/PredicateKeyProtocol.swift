import Foundation


public protocol PredicateKeyProtocol {

    var predicateKeyPath: String { get }
}

public extension PredicateKeyProtocol {

    func predicate(_ op: String, _ value: Any) -> NSPredicate {
        return NSPredicate(key: predicateKeyPath, op: op, value: value)
    }
}
