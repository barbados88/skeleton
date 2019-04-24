//
//  NoInternetView.swift
//  VipCoin
//
//  Created by Woxapp on 22.02.2018.
//  Copyright © 2018 Woxapp. All rights reserved.
//

import UIKit

class NoInternetView: UIView {

    static let shared = NoInternetView()
    static let height: CGFloat = 32
    private var views: [NoInternetView] = []

    private static func configure() -> NoInternetView {
        let view = Bundle.main.loadNibNamed("NoInternetView", owner: nil, options: nil)?.first as? NoInternetView ?? NoInternetView()
        view.frame = CGRect(origin: CGPoint(x: 0, y: -NoInternetView.height), size: CGSize(width: UIScreen.main.bounds.size.width, height: NoInternetView.height))
        return view
    }

    static func show() {
        guard let sView = UIApplication.topViewController()?.view
            else {
                return
        }
        if sView.subviews.filter ({
            return $0 is NoInternetView
        }).first != nil {
            return
        }
        let view = NoInternetView.configure()
        shared.views.append(view)
        UIView.animate(withDuration: 0.3) {
            sView.frame = CGRect(x: 0, y: sView.frame.origin.y + NoInternetView.height, width: sView.frame.size.width, height: sView.frame.size.height - NoInternetView.height)
            sView.addSubview(view)
            sView.bringSubviewToFront(view)
        }
    }

    static func removeViewIfNeeded(from view: UIView) {
        removeExistedViews(array: view.subviews)
    }

    static func hide() {
        var addedViews: [NoInternetView] = []
        addedViews.append(contentsOf: shared.views)
        removeExistedViews(array: addedViews)
    }

    private static func removeExistedViews(array: [UIView]) {
        for view in array {
            if view is NoInternetView {
                if let index = shared.views.index(of: (view as! NoInternetView)) {
                    shared.views.remove(at: index)
                }
                view.removeFromSuperview()
            }
        }
    }

}
