import CoreData
import RHBCoreData
import RHBFoundation
import XCTest

extension NSPersistentContainer {
    static func testContainerByLoadingTestModelInMemory() -> NSPersistentContainer {
        let p = NSPersistentContainer(inMemory: .testModel)
        try! p.loadPersistentStoresSync()
        p.setupViewContext()
        return p
    }
}
