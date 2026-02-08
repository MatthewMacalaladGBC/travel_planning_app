//
//  HomeView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import SwiftUI

struct HomeView: View {
    // Single hard-coded trip for now; data will be properly stored in future iterations
    @State private var trips: [Trip] = [
        Trip(destination: "Tokyo",
             startDate: Date(),
             endDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
             budget: 2000.00,
             status: .current
        )
    ]
    
    @State private var showAddTrip = false
    
    var body: some View {
        VStack {
            Text("My Trips")
                .font(.title)
                .padding()
                .foregroundColor(.blue)
            
            List {
                Section(header: Text("Current Trip")
                    .font(.title2)
                    .fontWeight(.bold)
                ) {
                    ForEach(trips.filter { $0.status == .current }) {
                        trip in NavigationLink {
                            TripDetailView(trip: trip)
                        } label: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(trip.destination)
                                    .fontWeight(.bold)
                                Text("\(trip.startDate.formatted(date: .abbreviated, time: .omitted)) - \(trip.endDate.formatted(date: .abbreviated, time: .omitted))")
                            }
                        }
                    }
                }
                
                Section(header: Text("Upcoming Trips")
                    .font(.title2)
                    .fontWeight(.bold)
                ) {
                    Text("No upcoming trips")
                        .foregroundColor(.gray)
                }
                
                Section(header: Text("Past Trips")
                    .font(.title2)
                    .fontWeight(.bold)
                ) {
                    Text("No past trips")
                        .foregroundColor(.gray)
                }
            }
            
            Button("+ Add Trip") {
                showAddTrip = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .sheet(isPresented: $showAddTrip) {
            AddTripView()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
