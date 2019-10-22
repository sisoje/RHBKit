import CoreData

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

    func createPersistentStoreDirectories() throws {
        try persistentStoreDescriptions
            .compactMap { $0.url?.deletingLastPathComponent() }
            .forEach { try FileManager().createDirectory(at: $0, withIntermediateDirectories: true) }
    }

    func loadPersistentStoresSync() throws {
        persistentStoreDescriptions.forEach {
            $0.shouldAddStoreAsynchronously = false
        }
        var error: Error?
        loadPersistentStores {
            error = error ?? $1
        }
        try error.map {
            throw $0
        }
    }

    func loadPersistentStoresAsync(_ block: @escaping (Error?) -> Void) {
        persistentStoreDescriptions.forEach {
            $0.shouldAddStoreAsynchronously = true
        }
        loadPersistentStores {
            block($1)
        }
    }
}

// MARK: - internal

extension NSPersistentStoreCoordinator {
    func destroyPersistentStores(_ descriptions: [NSPersistentStoreDescription]) throws {
        try descriptions.forEach {
            guard let url = $0.url else {
                return
            }
            try destroyPersistentStore(at: url, ofType: $0.type)
        }
    }

    func removeStores() throws {
        try persistentStores.forEach {
            try remove($0)
        }
    }
}
