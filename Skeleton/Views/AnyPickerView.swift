import UIKit

typealias UpdateBlock = (Any) -> Void

class AnyPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var navigationItem: UINavigationItem!
    @IBOutlet weak var navigationBar: UINavigationBar!

    private var data: [ChainedObject] {
        return object?.chainedObjects ?? []
    }
    var object: ListObject? = nil
    var selectedRow: Int = 0
    var updateBlock: UpdateBlock? = nil

    static func configure(with object: ListObject?, _ choose: Bool? = nil) -> AnyPickerView {
        let view = Bundle.main.loadNibNamed("AnyPickerView", owner: nil, options: nil)?.first as? AnyPickerView ?? AnyPickerView()
        view.frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        UIApplication.shared.keyWindow?.addSubview(view)
        view.layoutIfNeeded()
        view.dimView.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(view.handleTap(_:))))
        view.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 96 / 255.0, green: 105 / 255.0, blue: 106 / 255.0, alpha: 1.0)]
        if object != nil {
            view.navigationItem.title = object!.title
            view.object = object
            view.pickerView.reloadAllComponents()
            view.pickerView.showsSelectionIndicator = true
            view.selectedRow = object!.selectedIndex
            view.pickerView.selectRow(view.selectedRow, inComponent: 0, animated: false)
        } else if choose == true {
            view.navigationItem.title = nil
            view.datePickerSettings()
            view.datePickerView.setDate(Date(), animated: false)
        } else {
            view.navigationItem.title = NSLocalizedString("", comment: "")
            view.datePickerSettings()
            view.datePickerView.setDate("1988-01-02".date(using: .anchor) ?? Date(), animated: false)
        }
        view.animate(appearance: true)
        return view
    }

    // MARK: - Helper methods

    private func datePickerSettings() {
        datePickerView.isHidden = false
        datePickerView.maximumDate = Date()
        datePickerView.minuteInterval = 1440
        datePickerView.locale = Locale.autoupdatingCurrent
    }

    private func animate(appearance: Bool) {
        self.bottomSpace.constant = appearance == true ? 0 : -self.contentView.frame.size.height
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = appearance == true ? 1 : 0
            self.layoutIfNeeded()
            self.addSeparators()
        }) { finished in
            if appearance == false {
                self.removeFromSuperview()
            }
        }
    }

    private func addSeparators() {
        if object == nil {
            return
        }
        for view in pickerView.subviews {
            if view.bounds.size.height < 2.0 && view.backgroundColor == nil {
                view.backgroundColor = UIColor(red: 205 / 255.0, green: 205 / 255.0, blue: 205 / 255.0, alpha: 1.0)
            }
        }
    }

    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        animate(appearance: false)
    }

    // MARK: - PickerView methods

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }

    // MARK: - Actions

    @IBAction func cancel(_ sender: Any) {
        animate(appearance: false)
    }

    @IBAction func done(_ sender: Any) {
        if object == nil {
            updateBlock?(datePickerView.date)
        } else {
            object?.action(object: data[selectedRow])
            updateBlock?(selectedRow)
        }
        animate(appearance: false)
    }

}
