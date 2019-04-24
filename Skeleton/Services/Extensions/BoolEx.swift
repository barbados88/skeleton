import UIKit

extension Bool {

    var toInt: Int {
        return self == true ? 1 : 0
    }

    var toString: String {
        return self == true  ? "1" : "0"
    }

}
