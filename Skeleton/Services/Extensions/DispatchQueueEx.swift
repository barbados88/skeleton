//
//  DispatchQueueEx.swift
//  Skeleton
//
//  Created by Woxapp on 21.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit

extension DispatchQueue {

    private static var onceTracker = [String]()

    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if onceTracker.contains(token) {
            return
        }
        onceTracker.append(token)
        block()
    }

    public class func clearTokens() {
        onceTracker.removeAll()
    }

    public class func clearToken(_ token: String) {
        guard let index = onceTracker.index(of: token)
            else {
                return
        }
        onceTracker.remove(at: index)
    }

}
