import UIKit
import ObjectMapper
import RealmSwift
import Alamofire

class ExampleObject: WXObject {

    @objc dynamic var details: String? = nil

    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        details <- map["details"]
    }

}

class MapExampleRequest: ObjectRequest {

    var request: String = "https://raw.githubusercontent.com/tristanhimmelman/AlamofireObjectMapper/d8bb95982be8a11a2308e779bb9a9707ebe42ede/sample_json"
    var parameters: [String: Any] = [:]
    var method: HTTPMethod = .get

}

class MapExampleObject: WXObject {

    @objc dynamic var location: String? = nil
    var list = List<Forecast>()

    override var request: ObjectAPIRequest {
        return .getObject(MapExampleRequest())
    }

    override func mapping(map: Map) {
        location <- map["location"]
        list <- (map["three_day_forecast"], RealmListTransform<Forecast>())
    }

}

class Forecast: WXObject {

    @objc dynamic var conditions: String? = nil
    @objc dynamic var day: String? = nil
    @objc dynamic var temperature: Int = 0

    override func mapping(map: Map) {
        conditions <- map["conditions"]
        day <- map["day"]
        temperature <- map["temperature"]
    }

}
