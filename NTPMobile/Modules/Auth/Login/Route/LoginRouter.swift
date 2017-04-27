//
//  LoginRouter.swift
//  FastOrders
//
//  Created by Anton Poltoratskyi on 04.12.16.
//  Copyright © 2016 Poltoratskyi Team. All rights reserved.
//

import Foundation
import UIKit

class LoginRouter: Router<LoginViewController> {
    
    // MARK: - Routes
    
    func presentRegistrationViewController() {
        viewController?.performSegue(withIdentifier: "showRegistration", sender: nil)
    }
    
    func presentOAuthViewController() {
        
        let storyboard = Storyboard.oAuth.instantiate()
        
        let oauthVC = storyboard.instantiateInitialViewController() as! OAuthViewController
        OAuthRouter.injectModule(in: oauthVC)
        
        viewController?.navigationController?.pushViewController(oauthVC, animated: true)
    }
    
    // MARK: - Segue
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "showRegistration":
            let vc = segue.destination as! RegistrationViewController
            vc.interactor = RegistrationInteractor(viewController: vc)
            vc.router = RegistrationRouter(viewController: vc)
        default:
            break
        }
    }
}
