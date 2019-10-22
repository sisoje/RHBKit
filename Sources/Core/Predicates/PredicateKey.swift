import Foundation


public struct PredicateKey: PredicateKeyProtocol {

    public let predicateKeyPath: String

    public init(_ string: String) {
        predicateKeyPath = string
    }
}
