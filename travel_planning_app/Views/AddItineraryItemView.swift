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

    @State private var title = ""
    @State private var selectedDate = Date()
    @State private var timeText = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Activity Info") {
                    TextField("Title", text: $title)

                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)

                    TextField("Time", text: $timeText)
                    TextField("Notes", text: $notes)
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

        let newItem = ItineraryItem(
            date: selectedDate,
            title: cleanedTitle,
            timeText: timeText.isEmpty ? "Time not set" : timeText,
            members: trip.members,
            notes: notes
        )

        trip.itineraryItems.append(newItem)
        dismiss()
    }
}
