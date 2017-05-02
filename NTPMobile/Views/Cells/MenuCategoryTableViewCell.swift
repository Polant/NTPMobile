//
//  MenuCategoryTableViewCell.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 02.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class MenuCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var ownersSwitch: UISwitch!
    
    func setup(with category: Category) {
        self.categoryNameLabel.text = category.name
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
    }
}
