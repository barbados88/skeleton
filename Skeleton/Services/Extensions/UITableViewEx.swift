import UIKit

extension UITableView {

    func addFooterLoader() {
        if isLoaderOn == true {return}
        sectionFooterHeight = 35.0
        let footerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: sectionFooterHeight))
        footerView.backgroundColor = .clear
        footerView.addSubview(ActivityFooterView.configure())
        tableFooterView = footerView
        perform(#selector(self.reloadWithDelay), with: nil, afterDelay: 1)
    }

    func removeFooterLoader() {
        if isLoaderOn == false {return}
        sectionFooterHeight = 0.0
        tableFooterView = nil
        perform(#selector(self.reloadWithDelay), with: nil, afterDelay: 1)
    }

    @objc private func reloadWithDelay() {
        reloadData()
    }

    private var isLoaderOn : Bool {
        if tableFooterView == nil {return false}
        for footer in tableFooterView!.subviews {
            if footer is ActivityFooterView {
                return true
            }
        }
        return false
    }
    
    func animateCellSelection(at indexPath: IndexPath, _ block: @escaping () -> ()) {
        guard let array = indexPathsForVisibleRows else { return }
        for i in 0..<array.count {
            let delay = Double(i) * 0.1
            let path = array[i]
            guard let cell = cellForRow(at: path) else { continue }
            var desiredFrame = cell.frame
            desiredFrame.origin.x = path.row == indexPath.row && path.section == indexPath.section ? desiredFrame.size.width : -desiredFrame.size.width
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.animateCell(cell, to: desiredFrame)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(array.count) * 0.1) {
            block()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.reloadData()
            })
        }
    }
    
    private func animateCell(_ cell: UITableViewCell, to frame: CGRect) {
        UIView.animate(withDuration: 0.3) {
            cell.frame = frame
        }
    }

}
