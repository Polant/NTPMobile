//
//  PostTextTableViewCell.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 28.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class PostTextTableViewCell: UITableViewCell {

    @IBOutlet weak var postTextLabel: UILabel!
    
    func setup(with post: Post) {
        postTextLabel.text = post.text
    }
}
