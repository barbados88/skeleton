//
//  ExampleRequest.swift
//  Skeleton
//
//  Created by User on 6/20/19.
//

import UIKit
import Alamofire
import ObjectMapper

class SuperRequest: ObjectRequest {
    
    var request: String = ""
    var parameters: [String: Any] = [:]
    var method: HTTPMethod = .post
    
}

private class LogInRequest: SuperRequest {
    
    init(with params: [String: Any]) {
        super.init()
        parameters = params
        request = "\(APIConfigs.apiPrefix)/api/account/login.php"
    }
    
}

private class LogoutRequest: SuperRequest {
    
    override init() {
        super.init()
        request = "\(APIConfigs.apiPrefix)/api/account/logout.php"
        parameters = ["hold": true]
    }
    
}

enum LoginValues {
    
    case logIn([String: Any]), logOut
    
    var requestClass: ObjectRequest {
        switch self {
        case .logIn(let parameters): return LogInRequest(with: parameters)
        case .logOut: return LogoutRequest()
        }
    }
    
}

class ExampleRequest: RObject {

    private var value: LoginValues = .logIn([:])
    
    override init() {
        super.init()
    }
    
    init(with loginValue: LoginValues) {
        value = loginValue
    }
    
    required init?(map: Map) {
        print("RObject is mapable")
    }
    
    open override var request: ObjectAPIRequest {
        return .getObject(value.requestClass)
    }
    
}
