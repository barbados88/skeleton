//
//  ResponseValidator.swift
//  Skeleton
//
//  Created by Woxapp on 22.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import ObjectMapper

class ResponseValidator: NSObject {

    class func checkResponse(response: DataResponse<Any>, completion: @escaping (_ response: [String: Any]) -> Void) {
        if response.result.value == nil {
            manageTimeout(response: response)
            completion([:])
            return
        }
        guard let dictionary = response.result.value as? [String: AnyObject]
            else {
                response.result.value as? [[String: AnyObject]] != nil ? completion(["response": response.result.value!]) : completion([:])
                return
        }
        _ = gotError(dictionary: dictionary)
        completion(dictionary)
    }
    
    private class func gotError(dictionary: [String: Any]) -> Bool {
        let status: String? = dictionary["status"] as? String
        if status == nil || excludedStatus.contains(status ?? "") {return false}
        ServerError.show(alert: status!)
        return false
    }
    
    private static var excludedStatus: [String] {
        return ["success", "User have not hash", "updated"]
    }
    
    private class func manageTimeout(response: DataResponse<Any>) {
        if let error = response.result.error {

            // uncomment to show any error from API

            // ServerError.show(alert: error.localizedDescription)

            // custom implementation

            if error._code == 4 {
                //JSON serialization error, ignoring
                return
            } else if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCannotFindHost || error._code != -999 || error._code != -1008 {
                ServerError.showError(777)
            }
        }
    }
    
}

class ResponseValidatorRx: NSObject {

    private let errorKey: String = "status"
    private let responseKey: String = "response"

    func checkResponse<T: Mappable>(response: DataResponse<Any>) -> Observable<WXResponse<T>> {
        if response.result.value == nil {
            manageTimeout(response: response)
            return Observable.just(WXResponse())
        }
        let wxResponse = WXResponse<T>()
        wxResponse.request = response.request
        wxResponse.dictionary = Mapper<T>().map(JSON: response.result.value as? [String: Any] ?? [:])
        wxResponse.array = Mapper<T>().mapArray(JSONArray: response.result.value as? [[String: Any]] ?? [])
        wxResponse.string = response.result.value as? String
        wxResponse.data = response.result.value as? Data
        
        // TODO: - check the format of error answer from server
        _ = gotError(dictionary: response.result.value as? [String: Any] ?? [:])

        return Observable.just(wxResponse)
    }

    private func gotError(dictionary: [String: Any]) -> Single<Bool> {
        let status: String? = dictionary[errorKey] as? String
        if status == nil || excludedStatus.contains(status ?? "") { return Single.just(false) }
        ServerError.show(alert: status!)
        return Single.just(false)
    }

    private var excludedStatus: [String] {
        return []
    }

    private func manageTimeout<T>(response: DataResponse<T>) {
        if let error = response.result.error {
            if error._code == 4 {
                //JSON serialization error, ignoring
                return
            } else if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCannotFindHost || error._code != -999 || error._code != -1008 {
                ServerError.showError(777)
            }
        }
    }

}
