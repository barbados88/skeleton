import UIKit

enum SessionKey: String {

    case tutorial = "TUTORIAL_PASSED"
    case accessToken = "ACCESS_TOKEN"
    case name = "USER_NAME"
    case phone = "USER_PHONE"
    case mail = "USER_MAIL"
    case password = "USER_PASSWORD"
    case id = "USER_ID"
    case deviceToken = "DEVICE_TOKEN"

    static let allValues: [SessionKey] = [tutorial, accessToken, name, phone, mail, password, id, deviceToken]

}

// TODO: create object instead

class Session: NSObject {

    static var tutorial: Bool {
        get {
            return sessionValue(get: .tutorial) as? Bool ?? false
        }
        set {
            sessionValue(set: newValue, key: .tutorial)
        }
    }

    static var accessToken: String? {
        get {
            return sessionValue(get: .accessToken) as? String
        }
        set {
            sessionValue(set: newValue, key: .accessToken)
        }
    }

    static var name: String? {
        get {
            return sessionValue(get: .name) as? String
        }
        set {
            sessionValue(set: newValue, key: .name)
        }
    }

    static var phone: String? {
        get {
            return sessionValue(get: .phone) as? String
        }
        set {
            sessionValue(set: newValue, key: .phone)
        }
    }

    static var mail: String? {
        get {
            return sessionValue(get: .mail) as? String
        }
        set {
            sessionValue(set: newValue, key: .mail)
        }
    }

    static var password: String? {
        get {
            return sessionValue(get: .password) as? String
        }
        set {
            sessionValue(set: newValue, key: .password)
        }
    }

    static var id: Int {
        get {
            return sessionValue(get: .id) as? Int ?? 0
        }
        set {
            sessionValue(set: newValue, key: .id)
        }
    }

    static var deviceToken: String? {
        get {
            return sessionValue(get: .deviceToken) as? String
        }
        set {
            sessionValue(set: newValue, key: .deviceToken)
        }
    }

    private static func sessionValue(get key: SessionKey) -> Any? {
        sessionKey = key.rawValue
        return sessionValue
    }

    private static func sessionValue(set value: Any?, key: SessionKey) {
        sessionKey = key.rawValue
        sessionValue = value
    }

    private static var sessionKey: String {
        get {
            return (UserDefaults.standard.object(forKey: "key") as? String ?? "")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "key")
        }
    }

    private static var sessionValue: Any? {
        get {
            return UserDefaults.standard.object(forKey: sessionKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: sessionKey)
        }
    }

    static var tintColor: UIColor {
        return UIColor(red: 173 / 255.0, green: 20 / 255.0, blue: 47 / 255.0, alpha: 1)
    }

    static var appRedColor: UIColor {
        return UIColor(red: 254 / 255, green: 56 / 255.0, blue: 36 / 255.0, alpha: 1)
    }

}
