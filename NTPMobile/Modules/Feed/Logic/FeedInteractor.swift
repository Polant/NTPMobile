//
//  FeedInteractor.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 27.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

class FeedInteractor: Interactor<FeedViewController> {
    
    func loadFeed(ownersOnly: Bool = false,
                  offset: Int,
                  count: Int,
                  completion: (([Post]) -> Void)? = nil) {
        
        guard let currentApp = ServiceManager.shared.currentApp,
            let defaultCategory = currentApp.categories.first else {
            completion?([])
            return
        }
        
        ServiceManager.shared.loadPosts(for: defaultCategory,
                                        ownersOnly: ownersOnly,
                                        offset: offset,
                                        count: count) { posts in
                                            completion?(posts)
        }
    }
    
    func loadCategory(_ category: Category,
                      filter: Filter? = nil,
                      offset: Int, count: Int,
                      completion: (([Post]) -> Void)? = nil) {
        
        let ownersOnly = filter?.isOwnersOnly ?? false
        
        ServiceManager.shared.loadPosts(for: category,
                                        ownersOnly: ownersOnly,
                                        offset: offset,
                                        count: count) { posts in
                                            completion?(posts)
        }
    }
}
