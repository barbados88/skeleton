import UIKit

class NoInternetView: UIView {

    static let shared = NoInternetView()
    static let defaultHeight: CGFloat = 32
    static var height: CGFloat {
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
        return defaultHeight + statusBarHeight
    }
    private var views: [NoInternetView] = []
    
    private static func configure() -> NoInternetView {
        let view = Bundle.main.loadNibNamed("NoInternetView", owner: nil, options: nil)?.first as? NoInternetView ?? NoInternetView()
        view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: UIScreen.main.bounds.size.width, height: height))
        return view
    }
    
    static func show() {
        guard let sView = UIApplication.topViewController()?.view
            else {
                return
        }
        if sView.subviews.filter ({
            return $0 is NoInternetView
        }).first != nil {
            return
        }
        let view = NoInternetView.configure()
        shared.views.append(view)
        UIView.animate(withDuration: 0.3) {
            sView.frame = CGRect(x: 0, y: sView.frame.origin.y + height, width: sView.frame.size.width, height: sView.frame.size.height - height)
            sView.addSubview(view)
            sView.bringSubviewToFront(view)
        }
    }
    
    static func removeViewIfNeeded(from view: UIView) {
        removeExistedViews(array: view.subviews)
    }
    
    static func hide() {
        var addedViews: [NoInternetView] = []
        addedViews.append(contentsOf: shared.views)
        removeExistedViews(array: addedViews)
    }
    
    private static func removeExistedViews(array: [UIView]) {
        for view in array {
            if view is NoInternetView {
                if let index = shared.views.firstIndex(of: (view as! NoInternetView)) {
                    shared.views.remove(at: index)
                }
                if let sView = view.superview {
                    sView.frame = CGRect(x: 0, y: sView.frame.origin.y - height, width: sView.frame.size.width, height: sView.frame.size.height + height)
                }
                view.removeFromSuperview()
            }
        }
    }

}
