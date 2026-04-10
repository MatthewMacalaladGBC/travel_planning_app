//
//  Trip.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import Foundation

struct Trip: Identifiable, Hashable, Codable {
    let id: UUID
    var destination: String
    var startDate: Date
    var endDate: Date
    var members: [Member]
    var budget: Double
    var status: Status
    var itineraryItems: [ItineraryItem]
    var expenses: [Expense]

    init(
        id: UUID = UUID(),
        destination: String,
        startDate: Date,
        endDate: Date,
        members: [Member],
        budget: Double,
        status: Status,
        itineraryItems: [ItineraryItem] = [],
        expenses: [Expense] = []
    ) {
        self.id = id
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.members = members
        self.budget = budget
        self.status = status
        self.itineraryItems = itineraryItems
        self.expenses = expenses
    }

    enum Status: String, Codable, Hashable {
        case current
        case upcoming
        case past
    }

    static func calculateStatus(startDate: Date, endDate: Date) -> Status {
        let today = Calendar.current.startOfDay(for: Date())
        let start = Calendar.current.startOfDay(for: startDate)
        let end = Calendar.current.startOfDay(for: endDate)

        if today < start {
            return .upcoming
        } else if today > end {
            return .past
        } else {
            return .current
        }
    }
}
