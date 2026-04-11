//
//  Member.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import Foundation

struct Member: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var email: String?
    var phoneNumber: String?

    init(id: UUID = UUID(), name: String, email: String? = nil, phoneNumber: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
    }
}
