//
//  ApplicationInitManager.swift
//  Skeleton
//
//  Created by Woxapp on 10.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

struct ApplicationInitService {

    private let library: LibraryService = LibraryService()
    private let api: APIService = APIService()
    private let ui: UIService = UIService()
    private let model: ModelService = ModelService()

}
