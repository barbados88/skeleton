//
//  ConnectionHandlerViewController.swift
//  Skeleton
//
//  Created by Woxapp on 11.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

// us to handle and show connection changes to user
// if there is no connection red line will appear under navigation bar on all controllers in stack
// when connection is available again red line will disappear

class ConnectionHandlerViewController: NotificatedViewController {

    deinit {
        guard let view = view
            else {
                return
        }
        NoInternetView.removeViewIfNeeded(from: view)
        print("\(self) freed memory")
    }

    private var isNeedToFix: Bool = false
    private var defaultY: CGFloat {
        get {
            let barHeight = navigationController?.navigationBar.frame.height ?? 0
            let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
            return barHeight + statusBarHeight
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ReachabilityManager.shared.isNetworkAvailable == false {
            NoInternetView.show()
        }
        isNeedToFix = true
    }

    func fixFrames() {
        if isNeedToFix == false { return }
        let pad = ReachabilityManager.shared.isNetworkAvailable == true ? 0 : NoInternetView.height
        view.frame = CGRect(x: 0, y: defaultY + pad, width: view.frame.size.width, height: UIScreen.main.bounds.size.height - defaultY - pad)
        for subview in view.subviews {
            if subview is NoInternetView {
                subview.frame = CGRect(origin: CGPoint(x: 0, y: -NoInternetView.height), size: CGSize(width: UIScreen.main.bounds.size.width, height: NoInternetView.height))
            }
        }
    }

}
