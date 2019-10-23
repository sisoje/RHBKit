import Foundation

public extension Optional {
    func unwrap(file: String = #file, line: Int = #line, function: String = #function) throws -> Wrapped {
        guard let result = self else {
            throw CodeLocationInfo(nil, file: file, line: line, function: function)
        }
        return result
    }
}
