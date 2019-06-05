import UIKit
import ObjectMapper

class RObject: NSObject, Mappable {
    
    open var request: ObjectAPIRequest {
        return .getObject(ObjectGetRequest())
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        print("let's map object")
    }
    
}
