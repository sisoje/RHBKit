import CoreData

public protocol ManagedObjectProtocol where Self: NSManagedObject {

    associatedtype T: NSManagedObject
    static func selfFetchRequest() -> NSFetchRequest<T>
}

public extension ManagedObjectProtocol where T == Self {

    static func selfFetchRequest() -> NSFetchRequest<Self> {
        let result = fetchRequest() as? NSFetchRequest<Self>
        assert(result != nil)
        return result ?? NSFetchRequest<Self>()
    }
}
