import UIKit
import XCTest
import RHBKit

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCancelOperation() {
        
        let e = self.expectation(description: "cancellation")

        let queue = OperationQueue().mutate { $0.maxConcurrentOperationCount = 1 }
        queue.addOperationInside { operation in

            var i = 0
            while !operation.isCancelled {

                i+=1
                print(i)
                Thread.sleep(forTimeInterval: 0.1)
            }
            e.fulfill()
        }
        Thread.sleep(forTimeInterval: 0.5)
        queue.cancelAllOperations()
        queue.waitUntilAllOperationsAreFinished()
        
        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testDeiniter_() {

        var t = 0
        if true {
            let _ = Deiniter {
                t += 1
            }
            XCTAssert(t == 1)
        }
        XCTAssert(t == 1)
    }

    func testDeiniter() {

        var t = 0
        if true {
            let d = Deiniter {
                t += 1
            }
            XCTAssertNotNil(d)
            XCTAssert(t == 0)
        }
        XCTAssert(t == 1)
    }

    func testDeinitManager() {

        var i = 0
        if true {
            let m = Deiniter { i = 1 }
            XCTAssert(!m.description.isEmpty && i == 0)
        }
        XCTAssert(i == 1)
    }

    func testDeinitManager2() {

        var i = 0
        if true {
            var m: [Deiniter] = []
            m.append { i = 1 }
            XCTAssert(i == 0)
        }
        XCTAssert(i == 1)
    }

    func testPredicateKey() {

        let arr = (1...5).map { $0 }
        let oarr = NSArray(array: arr)

        let pred = PredicateKey("self") == 2
        XCTAssert(oarr.filtered(using: pred).count == 1)

        let pred2 = PredicateKey("self") === [2,3]
        XCTAssert(oarr.filtered(using: pred2).count == 2)
    }

    func testNotif() {

        let exp = self.expectation(description: "n")
        var rm:(()->())?
        rm = NotificationCenter.default.addRemovableObserver(name: NSNotification.Name("n")) { _ in

            XCTAssertNotNil(rm)
            rm?()
            rm = nil
            exp.fulfill()
        }
        OperationQueue().mutate {
            $0.addOperation {
                NotificationCenter.default.post(name: NSNotification.Name("n"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("n"), object: nil)
            }
        }.waitUntilAllOperationsAreFinished()
        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testHashableArray() {
        let h2 = HashableArray<Int>([0, 1])
        let h3 = HashableArray<Int>([0, 1])
        let s = Set([h2, h3])
        XCTAssert(s.count == 1)
    }
}
