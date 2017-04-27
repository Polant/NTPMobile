//
//  FeedRouter.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 27.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

class FeedRouter: Router<FeedViewController> {
    
    override class func injectModule(in view: FeedViewController) {
        super.injectModule(in: view)
        view.interactor = FeedInteractor(viewController: view)
        view.router = FeedRouter(viewController: view)
    }
    
}
