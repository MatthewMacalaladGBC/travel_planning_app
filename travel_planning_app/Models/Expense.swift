//
//  Expense.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-31.
//

import Foundation

struct Expense: Identifiable, Hashable{
    let id = UUID()
    var title: String
    var amount: Double
    var paidBy: String
    var sharedWith: [String]
}
