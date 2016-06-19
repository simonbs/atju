//
//  Operators.swift
//  Atju
//
//  Created by Simon Støvring on 16/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

infix operator => { associativity left precedence 160 }
func =><T, U>(lhs: T?, rhs: (@noescape (T) -> U?)?) -> U? {
    if let lhs = lhs {
        if let rhs = rhs {
            return rhs(lhs)
        }
    }
    
    return nil
}

func =><T>(lhs: T?, rhs: (@noescape (T) -> Void)?) {
    if let lhs = lhs {
        if let rhs = rhs {
            rhs(lhs)
        }
    }
}
