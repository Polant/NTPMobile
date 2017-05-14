//
//  ServiceRouter.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 14.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

class ServiceRouter: Router<ServiceViewController> {
    
    override class func injectModule(in view: ServiceViewController) {
        super.injectModule(in: view)
        view.interactor = ServiceInteractor(viewController: view)
        view.router = ServiceRouter(viewController: view)
    }
}
