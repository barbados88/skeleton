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
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: WXColors.screenTitleColor.color]
        UINavigationBar.appearance().tintColor = WXColors.mainAppColor.color
    }

    private func textFieldSettings() {
        UITextField.appearance().tintColor = WXColors.mainAppColor.color
        UITextView.appearance().tintColor = WXColors.mainAppColor.color
        UITableView.appearance().tintColor = WXColors.mainAppColor.color
        UISearchBar.appearance().backgroundColor = WXColors.screenBackgroundColor.color
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = NSLocalizedString("cancel_title", comment: "")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: WXColors.mainAppColor.color], for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
    }

}
