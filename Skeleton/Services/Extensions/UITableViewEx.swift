//
//  UITableViewEx.swift
//  Skeleton
//
//  Created by Woxapp on 10.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

extension UITableView {

    func addFooterLoader() {
        if isLoaderOn == true {return}
        sectionFooterHeight = 35.0
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: sectionFooterHeight))
        footerView.backgroundColor = .clear
        footerView.addSubview(ActivityFooterView.configure())
        tableFooterView = footerView
        perform(#selector(self.reloadWithDelay), with: nil, afterDelay: 1)
    }

    func removeFooterLoader() {
        if isLoaderOn == false {return}
        sectionFooterHeight = 0.0
        tableFooterView = nil
        perform(#selector(self.reloadWithDelay), with: nil, afterDelay: 1)
    }

    @objc private func reloadWithDelay() {
        reloadData()
    }

    private var isLoaderOn : Bool {
        if tableFooterView == nil {return false}
        for footer in tableFooterView!.subviews {
            if footer is ActivityFooterView {
                return true
            }
        }
        return false
    }

}
