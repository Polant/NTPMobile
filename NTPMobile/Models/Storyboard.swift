//
//  Storyboard.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 31.03.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case login = "Login"
    case oAuth = "OAuth"
    case menu = "Menu"
    case content = "Content"
    case service = "Service"
    
    func instantiate() -> UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }
}
