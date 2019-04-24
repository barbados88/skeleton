//
//  WXCollectionConstructor.swift
//  Skeleton
//
//  Created by Woxapp on 08.02.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit

class WXCollectionConstructor: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var handler: TableHandler? = nil

    var insideOffset: CGPoint = CGPoint.zero
    var info: ConstructorSuperClass = ConstructorSuperClass() {
        didSet {
            reloadCells()
        }
    }
    var collectionView: UICollectionView = UICollectionView() {
        didSet {
            registerNIBs()
        }
    }

    private var isLoading: Bool = false

    public init(collectionView: UICollectionView, info: ConstructorSuperClass, refreshable: Bool = false) {
        super.init()
        self.collectionView = collectionView
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.registerNIBs()
        self.info = info
        self.collectionView.reloadData()
    }

    private func registerNIBs() {
        for id in WXIdentifier.cells {
            collectionView.register(UINib(nibName: id.rawValue.firstUppercased, bundle: nil), forCellWithReuseIdentifier: id.rawValue)
        }
        for id in WXIdentifier.headers {
            collectionView.register(UINib(nibName: id.rawValue.firstUppercased, bundle: nil), forSupplementaryViewOfKind: id.rawValue, withReuseIdentifier: id.rawValue)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return info.sectionInfo[section].data.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return info.sectionInfo[indexPath.section].data[indexPath.row].size
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = info.sectionInfo[indexPath.section].data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: data.identifier.rawValue, for: indexPath)
        cell.configure(data)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        info.sectionInfo[indexPath.section].data[indexPath.row].action()
    }

    private func reloadCells() {
        collectionView.reloadData()
    }

    // MARK: - UIScrollView methods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {}

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}

}
