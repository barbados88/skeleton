//
//  ModelService.swift
//  Skeleton
//
//  Created by Woxapp on 10.04.2019.
//  Copyright © 2019 Woxapp. All rights reserved.
//

import UIKit
import RealmSwift

let DBVersion: UInt64 = 0

class ModelService: NSObject {

    override init() {
        super.init()
        print("init models")
        _ = WXProvider.shared
        migrateDB()
    }

    private func migrateDB() {
        Realm.Configuration.defaultConfiguration =
            Realm.Configuration(
                schemaVersion: DBVersion,
                migrationBlock: { migration, oldSchemaVersion in
                    if oldSchemaVersion < DBVersion {
                        // do the stuff
                    }
            })
        _ = try? Realm()
    }

}
