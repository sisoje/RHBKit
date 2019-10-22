import Foundation

public extension BidirectionalCollection {

    subscript (clamped index: Index) -> Element {
        if index < startIndex {
            return self[startIndex]
        }
        if index > endIndex {
            return self[self.index(before: endIndex)]
        }
        return self[index]
    }
}
