import UIKit
import RealmSwift
import Alamofire
import ObjectMapper

protocol ObjectRequest {

    var request: String { set get }
    var parameters: [String: Any] { set get }
    var method: Alamofire.HTTPMethod { set get }
    var headers: [String: String]? { set get }

}

class ObjectGetRequest: ObjectRequest {

    public init() {}

    public init(with object: WXObject) {
        // here parameters value can be implemented
    }

    var request: String = APIConfigs.request(part: "")
    var parameters: [String: Any] = [:] // mappers should be used
    var method: Alamofire.HTTPMethod = .get
    var headers: [String: String]? = nil

}

// if needed could be implement in any db class
// realm Object must inherite of WXObject

enum ObjectAPIRequest {

    case getObject(ObjectRequest)

    var current: ObjectRequest {
        switch self {
        case .getObject(let req): return req
        }
    }

}

class WXObject: Object, Mappable {

    @objc dynamic var id: Int = 0
    @objc dynamic var name: String? = nil

    open var request: ObjectAPIRequest {
        return .getObject(ObjectGetRequest())
    }

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        print("let's map object")
    }

    override open class func ignoredProperties() -> [String] {
        return ["reuqest"]
    }
    
    override open class func primaryKey() -> String {
        return "id"
    }
    
    static func existed<T: WXObject>(useId: Int = Session.id) -> T {
        guard
            let object = Utils.shared.staticRealm.object(ofType: T.self, forPrimaryKey: useId)
            else {
                let some = T()
                some.id = useId
                some.writeBlock { realm in
                    realm.add(some, update: .all)
                }
                return self.existed()
        }
        return object.detached()
    }
    
    func saveToRealm() {
        writeBlock { realm in
            realm.schema[(type(of: self) as Object.Type).className()]?.primaryKeyProperty != nil ? realm.add(self, update: .modified) : realm.add(self)
        }
    }

}
