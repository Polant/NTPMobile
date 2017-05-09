//
//  MenuTableViewCell.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 02.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    @IBOutlet weak var titleButton: UIButton!
    
    func setup(with text: String) {
        self.titleButton.setTitle(text, for: [])
    }
}
