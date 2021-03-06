import UIKit
import RxSwift
import ObjectMapper

class ExampleViewModel: BaseViewModel {

    typealias T = ConstructorSuperClass

    // ConstructorSuperClass is used as example as a default class to create tableView
    // your own class must be implemented to treat data you need

    public init(){}

    private var repo: ExampleInteractor!

    public init(interactor: ExampleInteractor) {
        repo = interactor
    }

    open func firstAction() {
        repo?.action()
    }

    func getObjects() -> Observable<[ConstructorSuperClass]> {
        return repo!.getObjects()
    }

    func sendRequest<R: MapExampleObject>(type: R, request: ObjectAPIRequest) -> Observable<MapExampleObject> {
        return repo!.sendRequest(request: request)
            .flatMap({ response -> Observable<MapExampleObject> in
                return Observable.just(response.dictionary ?? MapExampleObject())
            })
    }
    
    // Universal API data access
    
    func getDictionaryData<R: RObject>(object: RObject, typeOf: R.Type) -> Observable<R> {
        return repo.sendRequest(request: object.request)
            .flatMap({ response -> Observable<R> in
                return Observable.just(response.dictionary!)
            })
    }
    
    // WXObject or RObject? maybe should be one superClass
    
    func getArrayData<R: WXObject>(object: RObject, typeOf: R.Type) -> Observable<[R]> {
        return repo.sendRequest(request: object.request)
            .flatMap({ response -> Observable<[R]> in
                return Observable.just(response.array! as [R])
            })
    }

}

class ExampleViewModel2: BaseViewModel {

    typealias T = String

    public init(){}

    private var repo: ExampleInteractor? = nil
    private var repo2: ExampleInteractor2? = nil

    public init(interactor: ExampleInteractor, interactor2: ExampleInteractor2) {
        repo = interactor
        repo2 = interactor2
    }

    open func firstAction() {
        repo?.action()
    }

    open func secondAction() {
        repo2?.action()
    }

}

class ExampleViewModel3: BaseViewModel {

    typealias T = Bool

    public init(){}

    private var repo: ExampleInteractor? = nil
    private var repo2: ExampleInteractor2? = nil
    private var repo3: ExampleInteractor3? = nil

    public init(interactor: ExampleInteractor, interactor2: ExampleInteractor2, interactor3: ExampleInteractor3) {
        repo = interactor
        repo2 = interactor2
        repo3 = interactor3
    }

    open func firstAction() {
        repo?.action()
    }

    open func secondAction() {
        repo2?.action()
    }

    open func thirdAction() {
        repo3?.action()
    }

}
