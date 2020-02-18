import CoreData
import RHBFoundation

public final class FetchRequestBuilder<T: NSManagedObject> {
    public let request: NSFetchRequest<T>
    public init(request: NSFetchRequest<T> = FetchRequest<T>.request) {
        self.request = request
    }
}

public extension FetchRequestBuilder {
    convenience init<P: TypedPredicateProtocol>(predicate: P) where P.Root == T {
        self.init()
        request.predicate = predicate
    }

    convenience init<V: Comparable>(sortBy keyPath: KeyPath<T, V?>, ascending: Bool) {
        self.init()
        addSort(by: keyPath, ascending: ascending)
    }

    convenience init<V: Comparable>(sortBy keyPath: KeyPath<T, V>, ascending: Bool) {
        self.init()
        addSort(by: keyPath, ascending: ascending)
    }

    @discardableResult
    func addSort<V: Comparable>(by keyPath: KeyPath<T, V?>, ascending: Bool) -> Self {
        request.addSort(NSSortDescriptor(keyPath: keyPath, ascending: ascending))
        return self
    }

    @discardableResult
    func addSort<V: Comparable>(by keyPath: KeyPath<T, V>, ascending: Bool) -> Self {
        request.addSort(NSSortDescriptor(keyPath: keyPath, ascending: ascending))
        return self
    }
}

// MARK: - internal

@objc extension NSFetchRequest {
    func addSort(_ descriptor: NSSortDescriptor) {
        sortDescriptors = (sortDescriptors ?? []) + [descriptor]
    }
}
