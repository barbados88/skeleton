//
//  WXObject.swift
//  Skeleton
//
//  Created by Woxapp on 11.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import ObjectMapper

protocol ObjectRequest {

    var request: String { set get }
    var parameters: [String: Any] { set get }
    var method: Alamofire.HTTPMethod { set get }

}

class ObjectGetRequest: ObjectRequest {

    public init() {}

    public init(with object: WXObject) {
        // here parameters value can be implemented
    }

    var request: String = APIConfigs.request(part: "")
    var parameters: [String: Any] = [:] // mappers should be used
    var method: Alamofire.HTTPMethod = .get

}

// if needed could be implement in any db class
// realm Object must inherite of WXObject

enum ObjectAPIRequest {

    case getObject(ObjectRequest)

    var current: ObjectRequest {
        switch self {
        case .getObject(let req): return req
        }
    }

}

class WXObject: Object, Mappable {

    @objc dynamic var id: Int = 0
    @objc dynamic var name: String? = nil

    open var request: ObjectAPIRequest {
        return .getObject(ObjectGetRequest())
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        print("let's map object")
    }

    override open class func ignoredProperties() -> [String] {
        return ["reuqest"]
    }

}
