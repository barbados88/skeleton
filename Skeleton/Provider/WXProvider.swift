import UIKit

class WXProvider: NSObject {

    static let shared: WXProvider = WXProvider()

    private var iProvider: InteractorProvider = InteractorProvider()
    var mProvider: ViewModelProvider = ViewModelProvider()
    var router: WXRouter!

    public override init() {
        super.init()
        iProvider.provideIntercators()
        mProvider = ViewModelProvider(interactorProvider: iProvider)
        mProvider.provideModels()
    }

}
