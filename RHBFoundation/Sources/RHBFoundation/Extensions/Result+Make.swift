import Foundation

public extension Result where Failure == Error {
    static func makeResult(_ value: Success?, _ error: Error?, _ file: String = #file, _ line: Int = #line, _ function: String = #function) -> Result<Success, Error> {
        Result {
            try error.map {
                throw $0
            }
            return try value.forceUnwrap(file: file, line: line, function: function)
        }
    }
}
