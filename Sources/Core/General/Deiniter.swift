import Foundation

public class Deiniter {
    let onDeinit: () -> Void
    public init(_ block: @escaping () -> Void) {
        onDeinit = block
    }
    deinit {
        onDeinit()
    }
}

public extension Array where Element == Deiniter {
    mutating func append(_ block: @escaping () -> Void) {
        append(Deiniter(block))
    }
}
