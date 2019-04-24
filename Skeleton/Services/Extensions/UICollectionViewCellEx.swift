//
//  UICollectionViewCellEx.swift
//  Skeleton
//
//  Created by Woxapp on 08.02.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

extension UICollectionViewCell {

    var collectionView: UICollectionView? {
        var sView = superview
        if sView is UICollectionView {
            return sView as? UICollectionView
        }
        while sView != nil {
            sView = sView?.superview
            if sView is UICollectionView {
                return sView as? UICollectionView
            }
        }
        return nil
    }

    func calculateHeightForConfiguredSizingCell() -> CGFloat {
        setNeedsLayout()
        layoutIfNeeded()
        return contentView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height + 1.0
    }

    @objc func configure(_ data: AnyObject) {}

}
