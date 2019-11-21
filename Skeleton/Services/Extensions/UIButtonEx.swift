import UIKit

extension UIButton {

    func waitForResponse(color: UIColor) {
        setTitleColor(.clear, for: .normal)
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (frame.size.width - 27) / 2, y: (frame.size.height - 27) / 2, width: 27, height: 27))
        activityIndicator.color = color
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        isEnabled = false
    }

    func removeIndicator() {
        isEnabled = true
        setTitleColor(.white, for: .normal)
        for subview in subviews {
            if subview is UIActivityIndicatorView {
                subview.removeFromSuperview()
                break
            }
        }
    }

    // 0 => .ScaleToFill
    // 1 => .ScaleAspectFit
    // 2 => .ScaleAspectFill
    @IBInspectable
    var imageContentMode: Int {
        get {
            return self.imageView?.contentMode.rawValue ?? 0
        }
        set {
            if let mode = UIView.ContentMode(rawValue: newValue),
                self.imageView != nil {
                self.imageView?.contentMode = mode
            }
        }
    }

    func animateCheckboxError() {
        perform(#selector(errorImage), with: nil, afterDelay: 0.1)
        perform(#selector(normalImage), with: nil, afterDelay: 0.2)
        perform(#selector(errorImage), with: nil, afterDelay: 0.3)
        perform(#selector(normalImage), with: nil, afterDelay: 0.4)
        perform(#selector(errorImage), with: nil, afterDelay: 0.5)
        perform(#selector(normalImage), with: nil, afterDelay: 0.6)
    }

    @objc private func errorImage() {
        setImage(#imageLiteral(resourceName: "icCheckError"), for: .normal)
    }

    @objc private func normalImage() {
        setImage(#imageLiteral(resourceName: "checkboxOff"), for: .normal)
    }

    @IBInspectable
    var numberOfLines: Int {
        get {
            return titleLabel?.numberOfLines ?? 0
        }
        set {
            titleLabel?.numberOfLines = newValue
        }
    }

}
