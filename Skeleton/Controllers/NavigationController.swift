//
//  NavigationController.swift
//  Skeleton
//
//  Created by Woxapp on 21.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
    }

}
