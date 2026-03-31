//
//  EditItineraryView.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-31.
//

import SwiftUI

struct EditItineraryItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var item: ItineraryItem

    @State private var title: String
    @State private var selectedDate: Date
    @State private var timeText: String
    @State private var notes: String

    init(item: Binding<ItineraryItem>) {
        self._item = item
        self._title = State(initialValue: item.wrappedValue.title)
        self._selectedDate = State(initialValue: item.wrappedValue.date)
        self._timeText = State(initialValue: item.wrappedValue.timeText)
        self._notes = State(initialValue: item.wrappedValue.notes)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Edit Activity") {
                    TextField("Title", text: $title)

                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)

                    TextField("Time", text: $timeText)

                    TextField("Notes", text: $notes)
                }
            }
            .navigationTitle("Edit Activity")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
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

    private func saveChanges() {
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedTitle.isEmpty else { return }

        item.title = cleanedTitle
        item.date = selectedDate
        item.timeText = timeText.isEmpty ? "Time not set" : timeText
        item.notes = notes

        dismiss()
    }
}
