import Contacts

extension KeyPath where Root: CNContact {
    var keyDescriptor: CNKeyDescriptor {
        NSExpression(forKeyPath: self).keyPath as CNKeyDescriptor
    }
}

extension Sequence where Element: CNContact {
    func keyValueByIdentifier<V>(keyPath: KeyPath<Element, V>) -> [String: V] {
        Dictionary(
            uniqueKeysWithValues: map { ($0.identifier, $0[keyPath: keyPath]) }
        )
    }
}
