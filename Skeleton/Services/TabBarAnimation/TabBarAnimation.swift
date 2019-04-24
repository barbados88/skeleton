import UIKit

enum TabBarAnimationType {

    case simple
    case circular

}

class TabBarAnimation: NSObject {

    var type: TabBarAnimationType = .simple
    private var tabBar: UITabBar = UITabBar()
    private var simple: SimpleAnimation = SimpleAnimation()
    private var circular: CircularAnimation = CircularAnimation()

    public init(with bar: UITabBar) {
        super.init()
        tabBar = bar
    }

    open func animateTo(index: Int) {
        switch type {
        case .simple:
            simple.tabBar = tabBar
            simple.animate(to: index)
        case .circular:
            circular.tabBar = tabBar
            circular.transitionTo(index: index)
        }
    }

}
