import Contacts

enum TestData {
    static func makeContacts(_ N: Int) -> [CNMutableContact] {
        (0..<N)
            .map { String($0) }
            .map {
                let contact = CNMutableContact()
                contact.givenName = $0
                return contact
            }
    }

    static func makeError() -> Error {
        NSError(domain: UUID().uuidString, code: 0, userInfo: nil)
    }
}
