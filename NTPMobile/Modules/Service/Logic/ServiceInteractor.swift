//
//  ServiceInteractor.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 14.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

typealias PathCompletion = (ResponseResult<PathDirection>) -> Void

class ServiceInteractor: Interactor<ServiceViewController> {
    
    func getPathDirection(completion: @escaping PathCompletion) {
        ServiceManager.shared.getPathDirection { result in
            completion(result)
        }
    }
    
}
