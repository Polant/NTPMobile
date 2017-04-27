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
    
    init(id: String, timestamp: Int, text: String) {
        self.id = id
        self.timestamp = timestamp
        self.text = text
    }
    
    init(with dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.timestamp = dictionary["date"] as! Int
        self.text = dictionary["text"] as! String
    }
}

// MARK: - JSON Convertation

extension Post {
    
    var dictionaryValue: [String: Any] {
        return [
            "id": id,
            "date": timestamp,
            "text": text
        ]
    }
}
