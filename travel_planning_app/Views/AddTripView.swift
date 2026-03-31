//
//  AddTripView.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-13.
//

import SwiftUI

struct AddTripView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var trips: [Trip]

    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var budget = ""

    @State private var memberName = ""
    @State private var members: [Member] = []

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
            }
            .navigationTitle("Add a Trip")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTrip()
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

    private func saveTrip() {
        let cleanedDestination = destination.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedDestination.isEmpty else { return }
        guard let budgetValue = Double(budget) else { return }

        let tripStatus = Trip.calculateStatus(startDate: startDate, endDate: endDate)

        let newTrip = Trip(
            destination: cleanedDestination,
            startDate: startDate,
            endDate: endDate,
            members: members,
            budget: budgetValue,
            status: tripStatus,
            itineraryItems: [],
            expenses: []
        )

        trips.append(newTrip)
        dismiss()
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView(trips: .constant([]))
    }
}
