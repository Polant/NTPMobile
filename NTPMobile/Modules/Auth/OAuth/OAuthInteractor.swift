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
        
        guard let localUser = ServiceManager.shared.localUser else { return }
        
        let url = URL(string: "\(Constants.baseApiServicePath)/oauth/vk")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = "code=\(code)&redirect_uri=\(redirectURI)&user_id=\(localUser.id)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                                    
                                    guard let data = data else { return }
                                    
                                    guard let _ = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                                        return
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.viewController?.router.presentFeedViewController()
                                    }
        }.resume()
    }
    
}
