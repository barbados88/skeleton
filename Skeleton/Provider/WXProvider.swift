//
//  WXProvider.swift
//  Skeleton
//
//  Created by Woxapp on 11.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

class WXProvider: NSObject {

    static let shared: WXProvider = WXProvider()

    private var iProvider: InteractorProvider = InteractorProvider()
    var mProvider: ViewModelProvider = ViewModelProvider()

    public override init() {
        super.init()
        iProvider.provideIntercators()
        mProvider = ViewModelProvider(interactorProvider: iProvider)
        mProvider.provideModels()
    }

}
