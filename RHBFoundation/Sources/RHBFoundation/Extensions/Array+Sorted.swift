import Foundation

public extension Array where Element: Comparable {
    func lowerBound(of element: Element) -> Int {
        var (lowerBound, upperBound) = (0, count)
        while lowerBound != upperBound {
            let midIndex = (upperBound + lowerBound) / 2
            let pivot = self[midIndex]
            if pivot < element {
                lowerBound = midIndex + 1
            } else {
                upperBound = midIndex
            }
        }
        return lowerBound
    }

    @discardableResult
    mutating func insertSorted(_ element: Element) -> Int {
        let index = lowerBound(of: element)
        insert(element, at: index)
        return index
    }

    @discardableResult
    mutating func removeSorted(_ element: Element) -> Int {
        let index = lowerBound(of: element)
        remove(at: index)
        return index
    }
}
