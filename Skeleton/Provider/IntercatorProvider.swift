//
//  IntercatorProvider.swift
//  Skeleton
//
//  Created by Woxapp on 11.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

class InteractorProvider: NSObject {

    var interactor: ExampleInteractor = ExampleInteractor()
    var interactor2: ExampleInteractor2 = ExampleInteractor2()
    var interactor3: ExampleInteractor3 = ExampleInteractor3()

    open func provideIntercators() {
        interactor = ExampleInteractor()
        interactor2 = ExampleInteractor2()
        interactor3 = ExampleInteractor3()
    }

}
