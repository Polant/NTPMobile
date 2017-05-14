//
//  App+MKAnnotation.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 14.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import MapKit

extension App: MKAnnotation {
    
    var title: String? {
        return self.name
    }
    
    var coordinate: CLLocationCoordinate2D {
        
        let components = self.location
            .components(separatedBy: ";")
            .map { CLLocationDegrees($0)! }
        
        return CLLocationCoordinate2D(latitude: components.first!,
                                      longitude: components.last!)
    }
}

