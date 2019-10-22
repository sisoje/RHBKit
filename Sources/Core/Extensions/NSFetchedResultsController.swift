import CoreData

@objc public extension NSFetchedResultsController {
    convenience init?(performing request: NSFetchRequest<ResultType>, in context: NSManagedObjectContext, section: String? = nil, cache: String? = nil) {
        self.init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: section, cacheName: cache)
        do {
            try performFetch()
        } catch {
            return nil
        }
    }
}
