//
//  Date.swift
//  Atju
//
//  Created by Simon Støvring on 18/06/2016.
//  Copyright © 2016 SimonBs. All rights reserved.
//

import Foundation

extension Date {
    func dateForTomorrow() -> Date? {
        return date(forDeltaDay: 1)
    }
    
    func dateForYesterday() -> Date? {
        return date(forDeltaDay: -1)
    }
    
    func dateForDayBeforeYesterday() -> Date? {
        return date(forDeltaDay: -2)
    }
    
    private func date(forDeltaDay deltaDay: Int) -> Date? {
        var deltaComponents = DateComponents()
        deltaComponents.day = deltaDay
        return Calendar.current.date(byAdding: deltaComponents, to: Date())
    }
    
    func isTomorrow() -> Bool {
        guard let tomorrow = dateForTomorrow() else { return false }
        return isSameDay(as: tomorrow)
    }
    
    func isToday() -> Bool {
        return isSameDay(as: Date())
    }
    
    func isYesterday() -> Bool {
        guard let yesterday = dateForYesterday() else { return false }
        return isSameDay(as: yesterday)
    }
    
    func isDayBeforeYesterday() -> Bool {
        guard let dayBeforeYesterday = dateForDayBeforeYesterday() else { return false }
        return isSameDay(as: dayBeforeYesterday)
    }

    func isWithinAWeek() -> Bool {
        let weekInterval: TimeInterval = 7 * 24 * 3600
        let now = Date()
        let weekIntoTheFuture = now + weekInterval
        return timeIntervalSince1970 < weekIntoTheFuture.timeIntervalSince1970 && timeIntervalSince1970 > now.timeIntervalSince1970
    }
    
    private func isSameDay(as otherDate: Date) -> Bool {
        let dateComps = dateComponents(date: self)
        let otherDateComps = dateComponents(date: otherDate)
        return dateComps.year == otherDateComps.year && dateComps.month == otherDateComps.month && dateComps.day == otherDateComps.day
    }
    
    private func dateComponents(date: Date) -> DateComponents {
        return Calendar.current.dateComponents([ .day, .month, .year ], from: date)
    }
}
