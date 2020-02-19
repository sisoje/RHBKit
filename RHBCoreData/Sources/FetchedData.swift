import CoreData

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
        self.strongDelegate.fetchedData = self
        controller.delegate = self.strongDelegate
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
}
