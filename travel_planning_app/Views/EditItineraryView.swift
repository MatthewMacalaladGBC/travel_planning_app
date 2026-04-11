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
    @State private var notes: String
    @State private var location: String
    @State private var cost: String

    init(item: Binding<ItineraryItem>) {
        self._item = item
        let i = item.wrappedValue
        self._title = State(initialValue: i.title)
        self._selectedDate = State(initialValue: i.date)
        self._notes = State(initialValue: i.notes)
        self._location = State(initialValue: i.location ?? "")
        self._cost = State(initialValue: i.cost.map { String($0) } ?? "")
    }

    var body: some View {
        Form {
            Section("Edit Activity") {
                TextField("Title", text: $title)

                DatePicker("Date & Time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
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

    private func saveChanges() {
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedTitle.isEmpty else { return }

        let cleanedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
        item.title = cleanedTitle
        item.date = selectedDate
        item.notes = notes
        item.location = cleanedLocation.isEmpty ? nil : cleanedLocation
        item.cost = Double(cost)

        dismiss()
    }
}
