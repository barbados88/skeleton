import UIKit

extension UILabel {

    func textWithSearchBarText(searchText: String) {
        if let text = self.text {
            attributedText = stringWithSearchBarString(string: text, other: searchText)
        } else {
            attributedText = NSAttributedString()
        }
    }

    fileprivate func stringWithSearchBarString(string: String, other: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        if other.count == 0 {
            return attributedString
        }
        let dotRanges: [NSRange]
        do {
            let regex = try NSRegularExpression(pattern: other.lowercased(), options: [])
            dotRanges = regex.matches(in: string.lowercased(), options: [], range: NSMakeRange(0, string.count)).map {$0.range}
        } catch {
            dotRanges = []
        }
        let rangeColor = WXColors.mainAppColor.color
        for dotRange in dotRanges {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: rangeColor, range: dotRange)
        }
        return attributedString
    }

    func animateError() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.1
        animation.duration = 0.2
        animation.repeatCount = 2.0
        animation.autoreverses = true
        layer.add(animation, forKey: nil)
    }

    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(font.pointSize))
        return rHeight / charSize
    }

}
