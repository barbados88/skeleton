import UIKit
import RealmSwift

class Utils: NSObject {

    static let shared = Utils()

    var staticRealm: Realm {
        return try! Realm()
    }

    class func realm(_ block: (Realm) -> Void) {
        let realm = Utils.shared.staticRealm
        if realm.isInWriteTransaction == true {
            block(realm)
        } else {
            try? realm.write {
                block(realm)
            }
        }
    }

}
