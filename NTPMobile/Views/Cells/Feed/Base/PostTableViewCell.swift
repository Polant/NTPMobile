//
//  PostTableViewCell.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 09.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    fileprivate func setupText(_ text: String) {
        postTextLabel.text = text
    }
    
    func setup(with post: Post) {
        setupText(post.text)
    }
}
