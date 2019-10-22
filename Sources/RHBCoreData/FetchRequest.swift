import CoreData

public enum FetchRequest<T: NSManagedObject> {}

public extension FetchRequest {
    static var request: NSFetchRequest<T> {
        return T.fetchRequest() as! NSFetchRequest<T>
    }
}
