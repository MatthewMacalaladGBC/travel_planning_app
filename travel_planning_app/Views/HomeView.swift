//
//  HomeView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import SwiftUI

struct HomeView: View {
    @State private var trips: [Trip] = [
        Trip(
            destination: "Montreal",
            startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 10)) ?? Date(),
            endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 15)) ?? Date(),
            members: [
                Member(name: "Sara"),
                Member(name: "Matthew"),
                Member(name: "Karen")
            ],
            budget: 1500,
            status: .past,
            itineraryItems: [
                ItineraryItem(
                    date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 11)) ?? Date(),
                    title: "Old Montreal Tour",
                    timeText: "10:00 AM",
                    members: [
                        Member(name: "Sara"),
                        Member(name: "Matthew"),
                        Member(name: "Karen")
                    ],
                    notes: "Walk around and take pictures"
                ),
                ItineraryItem(
                    date: Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 12)) ?? Date(),
                    title: "Dinner Downtown",
                    timeText: "7:00 PM",
                    members: [
                        Member(name: "Sara"),
                        Member(name: "Matthew")
                    ],
                    notes: "Try a popular restaurant"
                )
            ],
            expenses: [
                Expense(
                    title: "Hotel",
                    amount: 600,
                    paidBy: "Sara",
                    sharedWith: ["Sara", "Matthew", "Karen"]
                ),
                Expense(
                    title: "Dinner",
                    amount: 150,
                    paidBy: "Matthew",
                    sharedWith: ["Sara", "Matthew"]
                )
            ]
        )
    ]
    @State private var showAddTrip = false

    var currentTripIndices: [Int] {
        trips.indices.filter { trips[$0].status == .current }
    }

    var upcomingTripIndices: [Int] {
        trips.indices.filter { trips[$0].status == .upcoming }
    }

    var pastTripIndices: [Int] {
        trips.indices.filter { trips[$0].status == .past }
    }

    var body: some View {
        VStack {
            Text("Trip Planner")
                .font(.title)
                .padding()
                .foregroundColor(.blue)

            List {
                Section(
                    header: Text("Current Trip")
                        .font(.title2)
                        .fontWeight(.bold)
                ) {
                    if currentTripIndices.isEmpty {
                        Text("No current trips")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(currentTripIndices, id: \.self) { index in
                            let tripId = trips[index].id

                            NavigationLink {
                                TripDetailView(
                                    trip: $trips[index],
                                    onDelete: {
                                        trips.removeAll { $0.id == tripId }
                                    }
                                )
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(trips[index].destination)
                                        .fontWeight(.bold)
                                    Text(formattedDateRange(for: trips[index]))
                                }
                            }
                        }
                    }
                }

                Section(
                    header: Text("Upcoming Trips")
                        .font(.title2)
                        .fontWeight(.bold)
                ) {
                    if upcomingTripIndices.isEmpty {
                        Text("No upcoming trips")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(upcomingTripIndices, id: \.self) { index in
                            let tripId = trips[index].id

                            NavigationLink {
                                TripDetailView(
                                    trip: $trips[index],
                                    onDelete: {
                                        trips.removeAll { $0.id == tripId }
                                    }
                                )
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(trips[index].destination)
                                        .fontWeight(.bold)
                                    Text(formattedDateRange(for: trips[index]))
                                }
                            }
                        }
                    }
                }

                Section(
                    header: Text("Past Trips")
                        .font(.title2)
                        .fontWeight(.bold)
                ) {
                    if pastTripIndices.isEmpty {
                        Text("No past trips")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(pastTripIndices, id: \.self) { index in
                            let tripId = trips[index].id

                            NavigationLink {
                                TripDetailView(
                                    trip: $trips[index],
                                    onDelete: {
                                        trips.removeAll { $0.id == tripId }
                                    }
                                )
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(trips[index].destination)
                                        .fontWeight(.bold)
                                    Text(formattedDateRange(for: trips[index]))
                                }
                            }
                        }
                    }
                }
            }

            Button("+ Add Trip") {
                showAddTrip = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .sheet(isPresented: $showAddTrip) {
            AddTripView(trips: $trips)
        }
    }

    private func formattedDateRange(for trip: Trip) -> String {
        "\(trip.startDate.formatted(date: .abbreviated, time: .omitted)) - \(trip.endDate.formatted(date: .abbreviated, time: .omitted))"
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}
