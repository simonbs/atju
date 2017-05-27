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
        var deltaComponents = DateComponents()
        deltaComponents.day = 1
        return Calendar.current.date(byAdding: deltaComponents, to: Date())
    }
    
    func dateForYesterday() -> Date? {
        var deltaComponents = DateComponents()
        deltaComponents.day = -1
        return Calendar.current.date(byAdding: deltaComponents, to: Date())
    }
    
    func isToday() -> Bool {
        let dateComps = dateComponents(date: self)
        let todayComps = dateComponents(date: Date())
        return dateComps.year == todayComps.year && dateComps.month == todayComps.month && dateComps.day == todayComps.day
    }
    
    func isYesterday() -> Bool {
        guard let yesterday = dateForYesterday() else { return false }
        let dateComps = dateComponents(date: self)
        let yesterdayComps = dateComponents(date: yesterday)
        return dateComps.year == yesterdayComps.year && dateComps.month == yesterdayComps.month && dateComps.day == yesterdayComps.day
    }

    func isTomorrow() -> Bool {
        guard let tomorrow = dateForTomorrow() else { return false }
        let dateComps = dateComponents(date: self)
        let tomorrowComps = dateComponents(date: tomorrow)
        return dateComps.year == tomorrowComps.year && dateComps.month == tomorrowComps.month && dateComps.day == tomorrowComps.day
    }

    func isWithinAWeek() -> Bool {
        let weekInterval: TimeInterval = 7 * 24 * 3600
        let now = Date()
        let weekIntoTheFuture = now + weekInterval
        return timeIntervalSince1970 < weekIntoTheFuture.timeIntervalSince1970 && timeIntervalSince1970 > now.timeIntervalSince1970
    }
    
    private func dateComponents(date: Date) -> DateComponents {
        return Calendar.current.dateComponents([ .day, .month, .year ], from: date)
    }
}

func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSinceReferenceDate < rhs.timeIntervalSinceReferenceDate
}

func >(lhs: Date, rhs: Date) -> Bool {
    return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
}

