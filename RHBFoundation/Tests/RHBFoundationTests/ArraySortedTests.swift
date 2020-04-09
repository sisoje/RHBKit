import RHBFoundation
import XCTest

final class ArraySortedTests: XCTestCase {
    func testEmpty() {
        let arr: [Int] = []
        XCTAssertEqual(arr.lowerBound(of: 0), 0)
    }

    func testOne() {
        let arr: [Int] = [0]
        XCTAssertEqual(arr.lowerBound(of: -1), 0)
        XCTAssertEqual(arr.lowerBound(of: 0), 0)
        XCTAssertEqual(arr.lowerBound(of: 1), 1)
    }

    func testInsert1() {
        var arr: [Int] = [0, 2]
        arr.insertSorted(1)
        XCTAssertEqual(arr, [0, 1, 2])
    }

    func testInsert0() {
        var arr: [Int] = [0, 2]
        arr.insertSorted(0)
        XCTAssertEqual(arr, [0, 0, 2])
    }

    func testInsertMinus1() {
        var arr: [Int] = [0, 2]
        arr.insertSorted(-1)
        XCTAssertEqual(arr, [-1, 0, 2])
    }

    func testInsert2() {
        var arr: [Int] = [0, 2]
        arr.insertSorted(2)
        XCTAssertEqual(arr, [0, 2, 2])
    }

    func testInsert3() {
        var arr: [Int] = [0, 2]
        arr.insertSorted(3)
        XCTAssertEqual(arr, [0, 2, 3])
    }

    func testRemove0() {
        var arr: [Int] = [0, 2]
        arr.removeSorted(0)
        XCTAssertEqual(arr, [2])
    }

    func testRemove2() {
        var arr: [Int] = [0, 2]
        arr.removeSorted(2)
        XCTAssertEqual(arr, [0])
    }

    func testRemoveAll() {
        var arr: [Int] = [0]
        arr.removeSorted(0)
        XCTAssertEqual(arr, [])
    }
}
