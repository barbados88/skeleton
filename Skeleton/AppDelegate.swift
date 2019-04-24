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
        window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "root")
    }

}
