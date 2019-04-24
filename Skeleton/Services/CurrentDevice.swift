//
//  CurrentDevice.swift
//  VipCoin
//
//  Created by Woxapp on 11.01.2018.
//  Copyright © 2018 Woxapp. All rights reserved.
//

import UIKit

class CurrentDevice: NSObject {

    class var modelIdentifier: String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }

    static var capability: IDError {
        return modelIdentifier.contains("X") ? .face : .touch
    }

}
