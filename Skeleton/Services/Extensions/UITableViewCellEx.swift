//
//  UITableViewCellEx.swift
//  Skeleton
//
//  Created by Woxapp on 21.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit

extension UITableViewCell {

    var tableView: UITableView? {
        var sView = superview
        if sView is UITableView {
            return sView as? UITableView
        }
        while sView != nil {
            sView = sView?.superview
            if sView is UITableView {
                return sView as? UITableView
            }
        }
        return nil
    }

    func leftSeparatorInset(_ left: CGFloat) {
        if responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins)) {
            layoutMargins = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
        }
        if responds(to: #selector(getter: UITableViewCell.separatorInset)) {
            separatorInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
        }
    }

    func calculateHeightForConfiguredSizingCell() -> CGFloat {
        setNeedsLayout()
        layoutIfNeeded()
        return contentView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height + 1.0
    }

    @objc func configure(_ data: AnyObject) {}

}
