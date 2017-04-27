//
//  ViewController.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 27.03.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

fileprivate struct VKAuthCredentials {
    
    static let clientId = 5948504
    
    static let redirectScheme = "http"
    static let redirectHost = "localhost"
    static let redirectPort = 8090
    static let redirectPath = "/auth_vk_callback"
    
    static var redirectURI = "\(redirectScheme)://\(redirectHost):\(redirectPort)\(redirectPath)"
    
    static let scope = "friends,offline"
}

enum VKAuthError {
    case accessDenied(reason: String)
}

protocol VKAuthViewControllerDelegate: class {
    func vkAuthViewController(_ viewController: VKAuthViewController, didRecieveAuthCode code: String, redirectURI: String)
    func vkAuthViewController(_ viewController: VKAuthViewController, didRecieveError error: VKAuthError)
}

class VKAuthViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: - Properties
    
    weak var delegate: VKAuthViewControllerDelegate?
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAuth()
    }
    
    deinit {
        webView.delegate = nil
    }
    
    
    // MARK: - Auth
    
    func startAuth() {
        webView.delegate = self
        webView.loadRequest(authRequest())
    }
    
    func authRequest() -> URLRequest {
        let urlString = "https://oauth.vk.com/authorize"
            + "?client_id=\(VKAuthCredentials.clientId)"
            + "&redirect_uri=\(VKAuthCredentials.redirectURI)"
            + "&scope=\(VKAuthCredentials.scope)"
            + "&display=page"
            + "&response_type=code"
            + "&v=5.63"
            + "&revoke=1"   // Need to add revoke parameter to start web view uis dialog every time
        
        let url = URL(string: urlString)!
        return URLRequest(url: url)
    }
}


// MARK: - UIWebViewDelegate
extension VKAuthViewController: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        guard request.isCodeRedirect, let url = request.url, let query = url.query else {
            return true
        }
        
        let queryComponents = query.components(separatedBy: "&")
        var parameters = [String: Any]()
        
        for component in queryComponents {
            let keyValue = component.components(separatedBy: "=")
            let key = keyValue.first!
            let value = keyValue.last!
            parameters[key] = value
        }
        
        guard let code = parameters["code"] as? String else {
                
            if let _ = parameters["error"], let reason = parameters["error_reason"] as? String {
                delegate?.vkAuthViewController(self, didRecieveError: .accessDenied(reason: reason))
            }
            return true
        }
        delegate?.vkAuthViewController(self, didRecieveAuthCode: code, redirectURI: VKAuthCredentials.redirectURI)
        
        return false
    }
}


// MARK: - URLRequest
extension URLRequest {
    fileprivate var isCodeRedirect: Bool {
        return url?.scheme == VKAuthCredentials.redirectScheme
            && url?.host == VKAuthCredentials.redirectHost
            && url?.port == VKAuthCredentials.redirectPort
            && url?.path == VKAuthCredentials.redirectPath
    }
}

