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
    @State private var showingIdentityPicker = false
    @State private var currentIdentity: String? = nil  // member name, outsider sentinel, or nil (not set)

    private var isOutsider: Bool {
        currentIdentity == TripIdentity.outsider
    }

    private var totalSpent: Double {
        trip.expenses.reduce(0) { $0 + $1.amount }
    }

    private var recentExpense: Expense? {
        trip.expenses.sorted { $0.date > $1.date }.first
    }

    private var nextItineraryItem: ItineraryItem? {
        let now = Date()
        let sorted = trip.itineraryItems.sorted { $0.date < $1.date }
        return sorted.first { $0.date >= now } ?? sorted.last
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                Text(trip.destination)
                    .font(.title)

                Text("Dates:")
                    .font(.headline)

                Text(formattedDateRange)

                Divider()

                if !isOutsider {
                    Text("Budget")
                        .font(.headline)

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Budget per person: \(formattedBudget)")
                            Text("Total spent: \(String(format: "$%.2f", totalSpent))")
                                .foregroundColor(totalSpent > trip.budget * Double(max(trip.members.count, 1)) ? .red : .secondary)
                            if let recent = recentExpense {
                                Text("Last expense: \(recent.title) (\(String(format: "$%.2f", recent.amount)))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    Divider()
                }
            }

            Group {
                Text("Itinerary")
                    .font(.headline)

                if let next = nextItineraryItem {
                    Text("Next: \(next.title) — \(next.date.formatted(date: .abbreviated, time: .shortened))")
                        .foregroundColor(.secondary)
                } else {
                    Text("No itinerary items yet")
                        .foregroundColor(.secondary)
                }

                NavigationLink("View Itinerary") {
                    ItineraryView(trip: $trip)
                }

                if !isOutsider {
                    NavigationLink("View Budget / Expenses") {
                        BudgetView(trip: $trip)
                    }
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

            identityRow

            if !isOutsider {
                Button("Edit Trip") {
                    showingEditTrip = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .navigationTitle("Trip Details")
        .onAppear {
            currentIdentity = TripIdentity.get(for: trip.id)
            if currentIdentity == nil {
                showingIdentityPicker = true
            }
        }
        .sheet(isPresented: $showingIdentityPicker) {
            TripIdentityPickerView(trip: trip) { chosen in
                TripIdentity.set(chosen, for: trip.id)
                currentIdentity = chosen
            }
        }
        .sheet(isPresented: $showingEditTrip) {
            EditTripView(trip: $trip, onDelete: {
                onDelete()
                dismiss()
            })
        }
    }

    private var identityRow: some View {
        HStack {
            if let identity = currentIdentity {
                if identity == TripIdentity.outsider {
                    Text("Viewing as: Outsider")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("Viewing as: \(identity)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Identity not set")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button("Change") {
                showingIdentityPicker = true
            }
            .font(.subheadline)
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
