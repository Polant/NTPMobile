//
//  AppDelegate.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 27.03.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootRouter: RootRouter!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        rootRouter = RootRouter(window: window)
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor(red: 243.0 / 255.0,
                                                            green: 80.0 / 255.0,
                                                            blue: 28.0 / 255.0,
                                                            alpha: 1.0)// .color(from: 0x0097FF)
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        return rootRouter.application(application, didFinishLaunchingWithOptions: launchOptions)
    }


}

