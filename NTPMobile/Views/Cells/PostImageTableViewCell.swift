//
//  PostTableViewCell.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 28.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit
import SDWebImage

class PostImageTableViewCell: UITableViewCell {
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    func setup(with post: Post) {
        postTextLabel.text = post.text
        if let photoURL = post.photoUrl {
            postImageView.sd_setImage(with: URL(string: photoURL)!)
        }
    }
}
