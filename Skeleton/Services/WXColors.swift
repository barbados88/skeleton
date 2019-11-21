//
//  WXColors.swift
//  Skeleton
//
//  Created by User on 21.11.2019.
//

import UIKit

enum WXColors {
    
    case mainAppColor, appErrorColor, appMainTextColor, detailsTextColor, screenTitleColor, screenBackgroundColor
    
    var color: UIColor {
        switch self {
        case .mainAppColor: return UIColor(red: 173 / 255.0, green: 20 / 255.0, blue: 47 / 255.0, alpha: 1)
        case .appErrorColor: return UIColor(red: 254 / 255, green: 56 / 255.0, blue: 36 / 255.0, alpha: 1)
        case .appMainTextColor: return UIColor.darkGray
        case .detailsTextColor: return UIColor.lightGray
        case .screenTitleColor: return UIColor(red: 74 / 255.0, green: 74 / 255.0, blue: 74 / 255.0, alpha: 1.0)
        case .screenBackgroundColor: return UIColor(red: 230 / 255.0, green: 237 / 255.0, blue: 239 / 255.0, alpha: 1.0)
        }
    }
    
}
