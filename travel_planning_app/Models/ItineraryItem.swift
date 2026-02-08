//
//  ItineraryItem.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import Foundation

struct ItineraryItem: Identifiable, Hashable {
    let id = UUID()
    var date: Date
    var title: String
    
    var timeText: String
    var members: [Member]
    var notes: String
}
