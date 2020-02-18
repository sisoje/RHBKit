import RHBContacts
import XCTest

class RequestAccessTestCase: XCTestCase {
    let fakeStore = FakeContactStoreForRequestAccess()

    private func doTest(expectBool: Bool, expectError: Error?) {
        let ex = expectation(description: "test with expected bool \(expectBool) and expected error: \(String(describing: expectError))")
        ContactsApi(fakeStore).requestContactsAccess { result in
            do {
                let bool = try result.get()
                XCTAssertEqual(expectBool, bool)
            } catch {
                XCTAssertEqual(expectError as NSError?, error as NSError)
            }
            ex.fulfill()
        }
        XCTAssertEqual(fakeStore.entityType, .contacts)
        fakeStore.completionHandler(expectBool, expectError)
        waitForExpectations(timeout: 0, handler: nil)
    }

    func testTrue() {
        doTest(expectBool: true, expectError: nil)
    }

    func testFalse() {
        doTest(expectBool: false, expectError: nil)
    }

    func testTrueError() {
        doTest(expectBool: true, expectError: TestData.makeError())
    }

    func testFalseError() {
        doTest(expectBool: false, expectError: TestData.makeError())
    }
}
