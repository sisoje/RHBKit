import Foundation

open class XmlDocumentParsing: NSObject, XMLParserDelegate {
    open let documentNode = XmlNode()
    open weak var parsingNode: XmlNode? {
        willSet {
            if parsingNode?.parent === newValue {
                onNodeFinished?(self)
            }
        }
    }
    open let onNodeFinished: ((XmlDocumentParsing) -> Void)?
    public init(_ block: ((XmlDocumentParsing) -> Void)? = nil) {
        self.onNodeFinished = block
    }
    open func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let node = XmlNode(name: elementName, attributes: attributeDict, namespace: namespaceURI, qname: qName)
        parsingNode?.addChild(node)
        parsingNode = node
    }
    open func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        parsingNode = parsingNode?.parent
    }
    open func parser(_ parser: XMLParser, foundCharacters string: String) {
        parsingNode?.text += string
    }
    open func parserDidStartDocument(_ parser: XMLParser) {
        parsingNode = documentNode
    }
    open func parserDidEndDocument(_ parser: XMLParser) {
        parsingNode = nil
    }
}

open class XmlOperationParsing: XmlDocumentParsing {
    open let operation: Operation
    public init(_ operation: Operation, _ block: ((XmlDocumentParsing) -> Void)? = nil) {
        self.operation = operation
        super.init(block)
    }
    open override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if operation.isCancelled {
            parser.abortParsing()
        }
        super.parser(parser, didStartElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName, attributes: attributeDict)
    }
    open override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if operation.isCancelled {
            parser.abortParsing()
        }
        super.parser(parser, didEndElement: elementName, namespaceURI: namespaceURI, qualifiedName: qName)
    }
    open override func parser(_ parser: XMLParser, foundCharacters string: String) {
        if operation.isCancelled {
            parser.abortParsing()
        }
        super.parser(parser, foundCharacters: string)
    }
}

