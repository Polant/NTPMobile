//
//  UITableView+Update.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 09.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

extension UITableView {
    func update(with handler: () -> Void) {
        self.beginUpdates()
        handler()
        self.endUpdates()
    }
}
