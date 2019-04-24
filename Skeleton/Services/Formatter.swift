//
//  Formatter.swift
//  Skeleton
//
//  Created by Woxapp on 21.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit

enum Format: String {

    case server = "yyyy-MM-dd HH:mm:ss"
    case activity = "yyyy-MM-dd HH:mm"
    case shortActivity = "MM-dd HH:mm"
    case dateWithTime = "dd.MM.yyyy (HH:mm)"
    case anchor = "yyyy-MM-dd"
    case dateYearLong = "dd.MM.yyyy"
    case dateYearShort = "dd.MM.yy"
    case timeWithSeconds = "HH:mm:ss"
    case time = "HH:mm"
    case zz = "d MMMM, EEEE."
    case record = "EE, dd.MM.yy"
    case day = "dd.MM"
    case weekDay = "EEEE"
    case month = "MMM"
    case year = "yyyy"
    case cart = "HH:mm, dd.MM.yyyy"
    case bank = "MM/yy"
    case header = "dd MMMM yyyy"
    case transfer = "dd.MM.yyyy\nHH:mm"

}

enum PhoneNumberFormat: String {

    case mobile = "xxx xx xx"

}

class Formatter: NSObject {

    static func formatter(using format: Format) -> DateFormatter {
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter
    }

    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    } ()

    static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        return formatter
    } ()

    static func phoneNumber(number: String, code: String) -> String {
        let codePart = "+\(code)"
        var phonePart = ""
        var number = number
        for character in PhoneNumberFormat.mobile.rawValue {
            if number.last == nil {
                break
            }
            if character == "x" {
                phonePart = String(number.last!) + phonePart
                number = String(number.dropLast())
            } else {
                phonePart = String(character) + phonePart
            }
        }
        return "\(codePart) \(number) \(phonePart)"
    }

}
