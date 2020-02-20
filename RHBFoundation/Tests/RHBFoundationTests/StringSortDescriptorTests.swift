import RHBFoundation
import XCTest

final class StringSortDescriptorTests: XCTestCase {
    func testSort() {
        let strings = ["4", "äb", "3", "ab", "2", "Äb", "1", "Ab", "0"]

        let sortedByType: [StringComparatorType: [String]] = [
            .compare:
                strings.sorted { $0.compare($1) == ComparisonResult.orderedAscending },
            .caseInsensitiveCompare:
                strings.sorted { $0.caseInsensitiveCompare($1) == ComparisonResult.orderedAscending },
            .localizedCompare:
                strings.sorted { $0.localizedCompare($1) == ComparisonResult.orderedAscending },
            .localizedCaseInsensitiveCompare:
                strings.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending },
            .localizedStandardCompare:
                strings.sorted { $0.localizedStandardCompare($1) == ComparisonResult.orderedAscending }
        ]

        StringComparatorType.allCases.forEach { type in
            let desc = StringSortDescriptor(keyPath: \String.self, ascending: true, comparatorType: type)
            let sortedArray = (strings as NSArray).sortedArray(using: [desc]) as! [String]
            let expectedSortedArray = sortedByType[type]
            XCTAssertEqual(sortedArray, expectedSortedArray, "type used \(type)")
        }
    }
}
