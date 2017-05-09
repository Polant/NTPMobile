//
//  MenuCategoryTableViewCell.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 02.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol MenuCategoryTableViewCellDelegate: class {
    func menuCategoryCell(_ cell: MenuCategoryTableViewCell, didSwitchSliderValue isOn: Bool)
}

class MenuCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var ownersSwitch: UISwitch!
    
    var isOwnersOnly: Bool = false
    weak var delegate: MenuCategoryTableViewCellDelegate?
    
    func setup(with category: Category) {
        categoryNameLabel.text = category.name
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        isOwnersOnly = sender.isOn
        delegate?.menuCategoryCell(self, didSwitchSliderValue: isOwnersOnly)
    }
}
