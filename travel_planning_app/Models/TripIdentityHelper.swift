//
//  TripIdentityHelper.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-04-10.
//

import Foundation

enum TripIdentity {
    // Stored in UserDefaults when the user picks "Just viewing"
    static let outsider = "__outsider__"

    static func key(for tripID: UUID) -> String {
        "currentUser_\(tripID.uuidString)"
    }

    // Returns the stored identity: a member name, `outsider`, or nil if not yet set.
    static func get(for tripID: UUID) -> String? {
        UserDefaults.standard.string(forKey: key(for: tripID))
    }

    static func set(_ identity: String, for tripID: UUID) {
        UserDefaults.standard.set(identity, forKey: key(for: tripID))
    }

    static func clear(for tripID: UUID) {
        UserDefaults.standard.removeObject(forKey: key(for: tripID))
    }

    static func isOutsider(for tripID: UUID) -> Bool {
        get(for: tripID) == outsider
    }

    // Returns nil if outsider or not set; otherwise the member name.
    static func memberName(for tripID: UUID) -> String? {
        let value = get(for: tripID)
        guard let value, value != outsider else { return nil }
        return value
    }
}
