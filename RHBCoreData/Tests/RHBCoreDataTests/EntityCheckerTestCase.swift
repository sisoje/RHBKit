import CoreData
import RHBCoreDataTestUtilities
import XCTest

class EntityCheckerTestCase: XCTestCase {
    func testModel() {
        EntityChecker.check(model: .testModel)
    }
}
