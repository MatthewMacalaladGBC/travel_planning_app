//
//  AddItineraryItemView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import SwiftUI

struct AddItineraryItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var trip: Trip

    @State private var title: String
    @State private var selectedDate: Date
    @State private var notes: String
    @State private var location: String
    @State private var cost: String

    init(trip: Binding<Trip>) {
        self._trip = trip
        self._title = State(initialValue: "")
        self._selectedDate = State(initialValue: trip.wrappedValue.startDate)
        self._notes = State(initialValue: "")
        self._location = State(initialValue: "")
        self._cost = State(initialValue: "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Activity Info") {
                    TextField("Title", text: $title)

                    DatePicker(
                        "Date & Time",
                        selection: $selectedDate,
                        in: trip.startDate...trip.endDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }

                Section("Optional Details") {
                    TextField("Location", text: $location)

                    TextField("Cost", text: $cost)
                        .keyboardType(.decimalPad)
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Activity")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveActivity()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func saveActivity() {
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedTitle.isEmpty else { return }

        let cleanedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
        let newItem = ItineraryItem(
            date: selectedDate,
            title: cleanedTitle,
            members: trip.members,
            notes: notes,
            location: cleanedLocation.isEmpty ? nil : cleanedLocation,
            cost: Double(cost)
        )

        trip.itineraryItems.append(newItem)
        dismiss()
    }
}
