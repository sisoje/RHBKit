import CoreData
import RHBFoundation

public typealias LoadStoreError = (NSPersistentStoreDescription, Error)

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
        var errors: [LoadStoreError] = []
        loadPersistentStores { desc, error in
            error.map {
                errors.append(LoadStoreError(desc, $0))
            }
        }
        guard errors.isEmpty else {
            throw CodeLocationInfo(errors)
        }
    }

    func loadPersistentStoresAsync(_ block: @escaping (Error?) -> Void) {
        let dg = DispatchGroup()
        persistentStoreDescriptions.forEach {
            dg.enter()
            $0.shouldAddStoreAsynchronously = true
        }
        var errors: [LoadStoreError] = []
        loadPersistentStores { desc, error in
            error.map {
                errors.append(LoadStoreError(desc, $0))
            }
            dg.leave()
        }
        dg.notify(queue: .main) {
            let error = errors.isEmpty ? nil : CodeLocationInfo(errors)
            block(error)
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
