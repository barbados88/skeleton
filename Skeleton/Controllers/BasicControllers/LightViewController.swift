//
//  LightViewController.swift
//  Skeleton
//
//  Created by Woxapp on 15.03.2018.
//  Copyright © 2018 Woxapp. All rights reserved.
//

import UIKit

// implements light title theme for navigation and status bar

class LightViewController: ConnectionHandlerViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
