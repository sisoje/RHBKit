import Foundation

public struct MeshLineCreator {
    public let index: Int
    public let mesh: Mesh
}

public extension MeshLineCreator {
    @discardableResult
    func create(points: [Int], closed: Bool) -> MeshLineCreator {
        points.forEach {
            line(to: $0)
        }
        if closed {
            close()
        }
        return self
    }
}

extension MeshLineCreator {
    var line: Line {
        return mesh.lines[index]
    }
    func line(to point: Int) {
        mesh.points.grow(to: point+1) { Point() }
        if let p0 = line.points.last {
            assignEdge((p0, point))
        }
        line.points.append(point)
    }
    func close() {
        if
            let p0 = line.points.last,
            let p1 = line.points.first,
            p0 != p1 {
            line.closed = true
            assignEdge((p0, p1))
        }
    }
    func assignEdge(_ points: (Int, Int)) {
        let edgeIndex = mesh.prepareEdge(points)
        mesh.edges[edgeIndex].lines.append(index)
    }
}
