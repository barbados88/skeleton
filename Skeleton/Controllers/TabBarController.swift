//
//  TabBarController.swift
//  Skeleton
//
//  Created by Woxapp on 21.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    private var dates: [Int: Date] = [:]
    private var animation: TabBarAnimation? = nil

    deinit {
        print("tabbarcontroller freed")
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        animation = TabBarAnimation(with: tabBar)
        animation?.type = .circular
        addObservers()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        var notificationName: Notification.Name? = nil
        var indexToAnimate = 0
        if item == tabBar.items?[0] {
            notificationName = checkDate(index: 0)
        } else if item == tabBar.items?[1] {
            indexToAnimate = 1
            notificationName = .secondTab
        } else if item == tabBar.items?[2] {
            indexToAnimate = 2
        }
        if notificationName != nil {
            NotificationCenter.default.post(name: notificationName!, object: nil)
        }
        animation?.animateTo(index: indexToAnimate)
    }

    private func checkDate(index: Int) -> Notification.Name? {
        if dates[index] == nil {
            dates[index] = Date()
            return nil
        }
        if fabs(dates[index]?.timeIntervalSinceNow ?? 0) < 30 {
            return nil
        }
        dates[index] = Date()
        return notificationName(at: index)
    }

    private func notificationName(at index: Int) -> Notification.Name {
        switch index {
        case 0: return .firstTab
        case 1: return .secondTab
        default: return .firstTab
        }
    }

    private func addObservers() {
        print("add observers")
    }

}
