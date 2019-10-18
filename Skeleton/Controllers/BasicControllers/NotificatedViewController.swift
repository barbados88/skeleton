import UIKit

// Base viewController
// remove all observers

class NotificatedViewController: UIViewController {

    var model: RouterModel? = nil
    
    static func controller<T: NotificatedViewController>(storyboardName: String = "Main", identifier: String = "container") -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

class ContainerViewController: NotificatedViewController {
    
    private var constructor: WXTableConstructor? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSettings()
        initConstructor()
    }
    
    // MARK: - Helper methods
    
    private func initConstructor() {
        constructor = WXTableConstructor(tableView: tableView, info: ConstructorSuperClass(), refreshable: true)
        guard let model = model else { return }
        constructor?.info = model.info
    }
    
    private func startSettings() {
        model?.tableSettings?(tableView)
        model?.navigationSettings?(navigationController)
        model?.onDataUpdate = { info in
            self.constructor?.info = info
        }
    }
    
}
