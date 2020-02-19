import CoreData
import RHBFoundation

public extension NSManagedObjectContext {
    func saveChanges() throws {
        if hasChanges {
            try save()
        }
    }

    func existing<T: NSManagedObject>(objectFromDifferentContext object: T) throws -> T {
        try Optional(try existingObject(with: object.objectID)).forceCast(as: T.self)
    }
}
