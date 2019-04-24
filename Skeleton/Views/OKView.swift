import UIKit

class OKView: UIView {

    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var okLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var checkmarkView: UIView!

    private static func configure(with size: CGSize) -> OKView {
        let view = Bundle.main.loadNibNamed("OKView", owner: nil, options: nil)?.first as? OKView ?? OKView()
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        return view
    }

    static func animateOK(_ title: String? = nil) {
        perform(#selector(self.waitActionSheetClosed), with: title, afterDelay: 0.1)
    }

    @objc private static func waitActionSheetClosed(_ title: String?) {
        let view = UIApplication.topViewController()?.view
        if view == nil {
            return
        }
        let okView = configure(with: view!.frame.size)
        okView.okLabel.text = title
        view?.addSubview(okView)
        view?.bringSubviewToFront(okView)
        okView.startAnimate()
    }

    // damping = 0.5, velocity = 0.5

    private func startAnimate() {
        isHidden = false
        contentView.frame.size = CGSize.zero
        contentView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.frame.size = CGSize(width: 156, height: 156)
            self.contentView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            self.blackView.alpha = 0.4
        }, completion: { _ in
            self.animateCheckmark()
        })
    }

    @objc private func animateCheckmark() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: checkmarkView.frame.size.height / 2))
        path.addLine(to: CGPoint(x: checkmarkView.frame.size.width / 3, y: checkmarkView.frame.size.height))
        path.addLine(to: CGPoint(x: checkmarkView.frame.size.width, y: 0))
        let lineLayer = CAShapeLayer()
        lineLayer.frame = checkmarkView.bounds
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        lineLayer.fillColor = nil
        lineLayer.lineWidth = 4.6
        lineLayer.lineJoin = CAShapeLayerLineJoin.round
        lineLayer.lineCap = CAShapeLayerLineCap.round
        checkmarkView.layer.addSublayer(lineLayer)
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.5
        pathAnimation.fromValue = NSNumber(floatLiteral: 0)
        pathAnimation.toValue = NSNumber(floatLiteral: 1)
        lineLayer.add(pathAnimation, forKey: "strokeEnd")
        perform(#selector(self.hideOK), with: nil, afterDelay: 1)
    }

    @objc private func hideOK() {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.frame.size = CGSize.zero
            self.contentView.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            self.blackView.alpha = 0
        }, completion: { _ in
            self.isHidden = true
            self.removeFromSuperview()
        })
    }

}
