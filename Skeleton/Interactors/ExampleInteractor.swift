//
//  ExampleInteractor.swift
//  Skeleton
//
//  Created by Woxapp on 11.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class ExampleInteractor: BaseInteractor {

    typealias T = ConstructorSuperClass

    // ConstructorSuperClass is used as example as a default class to create tableView
    // your own class must be implemented to treat data you need

    private var communicator = CommunicatorRx.shared

    func action() {
        ServerError.show(alert: "Example interactor")
    }

    func getObjects() -> Observable<[ConstructorSuperClass]> {
        // here will be request to database or server to get data
        // or both in subscribe block mapped object could be converted
        // in flatmap observable converted object will be returned to viewModel

        return Observable
            .just([SomeDataClass(sectionsVs: true)])
    }

    func sendRequest<R: Mappable>(request: ObjectAPIRequest) -> Observable<WXResponse<R>> {
        return CommunicatorRx.shared.objectRequest(object: request)
    }

}

class ExampleInteractor2: BaseInteractor {

    typealias T = Bool

    func action() {
        ServerError.show(alert: "Second Example interactor")
    }

}

class ExampleInteractor3: BaseInteractor {

    typealias T = String

    func action() {
        ServerError.show(alert: "Third Example interactor")
    }

}
