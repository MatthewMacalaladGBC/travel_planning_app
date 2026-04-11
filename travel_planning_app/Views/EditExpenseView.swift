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
    @State private var category: ExpenseCategory
    @State private var date: Date
    @State private var isEqualSplit: Bool
    @State private var customAmounts: [String: String]

    init(expense: Binding<Expense>, members: [Member]) {
        self._expense = expense
        self.members = members
        let e = expense.wrappedValue
        self._title = State(initialValue: e.title)
        self._amount = State(initialValue: String(e.amount))
        self._paidBy = State(initialValue: e.paidBy)
        self._sharedWith = State(initialValue: Set(e.sharedWith))
        self._category = State(initialValue: e.category)
        self._date = State(initialValue: e.date)
        self._isEqualSplit = State(initialValue: e.splitAmounts == nil)
        if let splits = e.splitAmounts {
            self._customAmounts = State(initialValue: splits.mapValues { String($0) })
        } else {
            self._customAmounts = State(initialValue: [:])
        }
    }

    private var isSaveDisabled: Bool {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanTitle.isEmpty, let totalAmount = Double(amount), totalAmount > 0, !paidBy.isEmpty else {
            return true
        }
        if isEqualSplit {
            return sharedWith.isEmpty
        } else {
            let validEntries = members.filter { (Double(customAmounts[$0.name] ?? "") ?? 0) > 0 }
            guard !validEntries.isEmpty else { return true }
            let sum = validEntries.reduce(0.0) { $0 + (Double(customAmounts[$1.name] ?? "") ?? 0) }
            return abs(sum - totalAmount) > 0.01
        }
    }

    var body: some View {
        Form {
            Section("Edit Expense") {
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
                    ForEach(members) { member in
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
                    let sum = members.reduce(0.0) { $0 + (Double(customAmounts[$1.name] ?? "") ?? 0) }
                    let diff = abs(sum - totalAmount)
                    if diff > 0.01 {
                        Text("Custom amounts must sum to \(String(format: "$%.2f", totalAmount)) (currently \(String(format: "$%.2f", sum)))")
                            .foregroundColor(.red)
                    }
                }
            }

            if isEqualSplit {
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
            } else {
                Section("Custom Amounts Per Person") {
                    ForEach(members) { member in
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
        .navigationTitle("Edit Expense")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveChanges()
                }
                .disabled(isSaveDisabled)
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
        guard !cleanedTitle.isEmpty, let amountValue = Double(amount), !paidBy.isEmpty else { return }

        expense.title = cleanedTitle
        expense.amount = amountValue
        expense.paidBy = paidBy
        expense.category = category
        expense.date = date

        if isEqualSplit {
            guard !sharedWith.isEmpty else { return }
            expense.sharedWith = Array(sharedWith)
            expense.splitAmounts = nil
        } else {
            let splits = members.reduce(into: [String: Double]()) { dict, member in
                if let val = Double(customAmounts[member.name] ?? ""), val > 0 {
                    dict[member.name] = val
                }
            }
            guard !splits.isEmpty else { return }
            expense.sharedWith = Array(splits.keys)
            expense.splitAmounts = splits
        }

        dismiss()
    }
}
