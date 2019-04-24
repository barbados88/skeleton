//
//  AppDelegate.swift
//  Skeleton
//
//  Created by Woxapp on 21.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

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
