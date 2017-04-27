//
//  MenuContainerViewController.swift
//  NTPiosCore
//
//  Created by Anton Poltoratskyi on 2/9/17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol MenuContainerViewInput: class {
    var isLeftVisible: Bool { get set }
    var isRightVisible: Bool { get set }
    
    func setCentral(viewController: UIViewController)
    func setLeft(viewController: UIViewController)
    func setRight(viewController: UIViewController)
    
    func toggleLeft(animated: Bool, completion: (() -> Void)?)
    func toggleRight(animated: Bool, completion: (() -> Void)?)
    func toggleLeft(animated: Bool, visible: Bool, completion: (() -> Void)?)
    func toggleRight(animated: Bool, visible: Bool, completion: (() -> Void)?)
    
    func removeLeft()
    func removeRight()
    func removeBoth()
}

public class MenuContainerViewController: ContainerViewController {
    
    // MARK: - Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        debugPrint("\(type(of: self)) deinited")
    }
}

// MARK: - SideMenuViewControllerDelegate

extension MenuContainerViewController: SideMenuViewControllerDelegate {
    
    func sideMenuViewControllerDidSelectFeed(_ vc: SideMenuViewController) {
        
    }
    func sideMenuViewControllerDidSelectLogout(_ vc: SideMenuViewController) {
        self.dismiss(animated: true)
    }
}

// MARK: - MenuContainerViewInput

extension MenuContainerViewController: MenuContainerViewInput {
    func setCentral(viewController: UIViewController) {
        setCentral(controller: viewController)
    }
    
    func setLeft(viewController: UIViewController) {
        setLeft(controller: viewController)
    }
    
    func setRight(viewController: UIViewController) {
        setRight(controller: viewController)
    }
}
