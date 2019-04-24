//
//  Xmpl3ViewController.swift
//  Skeleton
//
//  Created by Woxapp on 11.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

class Xmpl3ViewController: DarkViewController {

    private lazy var viewModel: ExampleViewModel3 = {
        return WXProvider.shared.mProvider.viewModel3
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

    @IBAction func thirdAction(_ sender: Any) {
        viewModel.thirdAction()
    }

}
