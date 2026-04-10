//
//  Expense.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-31.
//

import Foundation

struct Expense: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var amount: Double
    var paidBy: String
    var sharedWith: [String]

    init(id: UUID = UUID(), title: String, amount: Double, paidBy: String, sharedWith: [String]) {
        self.id = id
        self.title = title
        self.amount = amount
        self.paidBy = paidBy
        self.sharedWith = sharedWith
    }
}
