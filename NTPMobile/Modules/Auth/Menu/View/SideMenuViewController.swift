//
//  SideMenuViewController.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 27.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol SideMenuModuleDelegate: class {
    
}

class SideMenuViewController: UITableViewController {

    weak var delegate: SideMenuModuleDelegate?

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
