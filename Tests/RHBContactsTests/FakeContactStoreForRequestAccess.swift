import Contacts

class FakeContactStoreForRequestAccess: CNContactStore {
    private(set) var completionHandler: ((Bool, Error?) -> Void)!
    private(set) var entityType: CNEntityType!

    override func requestAccess(for entityType: CNEntityType, completionHandler: @escaping (Bool, Error?) -> Void) {
        self.completionHandler = completionHandler
        self.entityType = entityType
    }
}
