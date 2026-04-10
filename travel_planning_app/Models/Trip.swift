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
    var paidSettlementKeys: Set<String>  // "debtor | creditor" keys for paid settlements

    init(
        id: UUID = UUID(),
        destination: String,
        startDate: Date,
        endDate: Date,
        members: [Member],
        budget: Double,
        status: Status,
        itineraryItems: [ItineraryItem] = [],
        expenses: [Expense] = [],
        paidSettlementKeys: Set<String> = []
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
        self.paidSettlementKeys = paidSettlementKeys
    }

    enum Status: String, Codable, Hashable {
        case current
        case upcoming
        case past
    }

    enum CodingKeys: String, CodingKey {
        case id, destination, startDate, endDate, members, budget, status
        case itineraryItems, expenses, paidSettlementKeys
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        destination = try container.decode(String.self, forKey: .destination)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        members = try container.decode([Member].self, forKey: .members)
        budget = try container.decode(Double.self, forKey: .budget)
        status = try container.decode(Status.self, forKey: .status)
        itineraryItems = try container.decodeIfPresent([ItineraryItem].self, forKey: .itineraryItems) ?? []
        expenses = try container.decodeIfPresent([Expense].self, forKey: .expenses) ?? []
        paidSettlementKeys = try container.decodeIfPresent(Set<String>.self, forKey: .paidSettlementKeys) ?? []
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
