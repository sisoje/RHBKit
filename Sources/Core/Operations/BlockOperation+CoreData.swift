import CoreData


public extension BlockOperation {
    func addCoreDataBlock(_ container: NSPersistentContainer, _ block: @escaping (NSManagedObjectContext) -> Void) {
        addExecutionBlock { [weak container] in
            assert(!Thread.isMainThread)
            if let context = container?.newBackgroundContext() {
                context.performAndWait {
                    block(context)
                    assert(!context.hasChanges)
                }
            }
        }
    }
    convenience init(persistentContainer container: NSPersistentContainer, block: @escaping (NSManagedObjectContext) -> Void) {
        self.init()
        addCoreDataBlock(container, block)
    }
    convenience init(persistentContainer container: NSPersistentContainer, blockInside block: @escaping (Operation, NSManagedObjectContext) -> Void) {
        self.init()
        addCoreDataBlock(container) { [unowned self] context in
            block(self, context)
        }
    }
}
