import CoreData

public extension NSPersistentContainer {

    func loadStoresAsync(_ block: @escaping (NSPersistentContainer, [(NSPersistentStoreDescription, Error)]) -> Void) {
        let group = DispatchGroup()
        persistentStoreDescriptions.forEach {
            $0.shouldAddStoreAsynchronously = true
            group.enter()
        }
        var errors: [(NSPersistentStoreDescription, Error)] = []
        loadPersistentStores { store, error in
            if let error = error {
                errors.append((store, error))
            }
            group.leave()
        }
        group.notify(queue: .main) {
            block(self, errors)
        }
    }
}
