//
//  ItineraryItem.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import Foundation

struct ItineraryItem: Identifiable, Hashable, Codable {
    let id: UUID
    var date: Date
    var title: String
    var timeText: String
    var members: [Member]
    var notes: String

    init(id: UUID = UUID(), date: Date, title: String, timeText: String, members: [Member], notes: String) {
        self.id = id
        self.date = date
        self.title = title
        self.timeText = timeText
        self.members = members
        self.notes = notes
    }
}

extension ItineraryItem {

    // Returns true if this itinerary item has any notes
    var hasNotes: Bool {
        !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // Returns a display-friendly member list
    var memberDisplayText: String {
        members.isEmpty ? "None" : members.map { $0.name }.joined(separator: ", ")
    }
}
