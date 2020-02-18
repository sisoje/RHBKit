import Contacts
import RHBContacts
import XCTest

class FetchingContactsTestCase: XCTestCase {
    let fakeStore = FakeContactStoreForEnumerateContacts()

    private func doTest(emitResult: Result<[CNContact], Error>, expectedResult: Result<[String: String], Error>) {
        fakeStore.result = emitResult
        let gotResult = Result {
            try ContactsApi(fakeStore).fetchKeyValues(keyPath: \.givenName)
        }
        XCTAssertEqual(expectedResult.mapError { $0 as NSError }, gotResult.mapError { $0 as NSError })
    }

    func testOk() {
        let contacts = TestData.makeContacts(3)
        let dict = Dictionary(uniqueKeysWithValues: contacts.map { ($0.identifier, $0.givenName) })
        doTest(emitResult: .success(contacts), expectedResult: .success(dict))
    }

    func testError() {
        let error = TestData.makeError()
        doTest(emitResult: .failure(error), expectedResult: .failure(error))
    }
}
