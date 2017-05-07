//
//  NotificationManager.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 02.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

class NotificationManager {
    
    static let shared = NotificationManager()
    private init() {}
    
    struct Notification {
        let name: String
        init(name: String) {
            self.name = name
        }
        static let categoriesDidLoad = Notification(name: "categoriesDidLoad")
        static let categoryDidSelected = Notification(name: "categoryDidSelected")
    }
    
    func sendCategoriesDidLoad() {
        send(Notification.categoriesDidLoad, object: nil, userInfo: nil)
    }
    
    func sendCategoryDidSelected(category: Category, filter: Filter?) {
        var userInfo: [String: Any] = ["category": category]
        if let filter = filter {
            userInfo["filter"] = filter
        }
        send(Notification.categoryDidSelected, object: nil, userInfo: userInfo)
    }
    
    func send(_ notification: NotificationManager.Notification, object: Any?, userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notification.name),
                                        object: object,
                                        userInfo: userInfo)
    }
}
