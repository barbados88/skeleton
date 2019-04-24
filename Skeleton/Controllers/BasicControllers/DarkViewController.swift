import UIKit

// implements dark title theme for navigation and status bar

class DarkViewController: ConnectionHandlerViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 74 / 255.0, green: 74 / 255.0, blue: 74 / 255.0, alpha: 1.0)]
        UIApplication.shared.statusBarStyle = .default
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

}
