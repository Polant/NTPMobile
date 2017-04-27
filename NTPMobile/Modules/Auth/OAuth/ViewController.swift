//
//  ViewController.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 28.03.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? VKAuthViewController
        vc?.delegate = self
    }
}


// MARK: - VKAuthViewControllerDelegate
extension ViewController: VKAuthViewControllerDelegate {
    
    func vkAuthViewController(_ viewController: VKAuthViewController, didRecieveAuthCode code: String, redirectURI: String) {
        print("CODE: \(code)")
        
        self.navigationController?.popViewController(animated: true)
        self.send(code: code, redirectURI: redirectURI)
    }
    
    func vkAuthViewController(_ viewController: VKAuthViewController, didRecieveError error: VKAuthError) {
        viewController.dismiss(animated: true) { 
            print(error)
        }
    }
    
    private func send(code: String, redirectURI: String) {
        
        guard let appToken = ServiceManager.shared.token else { return }
        
        let url = URL(string: "\(Constants.baseApiServicePath)/oauth/vk")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.httpBody = "code=\(code)&redirect_uri=\(redirectURI)&user_id=\(appToken.userId)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request,
                                   completionHandler: { (data, response, error) in
                                    
                                    guard let data = data else { return }
                                    
                                    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                                        return
                                    }
                                    
                                    let vc = Storyboard.posts.instantiate().instantiateInitialViewController()
                                    self.navigationController?.pushViewController(vc!, animated: true)
                                    
        }).resume()
    }
}
