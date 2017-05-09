//
//  Post.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 01.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

class Post {
    var id: String
    var timestamp: Int
    var text: String
    var photoUrl: String?
    
    var hasPhoto: Bool {
        return photoUrl != nil
    }
    
    init(id: String, timestamp: Int, text: String, photoUrl: String?) {
        self.id = id
        self.timestamp = timestamp
        self.text = text
        self.photoUrl = photoUrl
    }
    
    init(with dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.timestamp = dictionary["date"] as! Int
        self.text = dictionary["text"] as! String
        self.photoUrl = dictionary["photo_url"] as? String
    }
}
