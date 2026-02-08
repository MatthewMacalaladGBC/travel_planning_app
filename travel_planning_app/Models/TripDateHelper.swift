//
//  TripDateHelper.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import Foundation

enum TripDateHelper {
    static func daysInclusive(from start: Date, to end: Date) -> [Date] {
        let cal = Calendar.current
        let startDay = cal.startOfDay(for: start)
        let endDay = cal.startOfDay(for: end)
        
        guard startDay <= endDay else { return [startDay] }
        
        var days: [Date] = []
        var current = startDay
        
        while current <= endDay {
            days.append(current)
            current = cal.date(byAdding: .day, value: 1, to: current) ?? current
        }
        
        return days
    }
}
