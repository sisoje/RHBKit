import Contacts

public final class ContactsApi {
    let store: CNContactStore
    public init(_ store: CNContactStore) {
        self.store = store
    }
}

public extension ContactsApi {
    func requestContactsAccess(_ block: @escaping (Result<Bool, Error>) -> Void) {
        store.requestAccess(for: .contacts) { bool, error in
            block(Result {
                try error.map { throw $0 }
                return bool
            })
        }
    }

    func fetchContacts(_ contactRequest: CNContactFetchRequest) throws -> [CNContact] {
        var contacts: [CNContact] = []
        try store.enumerateContacts(with: contactRequest) { contact, _ in
            contacts.append(contact)
        }
        return contacts
    }

    func fetchKeyValues<V>(
        keyPath: KeyPath<CNContact, V>,
        predicate: NSPredicate? = nil,
        unifyResults: Bool = true
    ) throws -> [String: V] {
        let request = CNContactFetchRequest(keysToFetch: [keyPath.keyDescriptor])
        request.predicate = predicate
        request.unifyResults = unifyResults
        return try fetchContacts(request).keyValueByIdentifier(keyPath: keyPath)
    }
}
