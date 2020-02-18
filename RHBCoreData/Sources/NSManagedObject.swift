import CoreData

public extension NSManagedObject {
    func deleteFromManagedObjectContext() {
        managedObjectContext?.delete(self)
    }
}
