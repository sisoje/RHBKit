import Contacts

class FakeContactStoreForEnumerateContacts: CNContactStore {
    var result: Result<[CNContact], Error>!

    override func enumerateContacts(with fetchRequest: CNContactFetchRequest, usingBlock block: @escaping (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws {
        let contacts = try result.get()
        var stop = ObjCBool(false)
        contacts.forEach { contact in
            guard !stop.boolValue, fetchRequest.predicate?.evaluate(with: contact) ?? true else {
                return
            }
            block(contact, &stop)
        }
    }
}
