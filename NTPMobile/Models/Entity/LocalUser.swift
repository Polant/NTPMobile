//
//  LocalUser.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 28.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

class LocalUser {
    let id: Int
    let login: String
    let email: String
    let token: AccessToken
    
    init(id: Int, login: String, email: String, token: AccessToken) {
        self.id = id
        self.login = login
        self.email = email
        self.token = token
    }
}
