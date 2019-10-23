import Foundation

public extension Optional {
    func forceUnwrap(file: String = #file, line: Int = #line, function: String = #function) throws -> Wrapped {
        guard let result = self else {
            throw CodeLocationInfo(file: file, line: line, function: function)
        }
        return result
    }

    func forceCast<T: Any>(as type: T.Type, file: String = #file, line: Int = #line, function: String = #function) throws -> T {
        guard let result = self as? T else {
            throw CodeLocationInfo(file: file, line: line, function: function)
        }
        return result
    }
}
