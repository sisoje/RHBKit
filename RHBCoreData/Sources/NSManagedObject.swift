import CoreData
import RHBFoundation

public extension NSManagedObject {
    func deleteFromManagedObjectContext() throws {
        try managedObjectContext.forceUnwrap().delete(self)
    }
}
