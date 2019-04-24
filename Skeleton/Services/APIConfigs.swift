//
//  APIConfigs.swift
//  Skeleton
//
//  Created by Woxapp on 22.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit

// TODO: create object instead

public struct APIConfigs {

    static var timeoutInterval: Double {
        return 30
    }

    public var userPhone: String {
        return Session.phone?.replacingOccurrences(of: "+", with: "") ?? ""
    }

    public var uuid: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }

    public var accessToken: String {
        return Session.accessToken ?? ""
    }

    public var deviceToken: String {
        return Session.deviceToken ?? ""
    }

    public var userID: Int {
        return Session.id
    }

    static var apiPrefix: String {
        return ""
    }

    static var apiKey: String {
        return ""
    }

    static func request(part: String) -> String {
        return "\(apiPrefix)\(part)"
    }

}
