//
//  AddExpenseView.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-31.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var trip: Trip

    @State private var title = ""
    @State private var amount = ""
    @State private var paidBy = ""
    @State private var sharedWith: Set<String> = []

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Details") {
                    TextField("Expense title", text: $title)

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }

                Section("Who Paid?") {
                    Picker("Paid By", selection: $paidBy) {
                        ForEach(trip.members) { member in
                            Text(member.name).tag(member.name)
                        }
                    }
                }

                Section("Split With") {
                    ForEach(trip.members) { member in
                        MultipleSelectionRow(
                            title: member.name,
                            isSelected: sharedWith.contains(member.name)
                        ) {
                            if sharedWith.contains(member.name) {
                                sharedWith.remove(member.name)
                            } else {
                                sharedWith.insert(member.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExpense()
                    }
                    .disabled(
                        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        Double(amount) == nil ||
                        paidBy.isEmpty ||
                        sharedWith.isEmpty
                    )
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if paidBy.isEmpty, let firstMember = trip.members.first {
                    paidBy = firstMember.name
                }
            }
        }
    }

    private func saveExpense() {
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedTitle.isEmpty else { return }
        guard let amountValue = Double(amount) else { return }
        guard !paidBy.isEmpty else { return }
        guard !sharedWith.isEmpty else { return }

        let newExpense = Expense(
            title: cleanedTitle,
            amount: amountValue,
            paidBy: paidBy,
            sharedWith: Array(sharedWith)
        )

        trip.expenses.append(newExpense)
        dismiss()
    }
}

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
