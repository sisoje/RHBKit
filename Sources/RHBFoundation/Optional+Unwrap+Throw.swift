import Foundation

public extension Optional {
    func forceUnwrap(file: String = #file, line: Int = #line, function: String = #function) throws -> Wrapped {
        guard let result = self else {
            throw CodeLocationInfo("Can not unwrap to \(String(describing: Wrapped.self))", file: file, line: line, function: function)
        }
        return result
    }

    func forceCast<T: Any>(as type: T.Type, file: String = #file, line: Int = #line, function: String = #function) throws -> T {
        let unwraped = try forceUnwrap(file: file, line: line, function: function)
        guard let result = unwraped as? T else {
            throw CodeLocationInfo("Can not cast \(String(describing: unwraped)) to \(String(describing: type))", file: file, line: line, function: function)
        }
        return result
    }
}
