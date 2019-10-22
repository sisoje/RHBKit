import Foundation

public class Point {
    public var edges: [Int] = []
}

public class Edge {
    public let points: (Int, Int)
    public var lines: [Int] = []
    public init(_ points: (Int, Int)) {
        self.points = points
    }
}

public class Line {
    public var points: [Int] = []
    public var closed = false
}

public extension Edge {
    func contains(_ point: Int) -> Bool {
        return [points.0, points.1].contains(point)
    }
}

public class Mesh {
    public var points: [Point] = []
    public var edges: [Edge] = []
    public var lines: [Line] = []
}

public extension Mesh {
    convenience init(numberOfPoints n: Int) {
        self.init()
        points.grow(to: n) { Point() }
    }
}

extension Mesh {
    func findEdge(_ pointIndexes: (Int, Int)) -> Int? {
        let (pointEdges0, pointEdges1) = (points[pointIndexes.0].edges, points[pointIndexes.1].edges)
        let find0 = pointEdges0.count < pointEdges1.count
        let (pointEdges, otherPoint) = find0 ? (pointEdges0, pointIndexes.1) : (pointEdges1, pointIndexes.0)
        return pointEdges.first { edges[$0].contains(otherPoint) }
    }
    func createEdge(_ pointIndexes: (Int, Int)) -> Int {
        let edgeIndex = edges.count
        edges.append(Edge(pointIndexes))
        [pointIndexes.0, pointIndexes.1].forEach { points[$0].edges.append(edgeIndex) }
        return edgeIndex
    }
    func prepareEdge(_ pointIndexes: (Int, Int)) -> Int {
        return findEdge(pointIndexes) ?? createEdge(pointIndexes)
    }
}

public extension Mesh {
    func newLineCreator() -> MeshLineCreator {
        let index = lines.count
        lines.append(Line())
        return MeshLineCreator(index: index, mesh: self)
    }
}
