import Foundation


public extension NotificationCenter {
    func addRemovableObserver(name: NSNotification.Name? = nil, object: Any? = nil, queue: OperationQueue? = nil, _ block: @escaping (Notification) -> Void) ->  () -> Void {
        let observer = addObserver(forName: name, object: object, queue: queue, using: block)
        return { [weak self] in
            self?.removeObserver(observer)
        }
    }
}
