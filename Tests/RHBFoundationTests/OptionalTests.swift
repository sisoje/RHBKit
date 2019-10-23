import RHBFoundation
import XCTest

final class OptionalTests: XCTestCase {
    func testForceCastOk() {
        let int = 5
        let n: NSNumber? = NSNumber(value: int)
        XCTAssertNoThrow(
            XCTAssertEqual(try n.forceCast(as: Int.self), int)
        )
    }
}
