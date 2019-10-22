import CoreData
import RHBFoundation

public extension NSManagedObjectContext {
    func saveChanges() throws {
        guard hasChanges else {
            return
        }
        try save()
    }

    func refetch<S: Sequence>(_ sequence: S) throws -> [S.Element] where S.Element: NSManagedObject {
        let request = FetchRequestBuilder(predicate: \S.Element.self === sequence).request
        return try fetch(request)
    }

    func existing<T: NSManagedObject>(_ object: T) -> T? {
        return try? existingObject(with: object.objectID) as? T
    }

    func makeFetchedResultsController<T: NSFetchRequestResult>(request: NSFetchRequest<T>, sectionNameKeyPath: String? = nil, cacheName: String? = nil) -> NSFetchedResultsController<T> {
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: self, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
    }

    @discardableResult
    func makeObject<T: NSManagedObject>(_ initialize: (T) -> Void = { _ in }) -> T {
        let object = T(context: self)
        initialize(object)
        return object
    }
}
