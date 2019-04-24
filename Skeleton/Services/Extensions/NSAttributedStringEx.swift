//
//  NSAttributedStringEx.swift
//  SpaceIn
//
//  Created by Woxapp on 20.03.2018.
//  Copyright © 2018 Woxapp. All rights reserved.
//

import UIKit

extension NSAttributedString {

    func stringSize() -> CGSize {
        return self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size
    }

}
