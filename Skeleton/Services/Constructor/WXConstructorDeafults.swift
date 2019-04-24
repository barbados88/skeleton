import UIKit
import RxDataSources

// will be invoked on table didSelectRow
// should be implemented to handle tap

typealias TableHandler = (IndexPath, DefaultObject?) -> ()

class ConstructorSuperClass: NSObject {

    var sectionInfo: [HFSuperClass] = []
}

class Info: ConstructorSuperClass {

    public init(with object: Any) {
        super.init()

    }

    public override init() {}

}

// default keys to use in cell implementation, will be parse by default

enum CellSettings {

    case titleTextColor
    case titleTextAlignment
    case titleFont
    case titleSize
    case detailsTextAlignment
    case detailsFont
    case detailsSize
    case textColor
    case textAlignment
    case textFont
    case textSize

}

// default object to fill standard cell fields

class DefaultObject: NSObject {

    var title: String? = nil
    var details: String? = nil
    var image: UIImage? = nil
    var object: Any? = nil

}

// class to override to use in case

class CellSuperClass: NSObject {

    var info: DefaultObject? = nil
    var isEditable: Bool = false
    var identifier: WXIdentifier = .def
    var cellType: UITableViewCell.AccessoryType = .none
    var cellHeight: CGFloat? = UITableView.automaticDimension
    var cellSettings: [CellSettings: Any] = [:]
    var rowActions: [UITableViewRowAction]? = nil
    var dictionary: [AnyHashable: Any]? = nil
    var size: CGSize = CGSize(width: 50, height: 50)
    
    func action(_ sender: Any? = nil, block: TableHandler? = nil) {}

    public override init() {
        super.init()
    }

}

// general class for header and footer, fields can be overriden with needs

class HeaderFooter: NSObject {

    var identifier: WXIdentifier = .header
    var height: CGFloat = 30
    var textAlignment: NSTextAlignment = .left
    var textColor: UIColor = .black
    var backgroundColor: UIColor = .white
    var font: UIFont = UIFont.systemFont(ofSize: 13)
    var text: String? = nil
    var textDetails: String? = nil
    var attributedText: NSAttributedString? = nil
    var attributedDetailsText: NSAttributedString? = nil

}

// class which represents array of sections with cells, contains default settings for header, footer and cell

struct HFSuperClass {

    var cellHeight: CGFloat = UITableView.automaticDimension
    var data: [CellSuperClass] = []
    var header: HeaderFooter? = nil
    var footer: HeaderFooter? = nil

}

// Model section extension to use current constructor protocols with Rx

extension HFSuperClass: SectionModelType {

    var items: [CellSuperClass] {
        return data
    }

    typealias Item = CellSuperClass

    init(original: HFSuperClass, items: [CellSuperClass]) {
        self = original
        self.data = items
    }

}
