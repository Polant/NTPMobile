//
//  MenuContainerRouter.swift
//  NTPiosCore
//
//  Created by Anton Poltoratskyi on 2/9/17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation
import UIKit

class MenuContainerRouter: Router<MenuContainerViewController> {
    
    override class func injectModule(in view: MenuContainerViewController) {
        super.injectModule(in: view)
        view.interactor = MenuContainerInteractor(viewController: view)
        view.router = MenuContainerRouter(viewController: view)
    }
    
    func presentServiceViewController() {
        let viewController = Storyboard.service
            .instantiate()
            .instantiateInitialViewController()!
        
        self.viewController?.setCentral(viewController: viewController)
        self.viewController?.toggleLeft(animated: true, completion: nil)
    }
    
    func presentFeedViewController() {
        
        // Navigation
        let contentNavigationController = Storyboard.content
            .instantiate()
            .instantiateInitialViewController() as! UINavigationController
        
        // Setup VIPER
        let feedViewController = contentNavigationController.topViewController as! FeedViewController
        FeedRouter.injectModule(in: feedViewController)
        
        self.viewController?.setCentral(viewController: contentNavigationController)
        self.viewController?.toggleLeft(animated: true, completion: nil)
        
        // Setup feed input
        self.viewController?.feedModuleInput = feedViewController
    }
}



