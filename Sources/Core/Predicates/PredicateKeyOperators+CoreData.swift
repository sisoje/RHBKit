import CoreData


public func ==<E: NSManagedObjectID>(pk: PredicateKeyProtocol, value: E) -> NSPredicate {
    return pk.managedObjectPredicateKey.predicate("==", value)
}

public func ===<S: Sequence>(pk: PredicateKeyProtocol, values: S) -> NSPredicate where S.Element: NSManagedObjectID {
    return pk.managedObjectPredicateKey.predicate("IN", values)
}
