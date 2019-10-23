import CoreData

@objc class TestEntity: NSManagedObject {
    @NSManaged var id: String?
    @NSManaged var text: String?
}
