import CoreData
import RHBCoreDataTestUtilities
import XCTest

class EntityCheckerTestCase: XCTestCase {
    func testModel() {
        NSManagedObjectModel.testModel.chechEntities()
    }
}
