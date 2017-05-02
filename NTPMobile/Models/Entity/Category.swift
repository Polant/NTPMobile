//
//  Category.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 02.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

enum SocialNetwork: Int {
    case vk = 1
    
    init(identifier: Int) {
        self.init(rawValue: identifier)!
    }
    
    var identifier: Int {
        return rawValue
    }
}

final class Category {
    
    struct Filter {
        var query: String
    }
    
    var id: Int?
    
    var name: String
    var appId: Int
    var socialGroupURL: String
    var socialNetwork: SocialNetwork
    
    var socialGroupDomainName: String {
        return URL(string: socialGroupURL)!.lastPathComponent
    }
    
    var filter: Filter?
    
    init(id: Int? = nil, name: String, appId: Int, socialGroupURL: String, socialNetworkId: Int, filter: Filter?) {
        self.id = id
        self.name = name
        self.appId = appId
        self.socialGroupURL = socialGroupURL
        self.socialNetwork = SocialNetwork(identifier: socialNetworkId)
        self.filter = filter
    }
    
    init(with dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int
        self.name = dictionary["name"] as! String
        self.appId = dictionary["app_id"] as! Int
        self.socialGroupURL = dictionary["social_group"] as! String
        self.socialNetwork = SocialNetwork(identifier: dictionary["social_network_id"] as! Int)
        let filterQuery = dictionary["filter_query"] as? String
        if let query = filterQuery {
            self.filter = Filter(query: query)
        }
    }
}
