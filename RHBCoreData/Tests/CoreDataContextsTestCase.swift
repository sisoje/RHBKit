import CoreData
import RHBCoreData
import RHBCoreDataTestUtilities
import RHBFoundation
import XCTest

extension CoreDataContextsTestCase {
    func createTestEntity(id: String, _ block: @escaping (Result<TestEntity, Error>) -> Void) {
        var t: TestEntity!
        writer.write(errorBlock: { error in
            block(Result {
                try error.map {
                    throw $0
                }
                return try self.container.viewContext.existing(objectFromDifferentContext: try t.forceUnwrap())
            })
        }) { context in
            t = TestEntity(context: context)
            t.id = id
        }
    }
}

class CoreDataContextsTestCase: XCTestCase {
    var container: NSPersistentContainer!
    var writer: BacgroundWriter!
    var reader: BacgroundReader!
    let errorBlock: (Error?) -> Void = {
        XCTAssertNil($0)
    }

    override func setUp() {
        container = .testContainerByLoadingTestModelInMemory()
        writer = BacgroundWriter(container: container)
        reader = BacgroundReader(container: container)
    }

    func testExisting() {
        let ex = expectation(description: #function)
        createTestEntity(id: "1") { result in
            let ent = try! result.get()
            self.writer.write(errorBlock: self.errorBlock) { context in
                let ent2 = try context.existing(objectFromDifferentContext: ent)
                XCTAssertNotNil(ent2)
                try ent2.deleteFromManagedObjectContext()
            }
            self.writer.write(errorBlock: self.errorBlock) { context in
                XCTAssertThrowsError(try context.existing(objectFromDifferentContext: ent))
                ex.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCRUD() {
        let errorBlock: (Error?) -> Void = {
            XCTAssertNil($0)
        }

        createTestEntity(id: #function) { result in
            _ = try! result.get()
        }

        writer.write(errorBlock: errorBlock) { context in
            let fetchRequest = FetchRequestBuilder(predicate: \TestEntity.id == #function).request
            let testEntity = try! context.fetch(fetchRequest).first!
            XCTAssert(testEntity.id == #function)
            testEntity.id = nil
        }

        writer.write(errorBlock: errorBlock) { context in
            let fetchRequest = FetchRequestBuilder(predicate: \TestEntity.id == nil).request
            let testEntity = try! context.fetch(fetchRequest).first!
            XCTAssert(testEntity.id == nil)
            try testEntity.deleteFromManagedObjectContext()
        }

        let ex = expectation(description: #function)
        writer.write(errorBlock: errorBlock) { context in
            let fetchRequest = FetchRequest<TestEntity>.request
            XCTAssert(try! context.fetch(fetchRequest).isEmpty)
            ex.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCoredataDeinit() {
        var counter = 0
        let N = 200
        (0..<N).forEach { _ in
            writer.write(errorBlock: errorBlock) { context in
                counter += 1
                try! context.save()
            }
        }
        writer = nil
        try! container.removeStores()
        XCTAssert(counter < N)
    }

    func testCoreDataAsyncOk() {
        let ex = expectation(description: #function)
        try! container.removeStores()
        container.persistentStoreDescriptions.first.map {
            $0.url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent(UUID().uuidString)
            $0.type = NSSQLiteStoreType
        }
        container.loadPersistentStoresAsync { error in
            XCTAssertNil(error)
            ex.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCoreDataAsyncErrors() {
        let ex = expectation(description: #function)
        try! container.removeStores()
        container.persistentStoreDescriptions.first.map {
            $0.url = URL(fileURLWithPath: "")
            $0.type = NSSQLiteStoreType
        }
        container.loadPersistentStoresAsync { error in
            XCTAssertNotNil(error)
            ex.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testBackgroundFetchedActionsInsert() {
        let ex = expectation(description: #function)
        let fetchRequest = FetchRequestBuilder(sortBy: \TestEntity.id, ascending: true).request
        var data: FetchedData<TestEntity>!
        reader.read(errorBlock: errorBlock) { context in
            let cont = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try cont.performFetch()
            data = FetchedData(cont)
            data.didChange = {
                ex.fulfill()
                XCTAssert(cont.sections?.first?.numberOfObjects == 1)
            }
            data.didChangeObject[.insert] = { ent, _, _ in
                XCTAssert(ent.id == #function)
            }
            self.writer.write(errorBlock: self.errorBlock) { context in
                let testEntity = TestEntity(context: context)
                testEntity.id = #function
                try context.saveChanges()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFulfiller() {
        let N = 10
        (0..<N * 2).forEach { index in
            let ex = expectation(description: "\(#function) \(index)")
            let ful = DeinitBlock { ex.fulfill() }
            if index.isMultiple(of: 2) {
                return
            }
            writer.write(errorBlock: errorBlock) { context in
                let obj = TestEntity(context: context)
                obj.id = #function
                try context.save()
                ful.noop()
            }
        }
        waitForExpectations(timeout: 1) {
            XCTAssertNil($0)
            XCTAssert(try! self.container.viewContext.fetch(TestEntity.fetchRequest()).count == N)
        }
    }

    func testFetchedData() {
        let fetchRequest = FetchRequestBuilder(sortBy: \TestEntity.id, ascending: true).request
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        try! controller.performFetch()
        let fetchedData = FetchedData(controller)

        var willed = 0
        var dided = 0
        var moved = false
        var updated = false
        var inserted = false
        var deleted = false
        fetchedData.willChange = {
            XCTAssert(willed == dided)
            willed += 1
        }
        fetchedData.didChange = {
            dided += 1
            XCTAssert(willed == dided)
        }
        fetchedData.didChangeObject[.insert] = { entity, path1, path2 in
            XCTAssertEqual(try! self.container.viewContext.existingObject(with: entity.objectID), entity)
            XCTAssertNil(path1)
            XCTAssertEqual(entity, fetchedData[path2!])
            inserted = true
        }
        fetchedData.didChangeObject[.delete] = { entity, path1, path2 in
            XCTAssertEqual(try! self.container.viewContext.existingObject(with: entity.objectID), entity)
            XCTAssertNotNil(path1)
            XCTAssertNil(path2)
            XCTAssertFalse(fetchedData.controller.fetchedObjects!.contains(entity))
            deleted = true
        }
        fetchedData.didChangeObject[.update] = { entity, path1, path2 in
            XCTAssertEqual(try! self.container.viewContext.existingObject(with: entity.objectID), entity)
            XCTAssert(path1 == path2)
            XCTAssertEqual(entity, fetchedData[path1!])
            updated = true
        }
        fetchedData.didChangeObject[.move] = { entity, path1, path2 in
            XCTAssertEqual(try! self.container.viewContext.existingObject(with: entity.objectID), entity)
            XCTAssert(path1 != path2)
            XCTAssertEqual(entity, fetchedData[path2!])
            moved = true
        }

        XCTAssert(fetchedData.controller.sections?.count == 1)
        XCTAssert(fetchedData.controller.sections?.first?.numberOfObjects == 0)

        let t1 = TestEntity(context: container.viewContext)
        t1.id = "a"
        let t5 = TestEntity(context: container.viewContext)
        t5.id = "b"
        XCTAssert(!inserted)
        try! container.viewContext.save()
        XCTAssert(inserted)
        XCTAssert(fetchedData.controller.sections?.first?.numberOfObjects == 2)

        t1.text = UUID().uuidString
        XCTAssert(!updated)
        try! container.viewContext.save()
        XCTAssert(updated)

        t1.id = "c"
        XCTAssert(!moved)
        try! container.viewContext.save()
        XCTAssert(moved)

        try! t1.deleteFromManagedObjectContext()
        XCTAssert(!deleted)
        try! container.viewContext.save()
        XCTAssert(deleted)
        XCTAssert(fetchedData.controller.sections?.first?.numberOfObjects == 1)

        let ex = expectation(description: #function)
        writer.write(errorBlock: errorBlock) { context in
            let obj = try context.existing(objectFromDifferentContext: t5)
            try obj.deleteFromManagedObjectContext()
            try! context.save()
            DispatchQueue.main.async {
                ex.fulfill()
            }
        }

        waitForExpectations(timeout: 1) { err in
            XCTAssertNil(err)
            XCTAssert(fetchedData.controller.sections?.first?.numberOfObjects == 0)
            XCTAssert(willed > 0 && dided > 0 && willed == dided)
        }
    }

    func testSelfIn() {
        let ex = expectation(description: #function)
        let ex2 = expectation(description: "2")

        var ent: TestEntity!

        let context = container.newBackgroundContext()
        context.performAndWait {
            ent = TestEntity(context: context)
            try! context.save()
        }

        container.performBackgroundTask { context in
            _ = try! context.existing(objectFromDifferentContext: ent)
            ex2.fulfill()
        }

        DispatchQueue.global().async {
            let fr2 = FetchRequest<TestEntity>.request
            fr2.predicate = {
                let ex1 = NSExpression(forKeyPath: \TestEntity.self)
                let ex2 = NSExpression(forConstantValue: [ent])
                return NSComparisonPredicate(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: .in)
            }()
            fr2.returnsObjectsAsFaults = true

            let fr1 = FetchRequest<TestEntity>.request
            fr1.predicate = {
                let ex1 = NSExpression(format: "self")
                let ex2 = NSExpression(forConstantValue: [ent])
                return NSComparisonPredicate(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: .in)
            }()
            fr1.returnsObjectsAsFaults = true

            self.reader.read(errorBlock: self.errorBlock) {
                XCTAssert(try! $0.fetch(fr1).first?.objectID == ent.objectID)
                XCTAssert(try! $0.fetch(fr2).first?.objectID == ent.objectID)
                XCTAssert(try! $0.existing(objectFromDifferentContext: ent).objectID == ent.objectID)
                ex.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testSelfInBackground() {
        let ex = expectation(description: "Refetch test")
        reader.read(errorBlock: errorBlock) { context in
            let fetchRequest = FetchRequestBuilder(sortBy: \TestEntity.id, ascending: true).request
            let cont = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try! cont.performFetch()
            let data = FetchedData(cont)
            data.didChange = {
                ex.fulfill()
                XCTAssertNotNil(data.controller.fetchedObjects, "Just to retain data")
            }
            data.didChangeObject[.insert] = { ent, _, _ in
                self.writer.write(errorBlock: self.errorBlock) { writingContext in
                    let ent1 = try writingContext.existing(objectFromDifferentContext: ent)
                    XCTAssert(ent.objectID == ent1.objectID)
                }
            }
            self.writer.write(errorBlock: self.errorBlock) { context in
                let ent = TestEntity(context: context)
                ent.id = UUID().uuidString
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
