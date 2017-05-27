//
//  JSON+Date.swift
//  Atju
//
//  Created by Simon Støvring on 25/05/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation
import Freddy

extension Freddy.JSON {
    /// DateFormatters can be expensive to create. Bring your own and make sure you reuse it.
    func getDate(at key: String, using dateFormatter: DateFormatter) throws -> Date {
        guard let date = dateFormatter.date(from: try getString(at: key)) else {
            throw JSON.Error.valueNotConvertible(value: self, to: Date.self)
        }
        return date
    }
}
