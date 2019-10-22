import CoreData


public extension PredicateKeyProtocol {

    var managedObjectPredicateKey: PredicateKeyProtocol {
        return predicateKeyPath == #keyPath(NSManagedObject.objectID) ? PredicateKey("self") : self
    }
}
