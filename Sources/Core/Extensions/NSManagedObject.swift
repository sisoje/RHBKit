import CoreData

public extension NSManagedObject {
    func deleteFromContext() {
        managedObjectContext?.delete(self)
    }
}
