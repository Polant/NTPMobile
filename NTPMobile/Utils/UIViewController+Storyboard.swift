//
//  UIViewController+Storyboard.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 27.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol StoryboardInitializable {
    var storyboardIdentifier: String { get }
}

extension UIViewController {
    
    func instantiate(from storyboard: Storyboard) -> UIViewController {
        return storyboard.instantiate()
                .instantiateViewController(withIdentifier: String(describing: type(of: self)))
    }
}
