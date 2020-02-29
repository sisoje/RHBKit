import Foundation

public extension Optional {
    func forceUnwrap(_ file: String = #file, _ line: Int = #line, _ function: String = #function) throws -> Wrapped {
        guard let result = self else {
            throw CodeLocationError(nil, file, line, function)
        }
        return result
    }

    func forceCast<T: Any>(as type: T.Type = T.self, _ file: String = #file, _ line: Int = #line, _ function: String = #function) throws -> T {
        guard let result = self as? T else {
            throw CodeLocationError((self, type), file, line, function)
        }
        return result
    }
}
