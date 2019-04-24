import UIKit

protocol  MotionDelegate {

    func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)

}

extension UIViewController: MotionDelegate {

    func addActivity() {
        if isActivityOn == true {
            return
        }
        let activity = ActivityView.configure()
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.view.addSubview(activity)
            self.view.bringSubviewToFront(activity)
        }, completion: nil)
    }

    private var isActivityOn: Bool {
        for subview in view.subviews {
            if subview is ActivityView {
                return true
            }
        }
        return false
    }

    func removeActivity(animated: Bool) {
        for subview in view.subviews {
            if subview is ActivityView {
                UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    subview.removeFromSuperview()
                }, completion: nil)
            }
        }
    }

    override open func becomeFirstResponder() -> Bool {
        return true
    }

    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: .motionHandler, object: nil)
        }
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func addGradient(height: CGFloat) {
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height))
        imageView.tag = 777
        imageView.image = #imageLiteral(resourceName: "bgRegestration")
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }

    func changeGradientHeight(for value: CGFloat) {
        let imageView = view.viewWithTag(777)
        imageView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: value < 64 ? 64 : value)
    }

    @objc func loadMore(_ block: @escaping SuccessHandler) {}

    @objc func refreshData(_ block: @escaping SuccessHandler) {}

}
