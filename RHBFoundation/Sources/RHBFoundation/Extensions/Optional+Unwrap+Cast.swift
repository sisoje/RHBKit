import Foundation

public extension Optional {
    func forceUnwrap(_ info: Any? = nil, file: String = #file, line: Int = #line, function: String = #function) throws -> Wrapped {
        guard let result = self else {
            throw CodeLocationError(info, file, line, function)
        }
        return result
    }

    func forceCast<T: Any>(as type: T.Type = T.self, file: String = #file, line: Int = #line, function: String = #function) throws -> T {
        guard let result = self as? T else {
            throw CodeLocationError((self, type), file, line, function)
        }
        return result
    }
}
