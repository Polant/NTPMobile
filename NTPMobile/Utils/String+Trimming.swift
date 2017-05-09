//
//  String+Trimming.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 09.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

extension String {
    
    func trimmed(to length: Int) -> String {
        guard self.characters.count > length else {
            return self
        }
        let trimIndex = self.index(self.startIndex, offsetBy: length)
        return self.substring(to: trimIndex)
    }
}
