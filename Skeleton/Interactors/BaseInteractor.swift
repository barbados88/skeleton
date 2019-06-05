import UIKit
import RxSwift
import ObjectMapper

protocol BaseInteractor {

    associatedtype T

    func action() // may be optional
    func getObjects() -> Observable<[T]>
    func getObjects<T>(type: T) -> Observable<[T]>
    func deleteObjects<T>(objects: [T]) -> Observable<Bool>
    func updateObject<T, V>(object: T, with value: V) -> Observable<Bool>

    // Complex queries

    func getObjects<T>(type: T, predicate: NSPredicate?, parameters: [String: Any]?) -> Observable<[T]>
    func deleteObjects<T>(type: T, predicate: NSPredicate?, parameters: [String: Any]?) -> Observable<Bool>

}

// Swift has no optional funcs in protocol
// All optional funcs must be implemented in BaseViewModel extension

extension BaseInteractor {

    func getObjects() -> Observable<[T]> {
        return Observable.just([])
    }

    func getObjects<T>(type: T) -> Observable<[T]> {
        return Observable.just([])
    }

    func deleteObjects<T>(objects: [T]) -> Observable<Bool> {
        return Observable.just(true)
    }

    func updateObject<T, V>(object: T, with value: V) -> Observable<Bool> {
        return Observable.just(true)
    }

    func getObjects<T>(type: T, predicate: NSPredicate? = nil, parameters: [String: Any]? = nil) -> Observable<[T]> {
        return Observable.just([])
    }

    func deleteObjects<T>(type: T, predicate: NSPredicate? = nil, parameters: [String: Any]? = nil) -> Observable<Bool> {
        return Observable.just(true)
    }
    
    func sendRequest<R: Mappable>(request: ObjectAPIRequest) -> Observable<WXResponse<R>> {
        return CommunicatorRx.shared.objectRequest(object: request)
    }

}
