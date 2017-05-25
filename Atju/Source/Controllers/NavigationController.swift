//
//  NavigationController.swift
//  Atju
//
//  Created by Simon Støvring on 18/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return viewControllers.first?.preferredStatusBarStyle ?? .default
    }
}
