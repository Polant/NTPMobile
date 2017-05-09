//
//  TypeDispatcher.swift
//  NTPMobile
//
//  Created by Anton Poltoratskyi on 09.05.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import Foundation

func transform<Type, Result>(_ value: Type) -> Result? {
    return value as? Result
}

enum TypeDispatcher<Wrapped> {
    case value(Wrapped)
    
    func dispatch<Subject>(_ f: (Subject) -> Void) -> TypeDispatcher<Wrapped> {
        switch self {
        case let .value(x):
            transform(x).map { f($0) }
            return .value(x)
        }
    }
    
    func extract() -> Wrapped {
        switch self {
        case let .value(x):
            return x
        }
    }
}
