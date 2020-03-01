import CoreData
import RHBFoundation

public final class FetchedData<T: NSFetchRequestResult> {
    public let controller: NSFetchedResultsController<T>

    public var didChangeObject: [NSFetchedResultsChangeType: (T, IndexPath?, IndexPath?) -> Void] = [:]
    public var didChangeSection: [NSFetchedResultsChangeType: (NSFetchedResultsSectionInfo, Int) -> Void] = [:]
    public var willChange: (() -> Void)?
    public var didChange: (() -> Void)?
    public var sectionIndexTitle: ((String) -> String?)?

    private let strongDelegate = FetcheDataDelegate<T>()

    public init(_ controller: NSFetchedResultsController<T>) {
        self.controller = controller
        strongDelegate.fetchedData = self
        controller.delegate = strongDelegate
    }

    deinit {
        controller.delegate = nil
    }
}

public extension FetchedData {
    subscript(_ indexPath: IndexPath) -> T {
        controller.object(at: indexPath)
    }

    var sections: [NSFetchedResultsSectionInfo] {
        controller.sections ?? []
    }

    var numberOfObjects: Int {
        sections.map { $0.numberOfObjects }.reduce(0, +)
    }
    
    func predicate<TP: TypedPredicateProtocol>(_ predicate: TP) where TP.Root == T {
        controller.fetchRequest.predicate = predicate
    }
    
    func performFetchInBackground(_ errorBlock: @escaping (Error?) -> Void) {
        controller.managedObjectContext.perform { [weak self] in
            do {
                try self?.controller.performFetch()
                errorBlock(nil)
            } catch {
                errorBlock(error)
            }
        }
    }
}
