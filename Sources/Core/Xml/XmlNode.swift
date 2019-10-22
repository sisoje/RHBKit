import Foundation

public class XmlNode: TreeNodeProtocol {
    public weak var parent: XmlNode?
    public var children: [XmlNode] = []
    public let namespace: String?
    public let qname: String?
    public let name: String
    public let attributes: [String : String]
    public var text: String = ""
    public init(name: String = "", attributes: [String : String] = [:], namespace: String? = nil, qname: String? = nil) {
        self.name = name
        self.attributes = attributes
        self.namespace = namespace
        self.qname = qname
    }
}

public extension XmlNode {
    subscript(_ name: String) -> [XmlNode] {
        return children.filter { $0.name == name }
    }
    subscript(path: [String]) -> [XmlNode] {
        return path.reduce([self]) { nodes, name in
            return nodes.flatMap { $0[name] }
        }
    }
}
