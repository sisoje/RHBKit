import Foundation

public struct CodeLocationError: Error {
    let info: Any?
    let file: String
    let line: Int
    let function: String

    public init(
        _ info: Any? = nil,
        _ file: String = #file,
        _ line: Int = #line,
        _ function: String = #function
    ) {
        self.info = info
        self.line = line
        self.file = file
        self.function = function
    }
}

extension CodeLocationError: LocalizedError {
    public var errorDescription: String? {
        "File: \(file) Line: \(line) Function: \(function)" + (info.map { " Info: \($0)" } ?? "")
    }
}
