//
//  Result.swift
//  Atju
//
//  Created by Simon Støvring on 27/05/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation

enum Result<T> {
    case value(T)
    case error(Swift.Error)
    
    init(_ value: T) {
        self = .value(value)
    }
    
    init(_ error: Swift.Error) {
        self = .error(error)
    }
}
