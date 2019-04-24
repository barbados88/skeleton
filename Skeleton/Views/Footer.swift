import UIKit

protocol FooterProtocol {

    var title: String? { get }
    var nibName: String? { get }
    var height: CGFloat { get }

}

class Footer: UITableViewHeaderFooterView {

    weak var footerDelegate: FooterDelegate? = nil

}
