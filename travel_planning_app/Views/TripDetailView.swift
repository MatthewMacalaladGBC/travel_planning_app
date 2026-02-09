//
//  TripDetailView.swift
//  travel_planning_app
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
    
    var formattedDateRange: String {
        "\(trip.startDate.formatted(date: .abbreviated, time: .omitted)) - \(trip.endDate.formatted(date: .abbreviated, time: .omitted))"
    }
    
    var formattedBudget: String {
        String(format: "$%.2f", trip.budget)
    }
}
