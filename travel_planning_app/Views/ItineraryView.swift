//
//  ItineraryView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import SwiftUI

struct ItineraryView: View {
    let trip: Trip
    @State private var selectedDay: Date = Date()
    @State private var showingDaySheet = false
    
    // Hard-coded items for UI prototype
    private var sampleItems: [ItineraryItem] {
        let days = tripDays
        guard let day1 = days.first else { return [] }
        
        let members = trip.members.isEmpty
        ? [ Member(name: "John"), Member(name: "Jane")]
        : trip.members
        
        let items: [ItineraryItem] = [
            ItineraryItem(
                date: day1,
                title: "Check-in / Hotel",
                timeText: "1:00 PM",
                members: members,
                notes: "Confirm booking and drop off bags"
            ),
            ItineraryItem(
                date: day1,
                title: "Dinner Reservations",
                timeText: "6:30 PM",
                members: members,
                notes: "Meet up in hotel lobby by 5:45 PM"
            ),
            ItineraryItem(
                date: days[1],
                title: "Activity 1",
                timeText: "2:00 PM",
                members: members,
                notes: "Don't forget tickets and bring a change of clothes"
            )
        ]
        return items
    }
    
    private var tripDays: [Date] {
        TripDateHelper.daysInclusive(from: trip.startDate, to: trip.endDate)
    }
        
    private func items(for day: Date) -> [ItineraryItem] {
        let key = Calendar.current.startOfDay(for: day)
        return sampleItems.filter { Calendar.current.isDate($0.date, inSameDayAs: key)}
    }

    var body: some View {
        List {
            ForEach(tripDays, id: \.self) { day in
                Section {
                    let dayItems = items(for: day)
                    if dayItems.isEmpty {
                        Text("No items planned for this day.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(dayItems) { item in
                            Text(item.title)
                        }
                    }
                } header: {
                    Button {
                        selectedDay = day
                        showingDaySheet = true
                    } label: {
                        HStack {
                            Text(day, format: .dateTime.weekday(.wide).month().day())
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Itinerary")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingDaySheet) {
            DayItineraryView (
                trip: trip,
                day: selectedDay,
                dayItems: items(for: selectedDay)
            )
        }
    }
}
