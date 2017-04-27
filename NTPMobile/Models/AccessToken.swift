//
//  AccessToken.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 01.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

struct AccessToken {
    
    var tokenString: String
    var expiresIn: Double
    var userId: Int
    
    init(string: String, expiresIn timeInterval: Double, userId: Int) {
        self.tokenString = string
        self.expiresIn = timeInterval
        self.userId = userId
    }
}

// MARK: - JSON Convertation

extension AccessToken {
    
    var dictionaryValue: [String: Any] {
        return [
            "token_string": tokenString,
            "expires_in": expiresIn,
            "user_id": userId
        ]
    }
}
