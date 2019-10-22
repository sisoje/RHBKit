import Foundation

public class Indexer<T: Hashable, Index: BinaryInteger> {
    public var indexes: [T: Index] = [:]
    public var objects: [T] = []
    func append(_ object: T) -> Index {
        let index = Index(objects.count)
        objects.append(object)
        indexes[object] = index
        return index
    }
    subscript(_ object: T) -> Index {
        return indexes[object] ?? append(object)
    }
}
