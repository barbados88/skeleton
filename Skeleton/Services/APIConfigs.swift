import UIKit

// TODO: create object instead

public struct APIConfigs {

    static var timeoutInterval: Double = 30
    public var userPhone: String = Session.phone?.replacingOccurrences(of: "+", with: "") ?? ""
    public var uuid: String = UIDevice.current.identifierForVendor!.uuidString
    public var accessToken: String = Session.accessToken ?? ""
    public var deviceToken: String = Session.deviceToken ?? ""
    public var userID: Int = Session.id

    static var apiPrefix: String {
        return ""
    }

    static var apiKey: String {
        return ""
    }

    static func request(part: String) -> String {
        return "\(apiPrefix)\(part)"
    }
    
    static var headers: [String: String] {
        return ["X-Signature": Session.accessToken ?? ""]
    }

}
