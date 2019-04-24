import UIKit

extension UIColor {

    class func rgb(_ red: CGFloat = 255.0, _ green: CGFloat = 255.0, _ blue: CGFloat = 255.0, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }

}
