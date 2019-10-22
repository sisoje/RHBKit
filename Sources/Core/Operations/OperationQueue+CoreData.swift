import CoreData


public extension OperationQueue {
    func addCoreDataOperation(_ container: NSPersistentContainer, _ block: @escaping (NSManagedObjectContext) -> Void) {
        assert(self != .main)
        addOperation(BlockOperation(persistentContainer: container, block: block))
    }
    func addCoreDataOperationInside(_ container: NSPersistentContainer, _ block: @escaping (Operation, NSManagedObjectContext) -> Void) {
        assert(self != .main)
        addOperation(BlockOperation(persistentContainer: container, blockInside: block))
    }
}
