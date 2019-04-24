//
//  NetworkManager.swift
//  Incognito
//
//  Created by Woxapp on 20.12.2017.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit
import Reachability

class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()
    var reachabilityStatus: Reachability.Connection = .none
    let reachability = Reachability()

    var isNetworkAvailable: Bool {
        return reachabilityStatus != .none
    }

    @objc func reachabilityChanged(notification: Notification) {
        guard let reachability = notification.object as? Reachability
            else {
                return
        }
        reachabilityStatus = reachability.connection
        switch reachability.connection {
        case .none:
            NoInternetView.show()
            NotificationCenter.default.post(name: .reachable, object: nil, userInfo: ["connected": false])
        case .wifi, .cellular:
            NoInternetView.hide()
            NotificationCenter.default.post(name: .reachable, object: nil, userInfo: ["connected": true])
        }
    }

    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }

    func stopMonitoring() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged, object: reachability)
    }

}
