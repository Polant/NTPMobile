//
//  RegistrationRouter.swift
//  FastOrders
//
//  Created by Anton Poltoratskyi on 04.12.16.
//  Copyright © 2016 Poltoratskyi Team. All rights reserved.
//

import Foundation
import UIKit

class RegistrationRouter: Router<RegistrationViewController> {
    
    func presentOAuthViewController() {
        let storyboard = Storyboard.oAuth.instantiate()
        let initialVC = storyboard.instantiateInitialViewController()!
//        viewController?.present(initialVC, animated: true, completion: nil)
        viewController?.navigationController?.pushViewController(initialVC, animated: true)
    }
}
