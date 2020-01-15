import UIKit

enum AppThemeEnum {
    
    case `default`
    
    var mainAppColor: UIColor {
        switch self {
        case .default: return UIColor(red: 173 / 255.0, green: 20 / 255.0, blue: 47 / 255.0, alpha: 1)
        }
    }
    
    var appErrorColor: UIColor {
        switch self {
        case .default: return UIColor(red: 254 / 255, green: 56 / 255.0, blue: 36 / 255.0, alpha: 1)
        }
    }
    
    var appMainTextColor: UIColor {
        switch self {
        case .default: return UIColor.darkGray
        }
    }
    
    var detailsTextColor: UIColor {
        switch self {
        case .default: return UIColor.lightGray
        }
    }
    
    var screenTitleColor: UIColor {
        switch self {
        case .default: return UIColor(red: 74 / 255.0, green: 74 / 255.0, blue: 74 / 255.0, alpha: 1.0)
        }
    }
    
    var screenBackgroundColor: UIColor {
        switch self {
        case .default: return UIColor(red: 230 / 255.0, green: 237 / 255.0, blue: 239 / 255.0, alpha: 1.0)
        }
    }
    
}

class AppTheme {
    
    var appTheme: AppThemeEnum = .default
    
    var mainAppColor: UIColor { return appTheme.mainAppColor }
    var appErrorColor: UIColor { return appTheme.appErrorColor }
    var appMainTextColor: UIColor { return appTheme.appMainTextColor }
    var detailsTextColor: UIColor { return appTheme.detailsTextColor }
    var screenTitleColor: UIColor { return appTheme.screenTitleColor }
    var screenBackgroundColor: UIColor { return appTheme.screenBackgroundColor }
    
    public init() {}
    
    public init(theme: AppThemeEnum) {
        appTheme = theme
    }
    
}

class UIService: NSObject {

    private var appTheme: AppTheme = AppTheme()
    
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
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: appTheme.screenTitleColor]
        UINavigationBar.appearance().tintColor = appTheme.mainAppColor
    }

    private func textFieldSettings() {
        UITextField.appearance().tintColor = appTheme.mainAppColor
        UITextView.appearance().tintColor = appTheme.mainAppColor
        UITableView.appearance().tintColor = appTheme.mainAppColor
        UISearchBar.appearance().backgroundColor = appTheme.screenBackgroundColor
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = NSLocalizedString("cancel_title", comment: "")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: appTheme.mainAppColor], for: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .white
    }

}
