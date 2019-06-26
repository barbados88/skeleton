import UIKit

class UIService: NSObject {

    override init() {
        super.init()
        print("init ui")
        navigationBarSettings()
        textFieldSettings()
    }

    private func navigationBarSettings() {
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(red: 74 / 255.0, green: 74 / 255.0, blue: 74 / 255.0, alpha: 1.0)]
        UINavigationBar.appearance().tintColor = Session.tintColor
    }

    private func textFieldSettings() {
        UITextField.appearance().tintColor = Session.tintColor
        UITextView.appearance().tintColor = Session.tintColor
        UITableView.appearance().tintColor = Session.tintColor
        UISearchBar.appearance().backgroundColor = UIColor(red: 230 / 255.0, green: 237 / 255.0, blue: 239 / 255.0, alpha: 1.0)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = NSLocalizedString("cancel_title", comment: "")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Session.tintColor], for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
    }

}
