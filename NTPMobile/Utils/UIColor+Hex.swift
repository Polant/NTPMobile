//
//  UIColor+Hex.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 31.03.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func color(from rgbValue: UInt32) -> UIColor {
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 256.0
        let blue = CGFloat(rgbValue & 0xFF) / 256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
