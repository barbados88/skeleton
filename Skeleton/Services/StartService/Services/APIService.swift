import UIKit

class APIService: NSObject {

    override init() {
        super.init()
        print("init apis")
        ReachabilityManager.shared.startMonitoring()
    }

}
