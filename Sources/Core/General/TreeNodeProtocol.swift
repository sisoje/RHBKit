import Foundation

public protocol TreeNodeProtocol: class {
    associatedtype T
    var parent: T? { get set }
    var children: [T] { get set }
}

public struct TreeNodeParents<T: TreeNodeProtocol>: Sequence, IteratorProtocol where T.T == T {
    public var node: T?
    mutating public func next() -> T? {
        node = node?.parent
        return node
    }
}

public extension TreeNodeProtocol where Self == T {
    var parents: TreeNodeParents<Self> {
        return TreeNodeParents(node: self)
    }
    func addChild(_ node: Self) {
        node.parent = self
        children.append(node)
    }
    @discardableResult
    func removeChild(_ node: Self) -> Self? {
        guard let index = children.index(where: { $0 === node }) else {
            return nil
        }
        children.remove(at: index)
        return node
    }
    @discardableResult
    func removeFromParent() -> Self? {
        return parent?.removeChild(self)
    }
}
