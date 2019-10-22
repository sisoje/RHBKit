import CoreData

public protocol DataStackProtocol {

    var dataContainer: NSPersistentContainer { get }
    var dataQueue: OperationQueue { get }
}

public extension DataStackProtocol {
    func dataWork(_ block: @escaping (NSManagedObjectContext) -> Void) {
        dataQueue.addCoreDataOperation(dataContainer, block)
    }
    func backgroundFetch<T>(_ request: NSFetchRequest<T>, _ block: @escaping (NSFetchedResultsController<T>, NSManagedObjectContext) -> Void) {
        dataWork { [weak mainContext = dataContainer.viewContext] context in
            context.automaticallyMergesChangesFromParent = true
            if let controller = NSFetchedResultsController(performing: request, in: context) {
                DispatchQueue.main.async {
                    if let mainContext = mainContext {
                        block(controller, mainContext)
                    }
                }
            }
        }
    }
}

extension OperationQueue: MutableProtocol {}

public class DataStack: DataStackProtocol {

    public init(_ container: NSPersistentContainer) {
        dataContainer = container
        _ = NotificationCenter.default.addRemovableObserver(name: .NSManagedObjectContextWillSave) {
            assert(($0.object as? NSManagedObjectContext)?.concurrencyType != .mainQueueConcurrencyType)
        }
    }

    public let dataContainer: NSPersistentContainer

    public let dataQueue = OperationQueue().mutate {
        $0.maxConcurrentOperationCount = 1
        $0.name = "dataQueue"
    }
}
