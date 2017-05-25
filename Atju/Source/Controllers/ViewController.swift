//
//  ViewController.swift
//  Atju
//
//  Created by Simon Støvring on 16/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import UIKit

class ViewController<TheView: View>: UIViewController {
    var contentView: TheView {
        return view as! TheView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = TheView()
    }
}
