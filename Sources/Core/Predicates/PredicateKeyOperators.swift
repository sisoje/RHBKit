import Foundation


public func ==<E: Equatable>(pk: PredicateKeyProtocol, value: E) -> NSPredicate {
    return pk.predicate("==", value)
}

public func !=<E: Equatable>(pk: PredicateKeyProtocol, value: E) -> NSPredicate {
    return !(pk == value)
}

public func ><C: Comparable>(pk: PredicateKeyProtocol, value: C) -> NSPredicate {
    return pk.predicate(">", value)
}

public func <<C: Comparable>(pk: PredicateKeyProtocol, value: C) -> NSPredicate {
    return pk.predicate("<", value)
}

public func <=<C: Comparable>(pk: PredicateKeyProtocol, value: C) -> NSPredicate {
    return pk.predicate("<=", value)
}

public func >=<C: Comparable>(pk: PredicateKeyProtocol, value: C) -> NSPredicate {
    return pk.predicate(">=", value)
}

public func ===<S: Sequence>(pk: PredicateKeyProtocol, values: S) -> NSPredicate where S.Element: Equatable {
    return pk.predicate("IN", values)
}

public func !==<S: Sequence>(pk: PredicateKeyProtocol, values: S) -> NSPredicate where S.Element: Equatable {
    return !(pk === values)
}
