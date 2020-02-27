import CoreData

public class BacgroundWriter: BackgroundContextInteractor {}

public extension BacgroundWriter {
    convenience init(container: NSPersistentContainer) {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = false
        self.init(context)
    }

    func write(errorBlock: @escaping (Error?) -> Void, _ taskBlock: @escaping (NSManagedObjectContext) throws -> Void) {
        performTask { context in
            context.reset()
            defer { context.reset() }
            var resultError: Error?
            do {
                try taskBlock(context)
                try context.saveChanges()
            } catch {
                resultError = error
            }
            DispatchQueue.main.async {
                errorBlock(resultError)
            }
        }
    }
}
