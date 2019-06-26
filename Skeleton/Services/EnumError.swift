import UIKit

public protocol EnumErrorProtocol {

    var title: String? { get }

}

class DefaultError: EnumErrorProtocol {
    
    var title: String? {
        return NSLocalizedString("value_is_nil", comment: "")
    }
    
}

enum WXValidationEnum {
    
    case none, error(String)
    
}

class WXValidationError: EnumErrorProtocol {
    
    public init() {}
    
    public init(with enumValue: WXValidationEnum) {
        value = enumValue
    }
    
    var value: WXValidationEnum = .none
    
    var title: String? {
        switch value {
        case .none: return nil
        case .error(let string): return string
        }
    }
    
}

enum PhoneError: EnumErrorProtocol {

    case none
    case short
    case long
    case exist

    var title: String? {
        switch self {
        case .none: return nil
        case .short: return NSLocalizedString("value_too_short", comment: "")
        case .long: return NSLocalizedString("value_too_long", comment: "")
        case .exist: return NSLocalizedString("not_registered", comment: "")
        }
    }

}

enum PasswordError: EnumErrorProtocol {

    case none
    case short
    case mismatch
    case error

    var title: String? {
        switch self {
        case .none: return nil
        case .short: return NSLocalizedString("password_too_short", comment: "")
        case .mismatch: return NSLocalizedString("passwords_not_equal", comment: "")
        case .error: return NSLocalizedString("wrong_password", comment: "")
        }
    }

}

enum IDError: EnumErrorProtocol {

    case none
    case touch
    case face

    var title: String? {
        switch self {
        case .none: return nil
        case .touch: return NSLocalizedString("touch_id_enter", comment: "")
        case .face: return NSLocalizedString("face_id_enter", comment: "")
        }
    }

    var explanation: String? {
        switch self {
        case .none: return nil
        case .touch: return NSLocalizedString("touch_id_description", comment: "")
        case .face: return NSLocalizedString("face_id_description", comment: "")
        }
    }

}
