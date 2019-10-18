import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let services = ApplicationInitService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applyRootViewController()
        return true
    }

    private func applyRootViewController() {
        let storyboard = UIStoryboard(name: Session.accessToken == nil ? "Authentification" : "Main", bundle: nil)
        let nvc = storyboard.instantiateViewController(withIdentifier: "root")
        window?.rootViewController = nvc
        WXProvider.shared.router = WXRouter(with: nvc as! NavigationController)
    }
    
}
