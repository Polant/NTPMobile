//
//  OAuthInteractor.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 27.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

class OAuthInteractor: Interactor<OAuthViewController> {
    
    // MARK: - Actions
    
    func send(code: String, redirectURI: String) {
        
        guard let appToken = ServiceManager.shared.token else { return }
        
        let url = URL(string: "\(Constants.baseApiServicePath)/oauth/vk")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = "code=\(code)&redirect_uri=\(redirectURI)&user_id=\(appToken.userId)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request,
                                   completionHandler: { (data, response, error) in
                                    
                                    guard let data = data else { return }
                                    
                                    guard let _ = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                                        return
                                    }
                                    self.viewController?.router.presentFeedViewController()
                                    
        }).resume()
    }
    
}
