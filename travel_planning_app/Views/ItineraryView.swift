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

    private var sortedItems: [ItineraryItem] {
        trip.itineraryItems.sorted { $0.date < $1.date }
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
                    ForEach($trip.itineraryItems) { $item in
                        NavigationLink {
                            ItineraryItemDetailView(item: $item)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.title)
                                    .font(.headline)

                                HStack(spacing: 4) {
                                    Text("\(formattedDate(item.date)) • \(item.timeText)")
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
        trip.itineraryItems.remove(atOffsets: offsets)
    }

    private func formattedDate(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
}
