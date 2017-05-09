//
//  PostTableViewCell.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 09.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate: class {
    func postCell(_ cell: PostTableViewCell, whouldUpdateWithBlock block: () -> Void)
}

class PostTableViewCell: UITableViewCell {
    
    weak var delegate: PostTableViewCellDelegate?
    
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    private(set) var isTextExpanded: Bool = false
    private var trimmedText: String!
    private var fullText: String!
    
    private func setText(_ text: String) {
        postTextLabel.text = text
    }
    
    private func setExpandTitle(_ title: String) {
        expandButton.setTitle(title, for: [])
    }
    
    func setup(with post: Post) {
        isTextExpanded = false
        fullText = post.text
        trimmedText = post.text.trimmed(to: Constants.UI.Cell.maxTrimmedTextLength)
        setText(trimmedText)
    }
    
    @IBAction func actionExpandText(_ sender: UIButton) {
        toggleText()
    }
    
    private func toggleText() {
        delegate?.postCell(self, whouldUpdateWithBlock: { 
            if isTextExpanded {
                setText(trimmedText)
                setExpandTitle("More ...")
            } else {
                setText(fullText)
                setExpandTitle("Less")
            }
            isTextExpanded = !isTextExpanded
        })
    }
}
