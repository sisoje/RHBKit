import Foundation

public extension Optional {
    func forceUnwrap(_ file: String = #file, _ line: Int = #line, _ function: String = #function) throws -> Wrapped {
        guard let result = self else {
            throw CodeLocationInfo(nil, file, line, function)
        }
        return result
    }

    func forceCast<T: Any>(as type: T.Type, _ file: String = #file, _ line: Int = #line, _ function: String = #function) throws -> T {
        guard let result = self as? T else {
            throw CodeLocationInfo(self, file, line, function)
        }
        return result
    }
}

public extension Result where Failure == Error {
    static func makeResult(_ value: Success?, _ error: Error?, _ file: String = #file, _ line: Int = #line, _ function: String = #function) -> Result<Success, Error> {
        Result {
            try error.map {
                throw $0
            }
            return try value.forceUnwrap(file, line, function)
        }
    }
}
