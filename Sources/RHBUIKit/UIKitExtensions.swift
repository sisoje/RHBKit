#if !os(macOS)
import UIKit

// MARK: - UIApplication

extension UIApplication {
    func getSceneWindow() -> UIWindow {
        let sceneWindows = connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .compactMap { $0.delegate as? UIWindowSceneDelegate }
            .compactMap { $0.window }
            .compactMap { $0 }
        guard sceneWindows.count == 1 else {
            fatalError("no proper window")
        }
        return sceneWindows[0]
    }
}

// MARK: - UIAlertController

extension UIAlertController {
    static func makeAlert(_ title: String? = nil, message: String? = nil, ok: String = "OK") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(
            UIAlertAction(
                title: ok,
                style: .cancel,
                handler: nil
            )
        )
        return alertController
    }
}

// MARK: - UIViewController

extension UIViewController {
    func presentMessage(_ message: String) {
        present(
            UIAlertController.makeAlert(message),
            animated: true,
            completion: nil
        )
    }

    func presentError(error: Error?) {
        guard let message = error.localizedDescription else {
            return
        }

        present(
            UIAlertController.makeAlert(
                title: "Error",
                message: message
            ),
            animated: true,
            completion: nil
        )
    }
}

// MARK: - UIWindow

extension UIWindow {
    func swpapRootViewController(with viewController: UIViewController, duration: TimeInterval = 0.4) {
        defer {
            rootViewController = viewController
        }

        guard let snapshot = snapshotView(afterScreenUpdates: true) else {
            return
        }

        viewController.view.addSubview(snapshot)

        UIView.transition(
            with: snapshot,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {
                snapshot.layer.opacity = 0
            },
            completion: { _ in
                snapshot.removeFromSuperview()
            }
        )
    }
}
#endif
