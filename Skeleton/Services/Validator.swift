import UIKit

public protocol ValidateOption {

    var pattern: String { get }
    var predicate: NSPredicate { get }
    var body: String { set get }
    var item: ValidateItem { set get }

}

public enum ValidateItem: String {

    case name = "[A-Za-z-\\p{Cyrillic}]{3,}"
    case phone = "[0-9]{9,11}"
    case cellPhone = "\\+[0-9]{12,17}"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    case link = ""
    case youtube = "^((?:https?:)?\\/\\/)?((?:www|m)\\.)?((?:youtube\\.com|youtu.be))(\\/(?:[\\w\\-]+\\?v=|embed\\/|v\\/)?)([\\w\\-]+)(\\S+)?$"
    case numbers = "[0-9]"
    case password = "[A-Z0-9a-z-\\p{Cyrillic}]{5,}"
    case floats = "(\\d+(\\,\\d+)?)"

}

public struct ValidValue: ValidateOption {

    public var body: String
    public var item: ValidateItem

    public var pattern: String {
        return item.rawValue
    }

    public var predicate: NSPredicate {
        switch item {
        case .name, .phone, .email, .youtube, .numbers, .cellPhone, .password, .floats: return NSPredicate(format: "SELF MATCHES %@", pattern)
        case .link: return NSPredicate()
        }
    }

    public var isValid: Bool {
        return item == .link ? isValidLink : predicate.evaluate(with: body)
    }

    private var isValidLink: Bool {
        guard let url = URL(string: self.body)
            else {
                return false
        }
        return UIApplication.shared.canOpenURL(url)
    }

    public init(body: String, type: ValidateItem) {
        self.body = body
        self.item = type
    }

}

open class Validator: NSObject {

    class func isValid(_ some: String?, type: ValidateItem) -> Bool {
        guard let some = some
            else {
                return false
        }
        return ValidValue(body: some, type: type).isValid
    }

}
