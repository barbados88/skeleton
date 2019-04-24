//
//  Footer.swift
//  Incognito
//
//  Created by Woxapp on 21.12.2017.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit

protocol FooterProtocol {

    var title: String? { get }
    var nibName: String? { get }
    var height: CGFloat { get }

}

class Footer: UITableViewHeaderFooterView {

    weak var footerDelegate: FooterDelegate? = nil

}
