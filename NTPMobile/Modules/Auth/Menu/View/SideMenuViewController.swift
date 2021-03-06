//
//  SideMenuViewController.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 27.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol SideMenuViewControllerDelegate: class {
    func sideMenuViewController(_ vc: SideMenuViewController, didSelectCategory category: Category, filter: Filter)
    func sideMenuViewControllerDidSelectService(_ vc: SideMenuViewController)
    func sideMenuViewControllerDidSelectLogout(_ vc: SideMenuViewController)
}

class SideMenuViewController: UITableViewController {

    weak var delegate: SideMenuViewControllerDelegate?
    
    var categories: [Category] = []
    
    var numberOfRows: Int {
        return categories.count + 3
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceManager.shared.loadAppInfo { [weak self] result in
            switch result {
            case let .success(app):
                self?.categories = app.categories
                self?.tableView.reloadData()
                NotificationManager.shared.sendCategoriesDidLoad(app.categories)
            case .error(_):
                break
            }
        }
    }
    
    // MARK: - Actions
    
    func actionShowCategory(_ category: Category, filter: Filter) {
        delegate?.sideMenuViewController(self, didSelectCategory: category, filter: filter)
    }
    
    func actionShowService() {
        delegate?.sideMenuViewControllerDidSelectService(self)
    }
    
    func actionLogout() {
        delegate?.sideMenuViewControllerDidSelectLogout(self)
    }

    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! MenuHeaderTableViewCell
            cell.setup(with: ServiceManager.shared.localUser)
            return cell
        case categoriesMenuRange():
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! MenuCategoryTableViewCell
            cell.delegate = self
            let category = self.category(at: indexPath)
            cell.setup(with: category)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! MenuTableViewCell
            if indexPath.row == numberOfRows - 1 {
                cell.setup(with: "Logout")
            } else {
                cell.setup(with: "Service")
            }
            return cell
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 220
        case categoriesMenuRange():
            return 90
        default:
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case categoriesMenuRange():
            let cell = tableView.cellForRow(at: indexPath) as! MenuCategoryTableViewCell
            let category = self.category(at: indexPath)
            let filter = Filter(isOwnersOnly: cell.isOwnersOnly)
            self.actionShowCategory(category, filter: filter)
        default:
            if indexPath.row == numberOfRows - 1 {
                self.actionLogout()
            } else {
                self.actionShowService()
            }
        }
    }
    
    
    // MARK: - Utils
    
    fileprivate func category(at indexPath: IndexPath) -> Category {
        let index = indexPath.row - categoriesMenuRange().lowerBound
        return categories[index]
    }
    
    fileprivate func categoriesMenuRange() -> Range<Int> {
        return 1..<1+categories.count
    }
    
}

// MARK: - MenuCategoryTableViewCellDelegate

extension SideMenuViewController: MenuCategoryTableViewCellDelegate {
    func menuCategoryCell(_ cell: MenuCategoryTableViewCell, didSwitchSliderValue isOn: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let category = self.category(at: indexPath)
        let filter = Filter(isOwnersOnly: cell.isOwnersOnly)
        self.actionShowCategory(category, filter: filter)
    }
}
