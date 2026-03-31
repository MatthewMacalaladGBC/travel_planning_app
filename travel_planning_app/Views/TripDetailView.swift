//
//  TripDetailView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import SwiftUI

struct TripDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var trip: Trip
    let onDelete: () -> Void
    @State private var showingEditTrip = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text(trip.destination)
                    .font(.title)

                Text("Dates:")
                    .font(.headline)

                Text(formattedDateRange)

                Divider()

                Text("Budget Preview")
                    .font(.headline)

                Text("Expected budget per person: \(formattedBudget)")

                Divider()
            }

            Group {
                Text("Itinerary")
                    .font(.headline)

                if let nextItem = trip.itineraryItems.sorted(by: { $0.date < $1.date }).first {
                    Text("Next: \(nextItem.title) - \(nextItem.timeText)")
                        .foregroundColor(.secondary)
                } else {
                    Text("Next: (placeholder)")
                        .foregroundColor(.secondary)
                }

                NavigationLink("View Itinerary") {
                    ItineraryView(trip: $trip)
                }
                NavigationLink("View Budget / Expenses"){
                    BudgetView(trip: $trip)
                }

                Divider()

                Text("Members")
                    .font(.headline)
            }

            if trip.members.isEmpty {
                Text("No members added yet")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(trip.members) { member in
                        Text(member.name)
                    }
                }
            }

            Spacer()

            Button("Edit Trip") {
                showingEditTrip = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Trip Details")
        .sheet(isPresented: $showingEditTrip) {
            EditTripView(trip: $trip, onDelete: {
                onDelete()
                dismiss()
            })
        }
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
