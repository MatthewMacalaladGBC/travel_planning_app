//
//  TripDetailView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(trip.destination)
                .font(.title)
            
            Text("Dates:")
                .font(.headline)
            
            Text("\(trip.startDate.formatted(date: .abbreviated, time: .omitted)) - \(trip.endDate.formatted(date: .abbreviated, time: .omitted))")
            
            Divider()
            
            Text("Budget Preview")
                .font(.headline)
            
            Text("Expected budget per person: $\(trip.budget, specifier: "%.2f")")
            
            Divider()
            
            Text("Itinerary")
                .font(.headline)
            
            Text("Next: (placeholder)")
                .foregroundStyle(.secondary)
            
            NavigationLink("View Itinerary") {
                ItineraryView(trip: trip)
            }
            
            Divider()
            
            Text("Members")
                .font(.headline)
            
            List {
                Text("Sample Member 1")
                Text("Sample Member 2")
            }
            
            Spacer()
            
            Button("Edit Trip") {
                
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Trip Details")
    }
}
extension TripDetailView {
    
    /// Returns a formatted date range for display
    var formattedDateRange: String {
        "\(trip.startDate.formatted(date: .abbreviated, time: .omitted)) - \(trip.endDate.formatted(date: .abbreviated, time: .omitted))"
    }
    
    /// Returns the formatted budget string
    var formattedBudget: String {
        "$\(trip.budget, specifier: "%.2f")"
    }
}