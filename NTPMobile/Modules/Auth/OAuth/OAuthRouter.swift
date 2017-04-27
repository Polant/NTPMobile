//
//  OAuthRouter.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 27.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class OAuthRouter: Router<OAuthViewController> {
    
    // MARK: - Routes
    
    func presentFeedViewController() {
        let vc = Storyboard.content.instantiate().instantiateInitialViewController()
        self.viewController?.navigationController?.pushViewController(vc!, animated: true)
        print("pushed")
    }
    
    // MARK: - Segue
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? VKAuthViewController
        vc?.delegate = self.viewController
    }
    
}
