//
//  RootRouter.swift
//  FastOrders
//
//  Created by Anton Poltoratskyi on 04.12.16.
//  Copyright © 2016 Poltoratskyi Team. All rights reserved.
//

import UIKit

class RootRouter {
    
    weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let mainStoryboard = Storyboard.login.instantiate()
        
        let loginVC = mainStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        //Setup VIPER
        loginVC.interactor = LoginInteractor(viewController: loginVC)
        loginVC.router = LoginRouter(viewController: loginVC)
        
        let navigationVC = UINavigationController(rootViewController: loginVC)
        
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
        return true
    }
}
