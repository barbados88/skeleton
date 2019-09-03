import UIKit
import AudioToolbox

enum GradientDirection {

    case horizontal
    case vertical
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case center

    var startPoint: CGPoint {
        switch self {
        case .horizontal: return CGPoint(x: 0, y: 0)
        case .vertical: return CGPoint(x: 0, y: 0)
        case .topLeft: return CGPoint(x: 0, y: 0)
        case .topRight: return CGPoint(x: 1, y: 0)
        case .bottomLeft: return CGPoint(x: 0, y: 1)
        case .bottomRight: return CGPoint(x: 1, y: 1)
        case .center: return CGPoint(x: 0.5, y: 0.5)
        }
    }

    var endPoint: CGPoint {
        switch self {
        case .horizontal: return CGPoint(x: 1, y: 0)
        case .vertical: return CGPoint(x: 0, y: 1)
        case .topLeft: return CGPoint(x: 1, y: 1)
        case .topRight: return CGPoint(x: 0, y: 1)
        case .bottomLeft: return CGPoint(x: 1, y: 1)
        case .bottomRight: return CGPoint(x: 0, y: 1)
        case .center: return CGPoint(x: 0.5, y: 0.5)
        }
    }

}

enum HoleShape {
    
    case square, circle
    
    func holeIn(view: UIView, rect: CGRect) {
        switch self {
        case .square: view.squareHole(rect: rect)
        case .circle: view.circleHole(rect: rect)
        }
    }
    
}

extension UIView {
    
    private var defaultY: CGFloat {
        get {
            let barHeight = UIApplication.topViewController()?.navigationController?.navigationBar.frame.height ?? 0
            let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
            return barHeight + statusBarHeight
        }
    }
    
    func bindToKeyboard(constant: NSLayoutConstraint? = nil) {
        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillHhide(notification:)), name: .UIKeyboardWillHide, object: constant)
    }
    
    func unbindToKeyboard(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let size = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        let keyboardY = UIScreen.main.bounds.size.height - size.height
        let viewY = frame.size.height + frame.origin.y + defaultY
        if keyboardY < viewY {
            let deltaY = viewY - keyboardY
            UIView.animate(withDuration: 0.3) {
                self.superview?.frame.origin.y = -deltaY
            }
        }
    }
    
    @objc func keyboardWillHhide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.superview?.frame.origin.y = self.defaultY
        }
        guard let constraint = notification.object as? NSLayoutConstraint
            else {
                return
        }
        constraint.constant = 0
    }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }

    func addHole(rect: CGRect, shape: HoleShape) {
        shape.holeIn(view: self, rect: rect)
    }
    
    func squareHole(rect: CGRect) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        let path = UIBezierPath(rect: bounds)
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        path.append(UIBezierPath(rect: rect))
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    func circleHole(rect: CGRect) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        let radius: CGFloat = rect.width / 2
        let boundsRect = CGRect(x: rect.origin.x - radius, y: rect.origin.y, width: 2 * radius, height: 2 * radius)
        let path = UIBezierPath(rect: bounds)
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        path.append(UIBezierPath(ovalIn: boundsRect))
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

    func addGradient(colors: [CGColor], direction: GradientDirection) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        gradient.startPoint = direction.startPoint
        gradient.endPoint = direction.endPoint
        layer.insertSublayer(gradient, at: 0)
    }

    func showIndicator(color: UIColor) {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (frame.size.width - 27) / 2, y: (frame.size.height - 27) / 2, width: 27, height: 27))
        activityIndicator.color = color
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        isUserInteractionEnabled = false
    }

    func hideIndicator() {
        isUserInteractionEnabled = true
        for subview in subviews {
            if subview is UIActivityIndicatorView {
                subview.removeFromSuperview()
                break
            }
        }
    }

    var snapShot: UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot ?? UIImage()
    }

    private static let rotationAnimationKey = "rotationanimationkey"

    func rotate(duration: Double = 1, clockWise: Bool = true) {
        if layer.animation(forKey: UIView.rotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = clockWise == false ? .pi * 2.0 : 0.0
            rotationAnimation.toValue = clockWise == false ? 0.0 : .pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = .infinity
            layer.add(rotationAnimation, forKey: UIView.rotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: UIView.rotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.rotationAnimationKey)
        }
    }

    // TODO: - create selection for each corner

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }

    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue?.cgColor
        }
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
    }

}

@IBDesignable class GradientView: UIView {

    @IBInspectable var topColor: UIColor = .white
    @IBInspectable var bottomColor: UIColor = .black

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        (layer as? CAGradientLayer)?.colors = [topColor.cgColor, bottomColor.cgColor]
    }

}

@IBDesignable class CurvedView: UIView {

    @IBInspectable var fillColor: UIColor = .white

    override func draw(_ rect: CGRect) {
        let y: CGFloat = rect.size.height
        let width: CGFloat = UIScreen.main.bounds.size.width
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 0, y: y - 20))
        myBezier.addQuadCurve(to: CGPoint(x: width, y: y - 20), controlPoint: CGPoint(x: width / 2, y: y))
        myBezier.addLine(to: CGPoint(x: width, y: rect.height))
        myBezier.addLine(to: CGPoint(x: 0, y: rect.height))
        myBezier.close()
        fillColor.setFill()
        myBezier.fill()
    }

}

@IBDesignable class AngleView: UIView {

    @IBInspectable var fillColor: UIColor = UIColor.blue {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var points = [CGPoint(x: -0.1, y: 1), CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 0.35), CGPoint(x: 0.3, y: 1)] {
        didSet {
            setNeedsLayout()
        }
    }

    private lazy var shapeLayer: CAShapeLayer = {
        let sLayer = CAShapeLayer()
        layer.insertSublayer(sLayer, at: 0)
        return sLayer
    }()

    override func layoutSubviews() {
        shapeLayer.fillColor = fillColor.cgColor
        guard points.count > 2 else {
            shapeLayer.path = nil
            return
        }
        let path = UIBezierPath()
        path.move(to: convert(relativePoint: points[0]))
        for point in points.dropFirst() {
            path.addLine(to: convert(relativePoint: point))
        }
        path.close()
        shapeLayer.path = path.cgPath
    }

    private func convert(relativePoint point: CGPoint) -> CGPoint {
        return CGPoint(x: point.x * bounds.width + bounds.origin.x, y: point.y * bounds.height + bounds.origin.y)
    }

}
