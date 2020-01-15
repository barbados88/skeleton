import UIKit

enum TabBarAnimationType {

    case simple
    case circular

    var classObject: WXAnimation {
        switch self {
        case .simple: return SimpleAnimation()
        case .circular: return CircularAnimation()
        }
    }
    
}

class WXAnimation: NSObject {
    
    var tabBar: UITabBar! {
        didSet {
            customInit()
        }
    }
    
    public func animate(to: Int) {}
 
    public func customInit() {}
    
}

class TabBarAnimation: NSObject {

    var type: TabBarAnimationType = .simple {
        didSet {
            animation = type.classObject
        }
    }
    private var tabBar: UITabBar = UITabBar()
    private var animation: WXAnimation!

    public init(with bar: UITabBar, animation: TabBarAnimationType) {
        super.init()
        tabBar = bar
        type = animation
    }

    open func animateTo(index: Int) {
        animation.tabBar = tabBar
        animation.animate(to: index)
    }

}
