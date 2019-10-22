import CoreData

//NSFetchedResultsController suck because its objective-c generic, so we wrap it
public protocol FetchedDataProtocol {
    associatedtype T: NSFetchRequestResult
    var controller: NSFetchedResultsController<T> { get }
    subscript(_ indexPath: IndexPath) -> T { get }
}

public extension FetchedDataProtocol {
    var sections: Int {
        return controller.sections?.count ?? 0
    }
    func objectsIn(section: Int) -> Int {
        return controller.sections?[section].numberOfObjects ?? 0
    }
}

public protocol MainFetchedDataProtocol: FetchedDataProtocol {}

public protocol BackgroundFetchedDataProtocol: FetchedDataProtocol where T: NSManagedObject {
    var mainContext: NSManagedObjectContext { get }
}

public extension MainFetchedDataProtocol {
    subscript(_ indexPath: IndexPath) -> T {
        return controller.object(at: indexPath)
    }
}

public extension BackgroundFetchedDataProtocol {
    subscript(_ indexPath: IndexPath) -> T {
        let backgroundObject = controller.object(at: indexPath)
        let object = try? mainContext.existingObject(with: backgroundObject.objectID)
        assert(object != nil)
        return object as? T ?? backgroundObject
    }
}

public struct MainFetchedData<T: NSFetchRequestResult>: MainFetchedDataProtocol {
    public let controller: NSFetchedResultsController<T>
    public init(_ controller: NSFetchedResultsController<T>) {
        assert(controller.managedObjectContext.concurrencyType == .mainQueueConcurrencyType)
        self.controller = controller
    }
}

public struct BackgroundFetchedData<T: NSManagedObject>: BackgroundFetchedDataProtocol {
    public let controller: NSFetchedResultsController<T>
    public let mainContext: NSManagedObjectContext
    public init(_ controller: NSFetchedResultsController<T>, _ mainContext: NSManagedObjectContext) {
        assert(controller.managedObjectContext.concurrencyType != .mainQueueConcurrencyType)
        assert(mainContext.concurrencyType == .mainQueueConcurrencyType)
        self.mainContext = mainContext
        self.controller = controller
    }
}
