import UIKit

typealias ImageBlock = (UIImage?) -> Void

class DefaultCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var detailsLabel: UILabel?

    var object: Any? = nil

    override func configure(_ data: AnyObject) {
        guard let data = data as? CellSuperClass
            else {
                return
        }
        configure(with: data)
    }

    private func configure(with data: CellSuperClass) {
        nameLabel?.text = data.info?.title
        detailsLabel?.text = data.info?.details
        nameLabel?.textColor = data.cellSettings[.textColor] as? UIColor
        nameLabel?.font = data.cellSettings[.titleFont] as? UIFont
    }

}
