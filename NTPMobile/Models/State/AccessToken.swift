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
    
    init(string: String, expiresIn timeInterval: Double) {
        self.tokenString = string
        self.expiresIn = timeInterval
    }
}
