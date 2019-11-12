import UIKit
import Alamofire
import RxSwift
import ObjectMapper

typealias SuccessHandler = (Bool) -> Void
typealias CodeHandler = ((Bool, SocialType) -> Void)?

class Communicator: NSObject {

    typealias block = ((Any) -> Void)?

    private class func sendRequest(request: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, completion: @escaping([String: Any]) -> Void) {
        Requester.sendRequest(request: request, method: method, parameters: parameters, completion: { response in
            completion(response)
        })
    }

    class func getObject(block: block) {
        sendRequest(request: "", method: .get, completion: { response in
            block?(response)
        })
    }

    class func doSmth(object: ObjectAPIRequest, block: block) {
        let request = object.current
        sendRequest(request: request.request, method: request.method, parameters: request.parameters) { response in
            block?(response)
        }
    }

    class func sendCode(type: SocialType, _ block: CodeHandler) {
        block?(true, type)
    }

    class func send(request: String, completion: @escaping([String: Any]) -> ()) {
        sendRequest(request: request, method: .get, completion: completion)
    }
    
}

class CommunicatorRx: NSObject {

    static let shared = CommunicatorRx()
    private var requester = RequesterRx()
    private var disposeBag: DisposeBag = DisposeBag()

    private func sendRequest<T: Mappable>(request: String, method: Alamofire.HTTPMethod, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> Observable<WXResponse<T>> {
        return requester.sendRequest(request: request, method: method, parameters: parameters, headers: headers)
    }

    // USAGE:

    // use applyIOSchedulers to subscribe on background thread and observe on main thread

    // to handle result use next model to treat object from server
    // add completion block if needed

    func someRequest<T: Mappable>(parameters: [String: Any], _ block: ((WXResponse<T>) -> ())? = nil) {
        let request = ""
        sendRequest(request: request, method: .get, parameters: parameters)
            .applyIOSchedulers()
            .subscribe(onNext: { wxResponse in

                // do smth with object

                block?(wxResponse)

            }, onError: { error in
                print(error.localizedDescription)
                block?(WXResponse<T>())
            })
            .disposed(by: disposeBag)
    }

    // to handle result from server and treat and return custom object use next model

    func someRequest<T: Mappable>(parameters: [String: Any]) -> Observable<T> {
        let request = ""
        return sendRequest(request: request, method: .get, parameters: parameters)
        .applyIOSchedulers()
            .flatMap({ wxResponse -> Observable<T> in

                // force unwrap is bad usage
                // used here as a converter example
                // to show how to cast response to return type

                return Observable.just(wxResponse.dictionary!)
            })
    }

    // example viewModel

    func objectRequest<T: Mappable>(object: ObjectAPIRequest) -> Observable<WXResponse<T>> {
        let request = object.current
        return sendRequest(request: request.request, method: request.method, parameters: request.parameters, headers: request.headers)
    }

}
