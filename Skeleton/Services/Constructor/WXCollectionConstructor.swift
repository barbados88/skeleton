import UIKit

class WXCollectionConstructor: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var handler: TableHandler? = nil

    var insideOffset: CGPoint = CGPoint.zero
    var info: ConstructorSuperClass = ConstructorSuperClass() {
        didSet {
            reloadCells()
        }
    }
    var collectionView: UICollectionView? = nil {
        didSet {
            registerNIBs()
        }
    }

    private var isLoading: Bool = false

    public init(collectionView: UICollectionView, info: ConstructorSuperClass, refreshable: Bool = false) {
        super.init()
        self.collectionView = collectionView
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.registerNIBs()
        self.info = info
        self.collectionView?.reloadData()
    }

    private func registerNIBs() {
        for id in WXIdentifier.collectionCells {
            collectionView?.register(UINib(nibName: id.rawValue.firstUppercased, bundle: nil), forCellWithReuseIdentifier: id.rawValue)
        }
        for id in WXIdentifier.headers {
            collectionView?.register(UINib(nibName: id.rawValue.firstUppercased, bundle: nil), forSupplementaryViewOfKind: id.rawValue, withReuseIdentifier: id.rawValue)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return info.sectionInfo.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return info.sectionInfo[section].data.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = info.sectionInfo[indexPath.section].data[indexPath.row].size
        return CGSize(width: size.width == 0 ? collectionView.frame.width : size.width,
                      height: size.height == 0 ? collectionView.frame.height : size.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = info.sectionInfo[indexPath.section].data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: data.identifier.rawValue, for: indexPath)
        cell.configure(data)
        return cell
    }

    // to perform simple row slide animation before action use tableView extension
    // animateCellSelection(at indexPath: IndexPath, _ block: @escaping () -> ())
    // slides desired cell to the right, other cells down
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let data = info.sectionInfo[indexPath.section].data[indexPath.row]
        data.action()
        handler?(indexPath, data.info)
    }

    private func reloadCells() {
        collectionView?.reloadData()
    }

    // MARK: - UIScrollView methods

    func scrollViewDidScroll(_ scrollView: UIScrollView) {}

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}

}
