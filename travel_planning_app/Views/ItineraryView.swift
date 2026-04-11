//
//  ItineraryView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import SwiftUI

struct ItineraryView: View {
    @Binding var trip: Trip
    @State private var showingAddActivity = false

    /// Indices of itineraryItems sorted by date ascending.
    private var sortedIndices: [Int] {
        trip.itineraryItems.indices.sorted { trip.itineraryItems[$0].date < trip.itineraryItems[$1].date }
    }

    var body: some View {
        VStack {
            if trip.itineraryItems.isEmpty {
                Spacer()
                Text("No itinerary items yet.")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(sortedIndices, id: \.self) { index in
                        NavigationLink {
                            ItineraryItemDetailView(item: $trip.itineraryItems[index])
                        } label: {
                            let item = trip.itineraryItems[index]
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.title)
                                    .font(.headline)

                                HStack(spacing: 4) {
                                    Text(item.date.formatted(date: .abbreviated, time: .shortened))
                                        .foregroundColor(.secondary)
                                    if let location = item.location, !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        Text("• \(location)")
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .font(.subheadline)

                                if let cost = item.cost {
                                    Text(String(format: "$%.2f", cost))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                if item.hasNotes {
                                    Text(item.notes)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
            }

            Button("+ Add Activity") {
                showingAddActivity = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Itinerary")
        .sheet(isPresented: $showingAddActivity) {
            AddItineraryItemView(trip: $trip)
        }
    }

    private func deleteItem(at offsets: IndexSet) {
        let realIndices = IndexSet(offsets.map { sortedIndices[$0] })
        trip.itineraryItems.remove(atOffsets: realIndices)
    }

}
