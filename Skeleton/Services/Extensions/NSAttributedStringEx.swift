import UIKit

extension NSAttributedString {

    func stringSize() -> CGSize {
        return self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
    }

}
