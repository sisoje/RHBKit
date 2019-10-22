import UIKit


public extension UIApplication {
    func openApplicationSettings(_ onReturnToApp: @escaping () -> Void) {
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        open(url) { isOpened in
            if !isOpened {
                return
            }
            var remover:(() -> Void)?
            remover = NotificationCenter.default.addRemovableObserver(name: .UIApplicationWillEnterForeground) { _ in
                remover?()
                remover = nil
                OperationQueue.main.addOperation(onReturnToApp)
            }
        }
    }
}
