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
