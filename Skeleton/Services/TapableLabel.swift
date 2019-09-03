import UIKit

typealias TapableBlock = (String) -> Void

@IBDesignable
class TapableLabel: UILabel, UIGestureRecognizerDelegate {
    
    private var pFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    private var aFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    
    var tapBlock: TapableBlock? = nil
    
    @IBInspectable var plainText: String = NSLocalizedString("policy_plain_text", comment: "")
    @IBInspectable var attrText: String = NSLocalizedString("policy_attributedText", comment: "")
    @IBInspectable var partText: String = ""
    @IBInspectable var attrColor: UIColor = .white
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    private func commonInit() {
        isUserInteractionEnabled = true
        addAttributes()
        addGestures()
    }
    
    private func addAttributes() {
        let attributedString = NSMutableAttributedString(string: "\(plainText) \(attrText) \(partText)")
        attributedString.addAttributes([.font: pFont], range: NSMakeRange(0, plainText.count))
        attributedString.addAttributes([.font: aFont, .foregroundColor: attrColor, .underlineStyle: 1], range: NSMakeRange(plainText.count + 1, attrText.count))
        attributedString.addAttributes([.font: pFont], range: NSMakeRange(plainText.count + 1 + attrText.count + 1, partText.count))
        attributedText = attributedString
    }
    
    private func addGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        gesture.delegate = self
        gesture2.delegate = self
        addGestureRecognizer(gesture)
        addGestureRecognizer(gesture2)
        layoutSubviews()
    }
    
    @objc private func singleTap(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .possible: return
        case .began: print("tap start")
        case .changed, .ended, .cancelled, .failed:
            indicateTap()
            tapBlock?(plainText)
            UIApplication.topViewController()?.performSegue(withIdentifier: "policy", sender: nil)
        @unknown default: ()
        }
    }
    
    @objc private func longPress(_ gesture: UITapGestureRecognizer) {
        guard let text = attributedText
            else {
                return
        }
        let attributedString = NSMutableAttributedString(attributedString: text)
        switch gesture.state {
        case .possible, .changed: return
        case .began:
            attributedString.addAttributes([.foregroundColor: attrColor.withAlphaComponent(0.5)], range: NSMakeRange(plainText.count + 1, attrText.count))
        case .ended, .cancelled, .failed:
            attributedString.addAttributes([.foregroundColor: attrColor.withAlphaComponent(1.0)], range: NSMakeRange(plainText.count + 1, attrText.count))
        @unknown default: ()
        }
        attributedText = attributedString
        setNeedsDisplay()
    }
    
    private func indicateTap() {
        guard let text = attributedText
            else {
                return
        }
        let attributedString = NSMutableAttributedString(attributedString: text)
        attributedString.addAttributes([.foregroundColor: attrColor.withAlphaComponent(0.5)], range: NSMakeRange(plainText.count + 1, attrText.count))
        attributedText = attributedString
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.indicateState(attributedString)
            self.setNeedsDisplay()
        }
    }
    
    private func indicateState(_ attributedString: NSMutableAttributedString) {
        attributedString.addAttributes([.foregroundColor: attrColor.withAlphaComponent(1.0)], range: NSMakeRange(plainText.count + 1, attrText.count))
        attributedText = attributedString
    }
    
}
