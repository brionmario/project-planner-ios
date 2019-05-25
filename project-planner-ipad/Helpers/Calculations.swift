//
//  Calculations.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 26/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import Foundation

class Calculations {
    func getDateDifference(_ start: Date, end: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
    func getRemainingDaysPercentage(_ start: Date, end: Date) -> Int {
        let currentDate = Date()
        let duration = getDateDifference(start, end: end)
        let daysLeft = getDateDifference(currentDate, end: end)
        
        return Int(((duration - daysLeft) / duration) * 100)
    }
    
    func getDaysAndHoursLeft(end: Date) -> (Int, Int) {
        let currentDate = Date()
        let difference: TimeInterval? = end.timeIntervalSince(currentDate)
        
        let secondsInAnHour: Double = 3600
        let secondsInDays: Double = 86400
        
        let diffInDays = Int((difference! / secondsInDays))
        let diffInHours = Int((difference! / secondsInAnHour))
        
        let daysLeft = diffInDays
        let hoursLeft = diffInHours - (diffInDays * 24)
        
        return (daysLeft, hoursLeft)
    }
}
