//
//  UITextViewEx.swift
//  VipCoin
//
//  Created by Woxapp on 23.02.2018.
//  Copyright © 2018 Woxapp. All rights reserved.
//

import UIKit

extension UITextView {

    func loadFile(name: String, withExtension ext: String) {
        if let path = Bundle.main.url(forResource: name, withExtension: ext) {
            do {
                let attributedString: NSAttributedString = try NSAttributedString(url: path, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                attributedText = attributedString
            } catch let error {
                print("Got an error \(error)")
            }
        }
    }

}
