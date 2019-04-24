//
//  APIService.swift
//  Skeleton
//
//  Created by Woxapp on 10.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

class APIService: NSObject {

    override init() {
        super.init()
        print("init apis")
        ReachabilityManager.shared.startMonitoring()
    }

}
