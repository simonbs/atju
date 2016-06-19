//
//  UIColor.swift
//  Tracks
//
//  Created by Simon Støvring on 21/08/2015.
//  Copyright © 2015 SimonBS. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    convenience init(hex: Int, alpha: Float) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255.0,
            green: CGFloat((hex >> 8) & 0xff) / 255.0,
            blue: CGFloat(hex & 0xff) / 255.0,
            alpha: CGFloat(alpha))
    }
}
