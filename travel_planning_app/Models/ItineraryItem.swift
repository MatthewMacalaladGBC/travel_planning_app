//
//  ItineraryItem.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import Foundation

struct ItineraryItem: Identifiable, Hashable, Codable {
    let id: UUID
    var date: Date      // stores full date + time
    var title: String
    var members: [Member]
    var notes: String
    var location: String?
    var cost: Double?

    init(
        id: UUID = UUID(),
        date: Date,
        title: String,
        members: [Member],
        notes: String,
        location: String? = nil,
        cost: Double? = nil
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.members = members
        self.notes = notes
        self.location = location
        self.cost = cost
    }

    enum CodingKeys: String, CodingKey {
        case id, date, title, members, notes, location, cost
        // timeText is intentionally omitted — legacy field, ignored on decode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        title = try container.decode(String.self, forKey: .title)
        members = try container.decode([Member].self, forKey: .members)
        notes = try container.decode(String.self, forKey: .notes)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        cost = try container.decodeIfPresent(Double.self, forKey: .cost)
    }
}

extension ItineraryItem {

    var hasNotes: Bool {
        !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var memberDisplayText: String {
        members.isEmpty ? "None" : members.map { $0.name }.joined(separator: ", ")
    }
}
