import UIKit

class Header: UITableViewHeaderFooterView {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel?
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var checkButton: UIButton?

    var section: Int = 0

}
