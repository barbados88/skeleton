//
//  EnumError.swift
//  VipCoin
//
//  Created by Woxapp on 11.01.2018.
//  Copyright © 2018 Woxapp. All rights reserved.
//

import UIKit

protocol EnumErrorProtocol {

    var title: String? { get }

}

enum PhoneError: EnumErrorProtocol {

    case none
    case short
    case long
    case exist

    var title: String? {
        switch self {
        case .none: return nil
        case .short: return NSLocalizedString("Слишком короткий номер", comment: "")
        case .long: return NSLocalizedString("Слишком длинный номер", comment: "")
        case .exist: return NSLocalizedString("Номер не зарегистрирован", comment: "")
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
        case .short: return NSLocalizedString("Пароль должен быть не меньше 6 символов", comment: "")
        case .mismatch: return NSLocalizedString("Пароли не совпадают", comment: "")
        case .error: return NSLocalizedString("Неверный пароль", comment: "")
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
        case .touch: return NSLocalizedString("Войти в приложение используя TouchID?", comment: "")
        case .face: return NSLocalizedString("Войти в приложение используя FaceID?", comment: "")
        }
    }

    var explanation: String? {
        switch self {
        case .none: return nil
        case .touch: return NSLocalizedString("Для использования разблокировки по Touch ID необходимо настроить Touch ID в настройках приложения.", comment: "")
        case .face: return NSLocalizedString("Для использования разблокировки по FaceID ID необходимо настроить FaceID ID в настройках приложения.", comment: "")
        }
    }

}
