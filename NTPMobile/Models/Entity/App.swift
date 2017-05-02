//
//  App.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 02.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

final class App {
    
    var id: Int?
    var name: String
    var location: String
    
    var categories: [Category]
    
    init(id: Int? = nil, name: String, location: String, categories: [Category]) {
        self.id = id
        self.name = name
        self.location = location
        self.categories = categories
    }
    
    init(with dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int
        self.name = dictionary["name"] as! String
        self.location = dictionary["location"] as! String
        
        let categoriesJSON: [[String: Any]] = dictionary["categories"] as? [[String : Any]] ?? []
        self.categories = categoriesJSON.map { jsonDict in
            Category(with: jsonDict)
        }
    }
}
