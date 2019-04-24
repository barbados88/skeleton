//
//  WXTableConstructor.swift
//  Skeleton
//
//  Created by Woxapp on 08.02.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift

class WXTableConstructor: NSObject, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var handler: TableHandler? = nil

    var insideOffset: CGPoint = CGPoint.zero
    var info: ConstructorSuperClass = ConstructorSuperClass() {
        didSet {
            reloadCells()
        }
    }
    var tableView: UITableView = UITableView() {
        didSet {
            registerNIBs()
        }
    }

    private var pickerHeight: CGFloat = 162
    private var isLoading: Bool = false
    private var dateCase: [IndexPath] = []
    private let refresh = UIRefreshControl()
    private weak var viewController: UIViewController? = nil

    private var vc: UIViewController? {
        if viewController != nil { return viewController }
        viewController = UIApplication.topViewController()
        return viewController
    }

    public init(tableView: UITableView, info: ConstructorSuperClass, refreshable: Bool = false) {
        super.init()
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerNIBs()
        self.info = info
        self.tableView.reloadData()
        if refreshable == true { addRefreshControl() }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return info.sectionInfo.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section < info.sectionInfo.count ? info.sectionInfo[section].data.count : 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = info.sectionInfo[indexPath.section].data[indexPath.row].cellHeight
            else {
                return dateCase.contains(indexPath) ? info.sectionInfo[indexPath.section].cellHeight + pickerHeight : info.sectionInfo[indexPath.section].cellHeight
        }
        return dateCase.contains(indexPath) ? height + pickerHeight : height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return info.sectionInfo[section].footer?.height ?? 0.1
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return info.sectionInfo[section].header?.height ?? 0.1
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let identifier = info.sectionInfo[section].header?.identifier ?? WXIdentifier.alignmentHeader
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier.rawValue) as? Header
        header?.headerLabel.text = info.sectionInfo[section].header?.text
        header?.counterLabel?.text = info.sectionInfo[section].header?.textDetails
        header?.headerLabel.textColor = info.sectionInfo[section].header?.textColor ?? UIColor(red: 155 / 255.0, green: 155 / 255.0, blue: 155 / 255.0, alpha: 1.0)
        header?.headerLabel.textAlignment = info.sectionInfo[section].header?.textAlignment ?? .left
        if info.sectionInfo[section].header?.backgroundColor != nil {
            header?.colorView.backgroundColor = info.sectionInfo[section].header?.backgroundColor
        }
        return header
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let identifier = info.sectionInfo[section].footer?.identifier ?? WXIdentifier.alignmentHeader
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier.rawValue) as? Header
        footer?.headerLabel.text = info.sectionInfo[section].footer?.text
        footer?.headerLabel.textColor = info.sectionInfo[section].footer?.textColor ?? UIColor(red: 155 / 255.0, green: 155 / 255.0, blue: 155 / 255.0, alpha: 1.0)
        footer?.headerLabel.textAlignment = info.sectionInfo[section].footer?.textAlignment ?? .left
        if let color = info.sectionInfo[section].footer?.backgroundColor {
            footer?.colorView.backgroundColor = color
        }
        if let font = info.sectionInfo[section].footer?.font {
            footer?.headerLabel.font = font
        }
        if let attString = info.sectionInfo[section].footer?.attributedText {
            footer?.headerLabel.attributedText = attString
        }
        return footer
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = info.sectionInfo[indexPath.section].data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: data.identifier.rawValue, for: indexPath)
        cell.accessoryType = data.cellType
        cell.selectedBackgroundView = SelectionView(frame: cell.frame)
        cell.tag = indexPath.row
        cell.configure(data as AnyObject)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = info.sectionInfo[indexPath.section].data[indexPath.row]
        data.action()
        handler?(indexPath, data.info)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {}

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return info.sectionInfo[indexPath.section].data[indexPath.row].isEditable
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return info.sectionInfo[indexPath.section].data[indexPath.row].rowActions
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        info.sectionInfo[indexPath.section].data[indexPath.row].action(nil)
    }

    private func registerNIBs() {
        for id in WXIdentifier.cells {
            tableView.register(UINib(nibName: id.rawValue.firstUppercased, bundle: nil), forCellReuseIdentifier: id.rawValue)
        }
        for id in WXIdentifier.headers {
            tableView.register(UINib(nibName: id.rawValue.firstUppercased, bundle: nil), forHeaderFooterViewReuseIdentifier: id.rawValue)
        }
    }

    private func reloadCells() {
        refresh.endRefreshing()
        tableView.reloadData()
    }

    // MARK: - Helper methods

    private func addRefreshControl() {
        let tvc = UITableViewController()
        tvc.tableView = tableView
        tableView.addSubview(refresh)
        refresh.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }

    @objc private func refreshData(_ sender: UIRefreshControl) {
        vc?.refreshData { [weak self] _ in
            self?.tableView.sendSubviewToBack(sender)
            sender.endRefreshing()
        }
    }

    // MARK: - UIScrollView methods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {}

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}

}

// USAGE: https://github.com/RxSwiftCommunity/RxDataSources

class WXTableConstructorRx: WXTableConstructor {

    private var disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedReloadDataSource<HFSuperClass>?
    let sections = PublishSubject<[HFSuperClass]>()

    public override init(tableView: UITableView, info: ConstructorSuperClass, refreshable: Bool = false) {
        super.init(tableView: tableView, info: info, refreshable: refreshable)

        // setting to nil because it must have own delegate and dataSource not superclass
        
        tableView.delegate = nil
        tableView.dataSource = nil

        dataSource = RxTableViewSectionedReloadDataSource<HFSuperClass>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier.rawValue, for: indexPath)
                cell.configure(item as AnyObject)
                return cell
            })

        sections
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource!))
            .disposed(by: disposeBag)
        sections.onNext(info.sectionInfo)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        // all delegate methods perfromed in superclass
        // can be overriden below
        // or rx datasource methods can be used instead

    }

    func updateSectionsTo(info: ConstructorSuperClass) {
        self.info = info
        sections.onNext(info.sectionInfo)
    }

}
