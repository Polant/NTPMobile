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
    
    // MARK: - Routes
    
    func presentOAuthViewController() {
        
        let storyboard = Storyboard.oAuth.instantiate()
        
        let oauthVC = storyboard.instantiateInitialViewController() as! OAuthViewController
        oauthVC.interactor = OAuthInteractor(viewController: oauthVC)
        oauthVC.router = OAuthRouter(viewController: oauthVC)
        
        viewController?.navigationController?.pushViewController(oauthVC, animated: true)
    }
}
