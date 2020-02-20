import CoreData
import RHBFoundation

public final class FetchRequestBuilder<T: NSManagedObject> {
    public let request: NSFetchRequest<T>
    public init(_ request: NSFetchRequest<T> = FetchRequest<T>.request) {
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

    convenience init(sortBy keyPath: KeyPath<T, String?>, ascending: Bool, comparatorType: StringComparatorType) {
        self.init()
        addSort(by: keyPath, ascending: ascending, comparatorType: comparatorType)
    }

    convenience init(sortBy keyPath: KeyPath<T, String>, ascending: Bool, comparatorType: StringComparatorType) {
        self.init()
        addSort(by: keyPath, ascending: ascending, comparatorType: comparatorType)
    }

    func addSort<V: Comparable>(by keyPath: KeyPath<T, V?>, ascending: Bool) {
        addSort(NSSortDescriptor(keyPath: keyPath, ascending: ascending))
    }

    func addSort<V: Comparable>(by keyPath: KeyPath<T, V>, ascending: Bool) {
        addSort(NSSortDescriptor(keyPath: keyPath, ascending: ascending))
    }

    func addSort(by keyPath: KeyPath<T, String?>, ascending: Bool, comparatorType: StringComparatorType) {
        addSort(StringSortDescriptor(keyPath: keyPath, ascending: ascending, comparatorType: comparatorType))
    }

    func addSort(by keyPath: KeyPath<T, String>, ascending: Bool, comparatorType: StringComparatorType) {
        addSort(StringSortDescriptor(keyPath: keyPath, ascending: ascending, comparatorType: comparatorType))
    }
}

// MARK: - internal

extension FetchRequestBuilder {
    func addSort(_ descriptor: NSSortDescriptor) {
        request.sortDescriptors = request.sortDescriptors.map { $0 + [descriptor] } ?? [descriptor]
    }
}
