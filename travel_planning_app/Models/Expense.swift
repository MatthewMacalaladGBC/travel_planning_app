//
//  Expense.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-31.
//

import Foundation

enum ExpenseCategory: String, Codable, Hashable, CaseIterable {
    case food = "Food"
    case transport = "Transport"
    case accommodation = "Accommodation"
    case activities = "Activities"
    case shopping = "Shopping"
    case other = "Other"
}

struct Expense: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var amount: Double
    var paidBy: String
    var sharedWith: [String]
    var category: ExpenseCategory
    var date: Date
    var splitAmounts: [String: Double]?  // nil = equal split; keyed by member name

    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        paidBy: String,
        sharedWith: [String],
        category: ExpenseCategory = .other,
        date: Date = Date(),
        splitAmounts: [String: Double]? = nil
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.paidBy = paidBy
        self.sharedWith = sharedWith
        self.category = category
        self.date = date
        self.splitAmounts = splitAmounts
    }

    enum CodingKeys: String, CodingKey {
        case id, title, amount, paidBy, sharedWith, category, date, splitAmounts
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        amount = try container.decode(Double.self, forKey: .amount)
        paidBy = try container.decode(String.self, forKey: .paidBy)
        sharedWith = try container.decode([String].self, forKey: .sharedWith)
        category = try container.decodeIfPresent(ExpenseCategory.self, forKey: .category) ?? .other
        date = try container.decodeIfPresent(Date.self, forKey: .date) ?? Date()
        splitAmounts = try container.decodeIfPresent([String: Double].self, forKey: .splitAmounts)
    }
}
