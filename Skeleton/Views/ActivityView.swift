import UIKit

class ActivityFooterView: UIView {

    static func configure() -> ActivityFooterView {
        let view = Bundle.main.loadNibNamed("ActivityFooterView", owner: nil, options: nil)?.first as! ActivityFooterView
        view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width : UIScreen.main.bounds.size.width, height: 35))
        return view
    }

}

class ActivityView: UIView {

    static func configure(with size: CGSize = UIScreen.main.bounds.size) -> ActivityView {
        let view = Bundle.main.loadNibNamed("ActivityView", owner: nil, options: nil)?.first as? ActivityView ?? ActivityView()
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        return view
    }

}
