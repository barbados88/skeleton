//
//  ViewControllerNotificated.swift
//  Skeleton
//
//  Created by Woxapp on 11.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

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
