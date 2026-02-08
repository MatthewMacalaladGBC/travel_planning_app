//
//  DayItineraryView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import SwiftUI

struct DayItineraryView: View {
    let trip: Trip
    let day: Date
    let dayItems: [ItineraryItem]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                if dayItems.isEmpty {
                    Text("No itinerary items for this day yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(dayItems) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(item.title)
                                .font(.headline)
                            
                            Text("Time: \(item.timeText)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text("Members: \(memberNames(item.members))")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            if !item.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("Notes: \(item.notes)")
                                    .font(.subheadline)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle(dayTitle(day))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private func memberNames(_ members: [Member]) -> String {
        if members.isEmpty { return "None" }
        return members.map { $0.name }.joined(separator: ", ")
    }
    
    private func dayTitle(_ date: Date) -> String {
        date.formatted(.dateTime.weekday(.wide).month().day())
    }
    
}
