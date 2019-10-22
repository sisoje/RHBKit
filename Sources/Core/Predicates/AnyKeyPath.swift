import Foundation


extension AnyKeyPath: PredicateKeyProtocol {

    public var predicateKeyPath: String {
        return _kvcKeyPathString!
    }
}
