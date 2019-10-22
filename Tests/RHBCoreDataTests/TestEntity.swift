import CoreData

@objc class TestEntity: NSManagedObject {
    @NSManaged public var id: String?
    @NSManaged public var text: String?
}
