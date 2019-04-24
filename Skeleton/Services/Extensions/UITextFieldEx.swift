//
//  UITextFieldEx.swift
//  Skeleton
//
//  Created by Woxapp on 21.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit

extension UITextField {

    func passwordTextEntry(secure: Bool) {
        resignFirstResponder()
        isSecureTextEntry = secure
        let tempText = self.text
        text = " "
        text = tempText
        becomeFirstResponder()
    }

    @IBInspectable var placeholderColor: UIColor? {
        get {
            return self.placeholderColor
        }
        set {
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [.foregroundColor: newValue!])
        }
    }

}
