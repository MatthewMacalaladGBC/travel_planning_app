//
//  Member.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import Foundation

struct Member: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var email: String?
    var phoneNumber: String?
}
