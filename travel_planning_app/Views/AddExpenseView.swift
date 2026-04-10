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
    @State private var category: ExpenseCategory = .other
    @State private var date = Date()
    @State private var isEqualSplit = true
    @State private var customAmounts: [String: String] = [:]

    private var isSaveDisabled: Bool {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanTitle.isEmpty, let totalAmount = Double(amount), totalAmount > 0, !paidBy.isEmpty else {
            return true
        }
        if isEqualSplit {
            return sharedWith.isEmpty
        } else {
            let validEntries = trip.members.filter { (Double(customAmounts[$0.name] ?? "") ?? 0) > 0 }
            guard !validEntries.isEmpty else { return true }
            let sum = validEntries.reduce(0.0) { $0 + (Double(customAmounts[$1.name] ?? "") ?? 0) }
            return abs(sum - totalAmount) > 0.01
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense Details") {
                    TextField("Expense title", text: $title)

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)

                    Picker("Category", selection: $category) {
                        ForEach(ExpenseCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }

                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section("Who Paid?") {
                    Picker("Paid By", selection: $paidBy) {
                        ForEach(trip.members) { member in
                            Text(member.name).tag(member.name)
                        }
                    }
                }

                Section {
                    Toggle("Equal Split", isOn: $isEqualSplit)
                } header: {
                    Text("Split")
                } footer: {
                    if !isEqualSplit, let totalAmount = Double(amount), totalAmount > 0 {
                        let sum = trip.members.reduce(0.0) { $0 + (Double(customAmounts[$1.name] ?? "") ?? 0) }
                        let diff = abs(sum - totalAmount)
                        if diff > 0.01 {
                            Text("Custom amounts must sum to \(String(format: "$%.2f", totalAmount)) (currently \(String(format: "$%.2f", sum)))")
                                .foregroundColor(.red)
                        }
                    }
                }

                if isEqualSplit {
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
                } else {
                    Section("Custom Amounts Per Person") {
                        ForEach(trip.members) { member in
                            HStack {
                                Text(member.name)
                                Spacer()
                                TextField("0.00", text: Binding(
                                    get: { customAmounts[member.name] ?? "" },
                                    set: { customAmounts[member.name] = $0 }
                                ))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
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
                    .disabled(isSaveDisabled)
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
        guard !cleanedTitle.isEmpty, let amountValue = Double(amount), !paidBy.isEmpty else { return }

        let newExpense: Expense
        if isEqualSplit {
            guard !sharedWith.isEmpty else { return }
            newExpense = Expense(
                title: cleanedTitle,
                amount: amountValue,
                paidBy: paidBy,
                sharedWith: Array(sharedWith),
                category: category,
                date: date,
                splitAmounts: nil
            )
        } else {
            let splits = trip.members.reduce(into: [String: Double]()) { dict, member in
                if let val = Double(customAmounts[member.name] ?? ""), val > 0 {
                    dict[member.name] = val
                }
            }
            guard !splits.isEmpty else { return }
            newExpense = Expense(
                title: cleanedTitle,
                amount: amountValue,
                paidBy: paidBy,
                sharedWith: Array(splits.keys),
                category: category,
                date: date,
                splitAmounts: splits
            )
        }

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
