import Foundation


public extension OperationQueue {
    func addOperationInside(_ block: @escaping (Operation) -> Void) {
        assert(self != .main)
        addOperation(BlockOperation(blockInside: block))
    }
}
