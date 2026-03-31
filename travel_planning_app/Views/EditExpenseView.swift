//
//  EditExpenseView.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-31.
//

import SwiftUI

struct EditExpenseView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var expense: Expense
    let members: [Member]

    @State private var title: String
    @State private var amount: String
    @State private var paidBy: String
    @State private var sharedWith: Set<String>

    init(expense: Binding<Expense>, members: [Member]) {
        self._expense = expense
        self.members = members
        self._title = State(initialValue: expense.wrappedValue.title)
        self._amount = State(initialValue: String(expense.wrappedValue.amount))
        self._paidBy = State(initialValue: expense.wrappedValue.paidBy)
        self._sharedWith = State(initialValue: Set(expense.wrappedValue.sharedWith))
    }

    var body: some View {
        Form {
            Section("Edit Expense") {
                TextField("Expense title", text: $title)

                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }

            Section("Who Paid?") {
                Picker("Paid By", selection: $paidBy) {
                    ForEach(members) { member in
                        Text(member.name).tag(member.name)
                    }
                }
            }

            Section("Split With") {
                ForEach(members) { member in
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
        .navigationTitle("Edit Expense")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveChanges()
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
    }

    private func saveChanges() {
        let cleanedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedTitle.isEmpty else { return }
        guard let amountValue = Double(amount) else { return }
        guard !paidBy.isEmpty else { return }
        guard !sharedWith.isEmpty else { return }

        expense.title = cleanedTitle
        expense.amount = amountValue
        expense.paidBy = paidBy
        expense.sharedWith = Array(sharedWith)

        dismiss()
    }
}
