//
//  BoolEx.swift
//  Skeleton
//
//  Created by Woxapp on 21.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit

extension Bool {

    var toInt: Int {
        return self == true ? 1 : 0
    }

    var toString: String {
        return self == true  ? "1" : "0"
    }

}
