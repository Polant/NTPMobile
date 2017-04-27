//
//  ViewController.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 28.03.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {

    var interactor: OAuthInteractor!
    var router: OAuthRouter!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router.prepare(for: segue, sender: sender)
    }
}


// MARK: - VKAuthViewControllerDelegate
extension OAuthViewController: VKAuthViewControllerDelegate {
    
    func vkAuthViewController(_ vc: VKAuthViewController, didRecieveAuthCode code: String, redirectURI: String) {
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.interactor.send(code: code, redirectURI: redirectURI)
        }
    }
    
    func vkAuthViewController(_ vc: VKAuthViewController, didRecieveError error: VKAuthError) {
        vc.dismiss(animated: true) {
            print(error)
        }
    }
}
