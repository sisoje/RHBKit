import CoreData

public final class CoreDataStack {
    public let persistentContainer: NSPersistentContainer

    public init(_ persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    public private(set) lazy var mainContext: NSManagedObjectContext = {
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return persistentContainer.viewContext
    }()

    public private(set) lazy var writingContext = BackgroundManagedObjectContext(persistentContainer) {
        $0.automaticallyMergesChangesFromParent = false
    }

    public private(set) lazy var readingContext = BackgroundManagedObjectContext(persistentContainer) {
        $0.automaticallyMergesChangesFromParent = true
    }
}
