import UIKit
import Alamofire
import SystemConfiguration
import RxAlamofire
import RxSwift
import ObjectMapper

class WXResponse<T>: NSObject {

    var request: URLRequest? = nil
    var dictionary: T? = nil
    var array: [T]? = nil
    var string: String? = nil
    var data: Data? = nil

}

class Retrier: RequestRetrier {

    enum RetryAction {

        case add
        case remove

    }

    var defaultRetryCount = 4
    var retryInterval = 0.5
    private var requestsAndRetryCounts: [(Request, Int)] = []
    private var lock = NSLock()

    private func index(request: Request) -> Int? {
        return requestsAndRetryCounts.index(where: { $0.0 === request })
    }

    func retry(action: RetryAction, request: Request, retryCount: Int? = nil) {
        lock.lock()
        defer { lock.unlock() }
        guard
            let index = index(request: request)
            else {
                print("ERROR: at addRetryInfo - called for already tracked request")
                return
        }
        if action == .add {
            requestsAndRetryCounts.append((request, retryCount ?? defaultRetryCount))
        } else {
            requestsAndRetryCounts.remove(at: index)
        }
    }

    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock()
        defer { lock.unlock() }
        guard
            let index = index(request: request)
            else {
                completion(false, 0)
                return
        }
        let (request, retryCount) = requestsAndRetryCounts[index]
        if retryCount == 0 {
            completion(false, 0)
        } else {
            requestsAndRetryCounts[index] = (request, retryCount - 1)
            completion(true, retryInterval)
        }
    }
}


class RequesterRx: NSObject {

    // USAGE: - https://github.com/RxSwiftCommunity/RxAlamofire

    var manager = SessionManager.default
    let retrier = Retrier()
    let validator = ResponseValidatorRx()

    private lazy var rManager: NetworkReachabilityManager? = {
        return NetworkReachabilityManager(host: "www.google.com")
    }()

    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIConfigs.timeoutInterval
        manager = SessionManager(configuration: configuration)
        manager.retrier = retrier
        listenToReachability()
    }

    private func listenToReachability() {
        rManager?.listener = { status in
            switch status {
            case .notReachable, .unknown:
                return
            case .reachable(_):
                return
            }
        }
        rManager?.startListening()
    }

    func sendRequest<T: Mappable>(request: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> Observable<WXResponse<T>> {

        // use retrier if needed

        cancelRequestIfExisted(request)
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        return manager
            .rx
            .request(method, request, parameters: parameters, encoding: encoding, headers: headers)
            .responseJSON()
            .applyIOSchedulers()
            .flatMap { response -> Observable<WXResponse<T>> in
                return self.validator.checkResponse(response: response)
        }
    }

    func cancelAll() {
        manager.session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach { $0.cancel() }
        }
    }

    private func cancelRequestIfExisted(_ request: String?) {
        manager.session.getTasksWithCompletionHandler { dataTasks, _, _ in
            dataTasks.forEach {
                if $0.originalRequest?.url?.absoluteString == request {
                    $0.cancel()
                    print("request \(request ?? "") cancelled")
                }
            }
        }
    }

}

class Requester: NSObject {

    static let shared = Requester()
    var sessionManager = Alamofire.SessionManager()
    var locationRequest: DataRequest? = nil
    var streetRequest: DataRequest? = nil
    private var reachabilityManager: NetworkReachabilityManager? = nil

    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = APIConfigs.timeoutInterval
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        listenToReachability()
    }

    private var rManager: NetworkReachabilityManager? {
        if reachabilityManager == nil {
            reachabilityManager = NetworkReachabilityManager(host: "www.google.com")
        }
        return reachabilityManager
    }

    private static var manager: Alamofire.SessionManager {
        return shared.sessionManager
    }

    class func sendRequest(request: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil, completion: @escaping([String: Any]) -> Void) {
        if ReachabilityManager.shared.isNetworkAvailable == false {
            completion([:])
            return
        }
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        manager.request(request, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: { response in
            ResponseValidator.checkResponse(response: response, completion: { response in
                completion(response)
            })
        })
    }

    private func listenToReachability() {
        rManager?.listener = { status in
            switch status {
            case .notReachable, .unknown:
                return
            case .reachable(_):
                return
            }
        }
        rManager?.startListening()
    }

}
