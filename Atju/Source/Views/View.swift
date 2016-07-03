//
//  View.swift
//  Atju
//
//  Created by Simon Støvring on 16/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import UIKit

class View: UIView {
    required init() {
        super.init(frame: .zero)
        setupSubviews()
        defineLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() { }
    
    func defineLayout() { }
}
