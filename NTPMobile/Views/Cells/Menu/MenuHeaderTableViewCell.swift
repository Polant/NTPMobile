//
//  MenuHeaderTableViewCell.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 02.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class MenuHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func setup(with user: LocalUser?) {
        if let user = user {
            self.usernameLabel.text = "Hello, \(user.login)"
        } else {
            self.usernameLabel.isHidden = true
        }
    }
}
