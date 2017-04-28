//
//  OAuthRouter.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 27.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class OAuthRouter: Router<OAuthViewController> {
    
    // MARK: - Injection
    
    override class func injectModule(in view: OAuthViewController) {
        super.injectModule(in: view)
        view.interactor = OAuthInteractor(viewController: view)
        view.router = OAuthRouter(viewController: view)
    }
    
    // MARK: - Routes
    
    func presentFeedViewController() {
        
        // Container
        let container = Storyboard.menu
            .instantiate()
            .instantiateViewController(withIdentifier: "MenuContainerViewController") as! MenuContainerViewController
        MenuContainerRouter.injectModule(in: container)
        
        // Side menu
        let sideMenuViewController = Storyboard.menu
            .instantiate()
            .instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        sideMenuViewController.delegate = container
        
        // Navigation
        let contentNavigationController = Storyboard.content
            .instantiate()
            .instantiateInitialViewController() as! UINavigationController
        
        // Setup VIPER
        let feedViewController = contentNavigationController.topViewController as! FeedViewController
        FeedRouter.injectModule(in: feedViewController)
        
        container.setCentral(viewController: contentNavigationController)
        container.setLeft(viewController: sideMenuViewController)
        
        self.viewController?.present(container, animated: true)
    }
    
    // MARK: - Segue
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? VKAuthViewController
        vc?.delegate = self.viewController
    }
    
}
