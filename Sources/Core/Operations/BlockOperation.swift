import Foundation

public extension BlockOperation {
    convenience init(blockInside block: @escaping (Operation) -> Void) {
        self.init()
        addExecutionBlock { [unowned self] in
            assert(!Thread.isMainThread)
            block(self)
        }
    }
}
