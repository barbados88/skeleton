//
//  Xmpl2ViewController.swift
//  Skeleton
//
//  Created by Woxapp on 11.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

class Xmpl2ViewController: LightViewController {

    private lazy var viewModel: ExampleViewModel2 = {
        return WXProvider.shared.mProvider.viewModel2
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions

    @IBAction func firstAction(_ sender: Any) {
        viewModel.firstAction()
    }

    @IBAction func secondAction(_ sender: Any) {
        viewModel.secondAction()
    }

}
