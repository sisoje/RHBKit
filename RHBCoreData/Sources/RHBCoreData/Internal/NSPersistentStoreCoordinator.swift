import CoreData

extension NSPersistentStoreCoordinator {
    func destroyPersistentStores(_ descriptions: [NSPersistentStoreDescription]) throws {
        try descriptions.forEach { desc in
            try desc.url.map {
                try destroyPersistentStore(at: $0, ofType: desc.type)
            }
        }
    }

    func removeStores() throws {
        try persistentStores.forEach {
            try remove($0)
        }
    }
}
