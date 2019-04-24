import UIKit

// Base viewController
// remove all observers

class NotificatedViewController: UIViewController {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
