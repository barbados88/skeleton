import UIKit

enum WXIdentifier: String {

    case def = "defaultCell"
    case defImage = "defaultImageCell"
    
    case header = "header"
    case alignmentHeader = "alignmentHeader"
    case buttonHeader = "buttonHeader"

    
    
    static let tableCells: [WXIdentifier] = [def, defImage]
    static let collectionCells: [WXIdentifier] = []
    static let headers: [WXIdentifier] = [header, alignmentHeader, buttonHeader]

}

class SelectionView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = WXColors.mainAppColor.color.withAlphaComponent(0.3)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}

class WXConstructor: NSObject {

    var handler: TableHandler? = nil

    var tableConstructor: WXTableConstructor? = nil
    var collectionConstructor: WXCollectionConstructor? = nil

    public init(with scrollView: UIScrollView, object: ConstructorSuperClass, refreshable: Bool = false) {
        guard
            let tableView = scrollView as? UITableView
            else {
                guard
                    let collectionView = scrollView as? UICollectionView
                    else {
                        fatalError("Trying to pass constructor object to ui object cannot be performed in: \(scrollView), constructor can vizualize objects only in UITableview or UICollectionView")
                }
                self.collectionConstructor = WXCollectionConstructor(collectionView: collectionView, info: object, refreshable: refreshable)
                return
        }
        self.tableConstructor = WXTableConstructor(tableView: tableView, info: object, refreshable: refreshable)
    }

    private init(with tableView: UITableView, object: ConstructorSuperClass, refreshable: Bool = false) {
        self.tableConstructor = WXTableConstructor(tableView: tableView, info: object, refreshable: refreshable)
        self.tableConstructor?.handler = handler
    }

    private init(with collectionView: UICollectionView, object: ConstructorSuperClass, refreshable: Bool = false) {
        self.collectionConstructor = WXCollectionConstructor(collectionView: collectionView, info: object, refreshable: refreshable)
        self.collectionConstructor?.handler = handler
    }

}

