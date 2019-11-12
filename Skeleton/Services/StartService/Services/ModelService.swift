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

    // use this func to get access to realm from several sources
    // for example: app and today extension will use the same db
    
    private func migrateSharedDB() {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "YOUR_GROUP_IDENTIFIER")
        var config = Realm.Configuration()
        config.schemaVersion = DBVersion
        config.fileURL = container!.appendingPathComponent("default.realm")
        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < DBVersion {
                // do the stuff
            }
        }
        Realm.Configuration.defaultConfiguration = config
        _ = try? Realm()
    }
    
}
