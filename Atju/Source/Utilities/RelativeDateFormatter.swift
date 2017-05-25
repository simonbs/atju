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
        dateFormatter.locale = Locale(identifier: "da_DK")
        dateFormatter.timeZone = TimeZone(abbreviation: "CET")
        return dateFormatter
    }()
    
    private static let fullDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd. LLLL"
        dateFormatter.locale = Locale(identifier: "da_DK")
        dateFormatter.timeZone = TimeZone(abbreviation: "CET")
        return dateFormatter
    }()
    
    private static let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = localize("TIME_FORMAT")
        dateFormatter.locale = Locale(identifier: "da_DK")
        dateFormatter.timeZone = TimeZone(abbreviation: "CET")
        return dateFormatter
    }()
    
    static func string(from date: Date) -> String  {
        let dateStr: String
        if date.isToday() {
            dateStr = localize("RELATIVE_DATE_TODAY")
        } else if date.isYesterday() {
            dateStr = localize("RELATIVE_DATE_YESTERDAY")
        } else if date.isTomorrow() {
            dateStr = localize("RELATIVE_DATE_TOMORROW")
        } else if date.isWithinAWeek() {
            dateStr = weekdayFormatter.string(from: date).capitalized
        } else {
            dateStr = fullDateFormatter.string(from: date)
        }
        let timeStr = timeFormatter.string(from: date)
        return "\(dateStr) \(timeStr)"
    }
}
