//
//  TestCoreData.swift
//  RHBKit_Tests
//
//  Created by Lazar Otasevic on 17.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import RHBKit
import CoreData

extension TestEntity: MutableProtocol, ManagedObjectProtocol {}
extension NSPersistentContainer: MutableProtocol {}
extension NSFetchRequest: MutableProtocol {}

class TestCoreData: XCTestCase {
    
    static let model = NSManagedObjectModel(name: "Tests", in: Bundle(for: TestCoreData.self))!
    let persistentContainer = NSPersistentContainer(name: "Tests", managedObjectModel: TestCoreData.model).mutate {
        
        $0.loadPersistentStores { desc, error in
            
            print(desc)
            XCTAssertNil(error)
        }
        $0.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAnykeypath() {

        let kp = \TestEntity.value == \TestEntity.value
        debugPrint(kp)
        let b = \TestEntity.value == \TestEntity.value
        XCTAssert(b)
    }

    func testObjectId() {
        
        let context = self.persistentContainer.viewContext
        
        let operationQueue = OperationQueue().mutate {
            
            $0.maxConcurrentOperationCount = 1
        }
        operationQueue.addCoreDataOperation(self.persistentContainer) { context in
            
            try! context.fetch(TestEntity.fetchRequest()).forEach { context.delete($0) }
            try! context.save()
        }
        operationQueue.waitUntilAllOperationsAreFinished()
        
        let entities = (1...4).map { num in
            
            TestEntity(context: context).mutate {
                
                $0.value = Int64(num)
                $0.name = "Zola"
            }
        }

        try! context.save()
        
        let valueKey = PredicateKey(#keyPath(TestEntity.value))
        let objectIdKey = PredicateKey(#keyPath(TestEntity.objectID))

        
        let fetchRequest1 = TestEntity.selfFetchRequest().mutate {
            
            $0.predicate = \TestEntity.value < 3 && \TestEntity.name == "Zola"
        }
        
        let fetchRequest2 = TestEntity.selfFetchRequest().mutate {
            
            $0.predicate = valueKey > 2
        }
        
        let fetchRequest3 = TestEntity.selfFetchRequest().mutate {
            
            $0.predicate = valueKey == 1
        }
        
        let fetchRequest4 = TestEntity.selfFetchRequest().mutate {
            
            $0.predicate = valueKey === entities.map { $0.value }
        }
        
        let fetchRequest41 = TestEntity.selfFetchRequest().mutate {
            
            $0.predicate = valueKey !== entities.map { $0.value }
        }
        
        let fetchRequest5 = TestEntity.selfFetchRequest().mutate {
            
            $0.predicate = objectIdKey == entities.first!.objectID
        }
        
        let fetchRequest6 = TestEntity.selfFetchRequest().mutate {
            
            $0.predicate = objectIdKey === entities.map { return $0.objectID }
        }
        
        let array1 = try! context.fetch(fetchRequest1)
        let array2 = try! context.fetch(fetchRequest2)
        let array3 = try! context.fetch(fetchRequest3)
        let array4 = try! context.fetch(fetchRequest4)
        let array41 = try! context.fetch(fetchRequest41)
        let array5 = try! context.fetch(fetchRequest5)
        let array6 = try! context.fetch(fetchRequest6)
        
        XCTAssert(array1.count == 2)
        XCTAssert(array2.count == 2)
        XCTAssert(array3.count == 1)
        XCTAssert(array4.count == entities.count)
        XCTAssert(array41.count == 0)
        XCTAssert(array5.count == 1)
        XCTAssert(array6.count == entities.count)
    }
}
