//
//  PostTableViewCell.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 28.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit
import SDWebImage

class PostImageTableViewCell: PostTableViewCell {
    
    class var cellIdentifier: String {
        return "postCellWithImage"
    }
    @IBOutlet weak var postImageView: UIImageView!
    
    override func setup(with post: Post) {
        super.setup(with: post)
        if let photoURL = post.photoUrl {
            postImageView.sd_setImage(with: URL(string: photoURL)!)
        }
    }
}
