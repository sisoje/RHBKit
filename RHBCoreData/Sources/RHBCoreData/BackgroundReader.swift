import CoreData

public class BacgroundReader: BackgroundContextInteractor {}
    
public extension BacgroundReader {
    convenience init(container: NSPersistentContainer) {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        self.init(context)
    }

    func read(errorBlock: @escaping (Error?) -> Void, _ taskBlock: @escaping (NSManagedObjectContext) throws -> Void) {
        performTask { context in
            var resultError: Error?
            do {
                try taskBlock(context)
            } catch {
                resultError = error
            }
            DispatchQueue.main.async {
                errorBlock(resultError)
            }
        }
    }
}
