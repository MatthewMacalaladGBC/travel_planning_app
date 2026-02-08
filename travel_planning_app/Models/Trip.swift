//
//  Trip.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import Foundation

struct Trip: Identifiable, Hashable {
    let id = UUID()
    let destination: String
    let startDate: Date
    let endDate: Date
    let budget: Double
    let status: Status
    
    enum Status {
        case current
        case upcoming
        case past
    }
}
