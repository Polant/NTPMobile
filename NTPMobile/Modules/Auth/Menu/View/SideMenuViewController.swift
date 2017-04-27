//
//  SideMenuViewController.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 27.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol SideMenuViewControllerDelegate: class {
    func sideMenuViewControllerDidSelectFeed(_ vc: SideMenuViewController)
    func sideMenuViewControllerDidSelectLogout(_ vc: SideMenuViewController)
}

class SideMenuViewController: UITableViewController {

    weak var delegate: SideMenuViewControllerDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUser()
    }
    
    // MARK: - UI Setup
    
    private func setupUser() {
        if let user = ServiceManager.shared.localUser {
            self.usernameLabel.text = "Hello, \(user.login)"
        } else {
            self.usernameLabel.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func actionShowFeed(_ sender: Any) {
        delegate?.sideMenuViewControllerDidSelectFeed(self)
    }
    
    @IBAction func actionLogout(_ sender: Any) {
        delegate?.sideMenuViewControllerDidSelectLogout(self)
    }
}
