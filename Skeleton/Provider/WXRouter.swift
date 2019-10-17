//
//  WXRouter.swift
//  Skeleton
//
//  Created by User on 10/17/19.
//

import UIKit

class RouterModel: NSObject {
    
    var info: Info!
    
    var tableSettings: ((UITableView) -> ())? = { _ in }
    var navigationSettings: ((UINavigationController?) -> ())? = { nvc in }
    var onDataUpdate: (ConstructorSuperClass) -> () = { _ in }
    
}

class WXRouter: NSObject {

    private var navigationController: NavigationController? = nil
    
    public init(with navigation: NavigationController) {
        super.init()
        navigationController = navigation
    }
    
    // MARK: - Helper methods

    public func show(controller: NotificatedViewController, animated: Bool = true) {
        navigationController?.pushViewController(controller, animated: animated)
    }
    
    public func present(controller: NotificatedViewController, animated: Bool = true, completion: (() -> ())? = nil) {
        navigationController?.present(controller, animated: animated, completion: completion)
    }
    
    public func showModel(model: RouterModel, animated: Bool = true) {
        let controller = NotificatedViewController.controller()
        controller.model = model
        show(controller: controller, animated: animated)
    }
    
    public func presentModel(model: RouterModel, animated: Bool = true) {
        let controller = NotificatedViewController.controller()
        controller.model = model
        present(controller: controller, animated: animated)
    }
    
}
