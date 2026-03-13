//
//  EditTripView.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-13.
//

import SwiftUI

struct EditTripView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var trip: Trip
    let onDelete: () -> Void

    @State private var destination: String
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var budget: String
    @State private var memberName = ""
    @State private var members: [Member]

    init(trip: Binding<Trip>, onDelete: @escaping () -> Void) {
        self._trip = trip
        self.onDelete = onDelete
        self._destination = State(initialValue: trip.wrappedValue.destination)
        self._startDate = State(initialValue: trip.wrappedValue.startDate)
        self._endDate = State(initialValue: trip.wrappedValue.endDate)
        self._budget = State(initialValue: String(trip.wrappedValue.budget))
        self._members = State(initialValue: trip.wrappedValue.members)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Trip Info") {
                    TextField("Destination", text: $destination)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)

                    TextField("Expected Budget (per person)", text: $budget)
                        .keyboardType(.decimalPad)
                }

                Section("Members") {
                    HStack {
                        TextField("Member name", text: $memberName)
                        Button("Add") {
                            addMember()
                        }
                    }

                    if members.isEmpty {
                        Text("No members added yet")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(members) { member in
                            Text(member.name)
                        }
                        .onDelete(perform: deleteMember)
                    }
                }

                Section {
                    Button("Delete Trip", role: .destructive) {
                        onDelete()
                        dismiss()
                    }
                }
            }
            .navigationTitle("Edit Trip")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(destination.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || Double(budget) == nil)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func addMember() {
        let cleanedName = memberName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedName.isEmpty else { return }
        members.append(Member(name: cleanedName))
        memberName = ""
    }

    private func deleteMember(at offsets: IndexSet) {
        members.remove(atOffsets: offsets)
    }

    private func saveChanges() {
        let cleanedDestination = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedDestination.isEmpty else { return }
        guard let budgetValue = Double(budget) else { return }

        trip.destination = cleanedDestination
        trip.startDate = startDate
        trip.endDate = endDate
        trip.budget = budgetValue
        trip.members = members
        trip.status = Trip.calculateStatus(startDate: startDate, endDate: endDate)

        dismiss()
    }
}
