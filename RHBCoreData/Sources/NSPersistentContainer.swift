import CoreData
import RHBFoundation

public extension NSPersistentContainer {
    convenience init(inMemory model: NSManagedObjectModel) {
        self.init(name: NSInMemoryStoreType, managedObjectModel: model)
        persistentStoreDescriptions.first?.type = NSInMemoryStoreType
    }

    convenience init(storeUrl: URL, model: NSManagedObjectModel) {
        self.init(name: storeUrl.deletingPathExtension().lastPathComponent, managedObjectModel: model)
        persistentStoreDescriptions.first?.url = storeUrl
    }

    func destroyPersistentStores() throws {
        try persistentStoreCoordinator.destroyPersistentStores(persistentStoreDescriptions)
    }

    func removeStores() throws {
        try persistentStoreCoordinator.removeStores()
    }

    func loadPersistentStoresSync() throws {
        persistentStoreDescriptions.forEach {
            $0.shouldAddStoreAsynchronously = false
        }
        var errors: [(NSPersistentStoreDescription, Error)] = []
        loadPersistentStores { desc, error in
            error.map {
                errors.append((desc, $0))
            }
        }
        guard errors.isEmpty else {
            throw CodeLocationError(errors)
        }
    }

    func loadPersistentStoresAsync(_ block: @escaping (Error?) -> Void) {
        let dispatchGroup = DispatchGroup()
        persistentStoreDescriptions.forEach {
            dispatchGroup.enter()
            $0.shouldAddStoreAsynchronously = true
        }
        var errors: [(NSPersistentStoreDescription, Error)] = []
        loadPersistentStores { desc, error in
            error.map {
                errors.append((desc, $0))
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            let error = errors.isEmpty ? nil : CodeLocationError(errors)
            block(error)
        }
    }

    func setupViewContext() {
        viewContext.automaticallyMergesChangesFromParent = true
    }
}
