//
//  IntEx.swift
//  SpaceIn
//
//  Created by Woxapp on 21.03.2018.
//  Copyright © 2018 Woxapp. All rights reserved.
//

import UIKit

extension Int {

    var hour: String {
        return self > 9 ? "\(self):00" : "0\(self):00"
    }

    static var random: Int {
        return Int(arc4random_uniform(UInt32(INT_MAX)))
    }

}
