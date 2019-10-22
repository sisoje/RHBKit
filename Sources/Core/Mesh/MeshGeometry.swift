import Foundation

public class MeshGeometry {
    public let mesh = Mesh()
    public let pointIIndexer = Indexer<AnyHashable, Int>()
}

public extension MeshGeometry {
    @discardableResult
    func makePolygon<T: Hashable>(points: [T], closed: Bool) -> Int {
        let pointIndexes = points.map { pointIIndexer[$0] }
        return mesh.newLineCreator().create(points: pointIndexes, closed: closed).index
    }
}
