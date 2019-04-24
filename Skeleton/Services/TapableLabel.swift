//
//  TapableLabel.swift
//  SpaceIn
//
//  Created by Woxapp on 03.05.2018.
//  Copyright © 2018 Woxapp. All rights reserved.
//

import UIKit

typealias TapableBlock = (String) -> Void

class TapableLabel: UILabel, UIGestureRecognizerDelegate {

    private var pText: String = ""
    private var aText: String = ""
    private var lText: String = ""
    private var pFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    private var aFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    private var aColor: UIColor = .white

    var tapBlock: TapableBlock? = nil

    @IBInspectable var plainText: String = NSLocalizedString("I agree with", comment: "") {
        didSet {
            pText = plainText
        }
    }

    @IBInspectable var attrText: String = NSLocalizedString("Terms and conditions Terms of Payment Processing, Privacy Policy", comment: "") {
        didSet {
            aText = attrText
        }
    }

    @IBInspectable var partText: String = NSLocalizedString(": if you cancel booking, you will be fully charged anyway", comment: "") {
        didSet {
            lText = partText
        }
    }

    @IBInspectable var attrColor: UIColor = .white {
        didSet {
            aColor = attrColor
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func commonInit() {
        isUserInteractionEnabled = true
        addAttributes()
        addGestures()
    }

    private func addAttributes() {
        let attributedString = NSMutableAttributedString(string: "\(pText) \(aText) \(lText)")
        attributedString.addAttributes([.font: pFont], range: NSMakeRange(0, pText.count))
        attributedString.addAttributes([.font: aFont, .foregroundColor: aColor, .underlineStyle: 1], range: NSMakeRange(pText.count + 1, aText.count))
        attributedString.addAttributes([.font: pFont], range: NSMakeRange(pText.count + 1 + aText.count + 1, lText.count))
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
            tapBlock?(pText)
            UIApplication.topViewController()?.performSegue(withIdentifier: "policy", sender: nil)
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
            attributedString.addAttributes([.foregroundColor: aColor.withAlphaComponent(0.5)], range: NSMakeRange(pText.count + 1, aText.count))
        case .ended, .cancelled, .failed:
            attributedString.addAttributes([.foregroundColor: aColor.withAlphaComponent(1.0)], range: NSMakeRange(pText.count + 1, aText.count))
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
        attributedString.addAttributes([.foregroundColor: aColor.withAlphaComponent(0.5)], range: NSMakeRange(pText.count + 1, aText.count))
        attributedText = attributedString
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.indicateState(attributedString)
            self.setNeedsDisplay()
        }
    }

    private func indicateState(_ attributedString: NSMutableAttributedString) {
        attributedString.addAttributes([.foregroundColor: aColor.withAlphaComponent(1.0)], range: NSMakeRange(pText.count + 1, aText.count))
        attributedText = attributedString
    }

}
