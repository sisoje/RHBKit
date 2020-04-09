import RHBFoundation
import XCTest

final class ResultMakeTests: XCTestCase {
    func testMakeOk() {
        let result = Result.makeResult(1, nil)
        do {
            let num = try result.get()
            XCTAssertEqual(num, 1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testMakeError() {
        let makeError = NSError(domain: "", code: 0, userInfo: nil)
        let result = Result.makeResult(1, makeError)
        do {
            _ = try result.get()
            XCTFail("should not succeed")
        } catch let catchedError as NSError {
            XCTAssertEqual(makeError, catchedError)
        }
    }

    func testMakeDumb() {
        let result: Result<Int, Error> = Result.makeResult(nil, nil)
        do {
            _ = try result.get()
            XCTFail("should not succeed")
        } catch {
            XCTAssert(error is CodeLocationError)
        }
    }
}
