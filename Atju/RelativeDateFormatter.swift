//
//  RelativeDateFormatter.swift
//  Atju
//
//  Created by Simon Støvring on 18/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

struct RelativeDateFormatter {
    private static let weekdayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(localeIdentifier: "da_DK")
        return dateFormatter
    }()
    
    private static let fullDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. LLL"
        dateFormatter.locale = Locale(localeIdentifier: "da_DK")
        return dateFormatter
    }()
    
    static func string(from date: Date) -> String  {
        if date.isToday() {
            return localize("RELATIVE_DATE_TODAY")
        } else if date.isYesterday() {
            return localize("RELATIVE_DATE_YESTERDAY")
        } else if date.isTomorrow() {
            return localize("RELATIVE_DATE_TOMORROW")
        } else if date.isWithinAWeek() {
            return weekdayFormatter.string(from: date).capitalized
        }
        
        return fullDateFormatter.string(from: date)
    }
}
