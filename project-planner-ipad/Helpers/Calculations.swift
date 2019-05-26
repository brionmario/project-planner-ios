//
//  Calculations.swift
//  project-planner-ipad
//
//  Created by Brion Silva on 26/05/2019.
//  Copyright © 2019 Brion Silva. All rights reserved.
//

import Foundation

public class Calculations {
    public func getDateDifference(_ start: Date, end: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
    public func getRemainingDaysPercentage(_ start: Date, end: Date) -> Int {
        let currentDate = Date()
        let duration = getDateDifference(start, end: end)
        let daysLeft = getDateDifference(currentDate, end: end)
        
        if duration > 0 {
            return Int(100 - ((daysLeft / duration) * 100))
        }
        
        return 100
    }
    
    public func getDaysAndHoursLeft(end: Date) -> (Int, Int) {
        let currentDate = Date()
        let difference: TimeInterval? = end.timeIntervalSince(currentDate)
        
        let secondsInAnHour: Double = 3600
        let secondsInDays: Double = 86400
        
        let diffInDays = Int((difference! / secondsInDays))
        let diffInHours = Int((difference! / secondsInAnHour))
        
        var daysLeft = diffInDays
        var hoursLeft = diffInHours - (diffInDays * 24)
        
        if hoursLeft < 0 {
            hoursLeft = 0
        }
        
        if daysLeft < 0 {
            daysLeft = 0
        }
        
        return (daysLeft, hoursLeft)
    }
    
    public func getProjectProgress(_ tasks: [Task]) -> Int {
        var progressTotal: Float = 0
        var progress: Int = 0
        
        if tasks.count > 0 {
            for task in tasks {
                progressTotal += task.progress
            }
            progress = Int(progressTotal) / tasks.count
        }
        
        return progress
    }
}
