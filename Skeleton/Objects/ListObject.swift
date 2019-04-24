//
//  ListObject.swift
//  VipCoin
//
//  Created by Woxapp on 10.01.2018.
//  Copyright © 2018 Woxapp. All rights reserved.
//

import UIKit
import RealmSwift

typealias SelectBlock = (ChainedObject?) -> Void

class ListObject {

    var sortedValues: [String: [ChainedObject]] = [:]
    var chainedObjects: [ChainedObject] {
        return sortedValues.values.flatMap { return $0 }
    }
    var headers: [String] {
        return Array(sortedValues.keys)
    }

    // should be initialized to handle tap
    var block: SelectBlock?

    // should be overriden to perform object action
    func action(object: ChainedObject) {}

    var title: String? = nil
    var selectedIndex: Int {
        return chainedObjects.lastIndex(where: { return $0.isSelected == true }) ?? 0
    }

}

class ChainedObject: NSObject {

    var name: String? = NSLocalizedString("Undefined name", comment: "")
    var details: String? = nil
    var id: Int = 0
    var isSelected: Bool = false
    var object: Object? = nil

}
