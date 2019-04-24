//
//  ViewModelProvider.swift
//  Skeleton
//
//  Created by Woxapp on 11.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

class ViewModelProvider: NSObject {

    private var iProvider: InteractorProvider = InteractorProvider()

    var viewModel: ExampleViewModel = ExampleViewModel()
    var viewModel2: ExampleViewModel2 = ExampleViewModel2()
    var viewModel3: ExampleViewModel3 = ExampleViewModel3()

    public override init() {}

    public init(interactorProvider: InteractorProvider) {
        super.init()
        iProvider = interactorProvider
    }

    open func provideModels() {
        viewModel = ExampleViewModel(interactor: iProvider.interactor)
        viewModel2 = ExampleViewModel2(interactor: iProvider.interactor, interactor2: iProvider.interactor2)
        viewModel3 = ExampleViewModel3(interactor: iProvider.interactor, interactor2: iProvider.interactor2, interactor3: iProvider.interactor3)
    }

}
