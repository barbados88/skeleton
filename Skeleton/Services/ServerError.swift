import UIKit

class ServerError: NSObject {

    private static var applicationName: String? {
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String
    }

    private class var isShowing: Bool {
        return UIApplication.topViewController() is UIAlertController
    }

    private static var dictionary: [Int: String] {
        var dict: [Int: String] = [:]
        dict[777] = NSLocalizedString("Пожалуйста, проверьте подключение к сети.", comment: "")
        dict[778] = NSLocalizedString("Неверный формат имени.", comment: "")
        dict[779] = NSLocalizedString("Неверный формат телефона.", comment: "")
        dict[780] = NSLocalizedString("Неверный формат email.", comment: "")
        dict[781] = NSLocalizedString("Неверный формат ссылки.", comment: "")
        return dict
    }

    class func showError(_ id: Int) {
        if let message = dictionary[id] {
            show(alert: message)
        }
    }

    class func show(alert message: String, _ title: String? = nil, _ button: String? = nil, _ handler: ((UIAlertAction) -> Void)? = nil) {
        if isShowing == true {
            return
        }
        let alert = UIAlertController(title: title ?? applicationName, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button ?? "OK", style: .default, handler: handler))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }

    private class func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString)
            else {
                return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.openURL(settingsUrl)
        }
    }

}
