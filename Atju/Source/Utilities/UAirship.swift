//
//  UAirship.swift
//  Atju
//
//  Created by Simon Støvring on 04/07/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import AirshipKit

extension UAirship {
    static var sbs_isConfigAvailable: Bool {
        return Bundle.main().pathForResource("AirshipConfig", ofType: "plist") != nil
    }
}

