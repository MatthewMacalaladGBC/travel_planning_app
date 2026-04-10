//
//  BudgetView.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-31.
//

import SwiftUI

private struct SettlementItem {
    let debtor: String
    let creditor: String
    let amount: Double
    var key: String { "\(debtor)|\(creditor)" }
    var description: String { "\(debtor) owes \(creditor) \(String(format: "$%.2f", amount))" }
}

struct BudgetView: View {
    @Binding var trip: Trip
    @State private var showingAddExpense = false

    private var currentMemberName: String? {
        TripIdentity.memberName(for: trip.id)
    }

    var totalSpent: Double {
        trip.expenses.reduce(0) { $0 + $1.amount }
    }

    // The current user's personal share across all expenses.
    var mySpend: Double {
        guard let me = currentMemberName else { return 0 }
        return trip.expenses.reduce(0) { sum, expense in
            if let splits = expense.splitAmounts {
                return sum + (splits[me] ?? 0)
            } else if expense.sharedWith.contains(me) {
                return sum + expense.amount / Double(expense.sharedWith.count)
            }
            return sum
        }
    }

    var myRemaining: Double {
        trip.budget - mySpend
    }

    private var settlements: [SettlementItem] {
        calculateSettlements()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            budgetSummarySection
            expenseListSection
            balanceSection
            settleUpSection
            addExpenseButton
        }
        .padding()
        .navigationTitle("Budget / Expenses")
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(trip: $trip)
        }
    }

    private var budgetSummarySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Budget Summary")
            Text("Budget per person: \(formattedAmount(trip.budget))")

            if let me = currentMemberName {
                Text("Your spend (\(me)): \(formattedAmount(mySpend))")
                Text("Your remaining: \(formattedAmount(myRemaining))")
                    .foregroundColor(myRemaining >= 0 ? .primary : .red)
            }

            Text("Group total spent: \(formattedAmount(totalSpent))")
                .foregroundColor(.secondary)
        }
    }

    private var expenseListSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Expense List")

            if trip.expenses.isEmpty {
                Text("No expenses added yet")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(trip.expenses.indices, id: \.self) { index in
                        NavigationLink {
                            EditExpenseView(expense: $trip.expenses[index], members: trip.members)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(trip.expenses[index].title)
                                        .font(.headline)
                                    Spacer()
                                    Text(formattedAmount(trip.expenses[index].amount))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }

                                HStack(spacing: 6) {
                                    Label(trip.expenses[index].category.rawValue, systemImage: categoryIcon(for: trip.expenses[index].category))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("•")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(trip.expenses[index].date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Text("Paid by: \(trip.expenses[index].paidBy)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                if let splits = trip.expenses[index].splitAmounts {
                                    Text("Custom split: \(splits.map { "\($0.key) \(formattedAmount($0.value))" }.sorted().joined(separator: ", "))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("Split with: \(trip.expenses[index].sharedWith.sorted().joined(separator: ", "))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }
                .frame(height: 260)
            }
        }
    }

    private var balanceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Balance")
            if let me = currentMemberName {
                Text("\(me)'s remaining: \(formattedAmount(myRemaining))")
                    .foregroundColor(myRemaining >= 0 ? .primary : .red)
            } else {
                Text("Group total spent: \(formattedAmount(totalSpent))")
            }
        }
    }

    private var settleUpSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Settle Up")

            if settlements.isEmpty {
                Text("No balances to settle")
                    .foregroundColor(.gray)
            } else {
                ForEach(settlements, id: \.key) { settlement in
                    let isPaid = trip.paidSettlementKeys.contains(settlement.key)
                    HStack {
                        Text(settlement.description)
                            .strikethrough(isPaid)
                            .foregroundColor(isPaid ? .secondary : .primary)
                        Spacer()
                        Button(isPaid ? "Unpay" : "Mark Paid") {
                            if isPaid {
                                trip.paidSettlementKeys.remove(settlement.key)
                            } else {
                                trip.paidSettlementKeys.insert(settlement.key)
                            }
                        }
                        .buttonStyle(.bordered)
                        .font(.caption)
                        .tint(isPaid ? .secondary : .green)
                    }
                }
            }
        }
    }

    private var addExpenseButton: some View {
        Button("+ Add Expense") {
            showingAddExpense = true
        }
        .frame(maxWidth: .infinity)
        .buttonStyle(.borderedProminent)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.85))
            .foregroundColor(.white)
            .cornerRadius(20)
    }

    private func deleteExpense(at offsets: IndexSet) {
        trip.expenses.remove(atOffsets: offsets)
    }

    private func formattedAmount(_ value: Double) -> String {
        String(format: "$%.2f", value)
    }

    private func categoryIcon(for category: ExpenseCategory) -> String {
        switch category {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .accommodation: return "bed.double.fill"
        case .activities: return "figure.hiking"
        case .shopping: return "bag.fill"
        case .other: return "ellipsis.circle"
        }
    }

    private func calculateSettlements() -> [SettlementItem] {
        var balances: [String: Double] = [:]

        for member in trip.members {
            balances[member.name] = 0
        }

        for expense in trip.expenses {
            balances[expense.paidBy, default: 0] += expense.amount

            if let splits = expense.splitAmounts {
                for (person, owed) in splits {
                    balances[person, default: 0] -= owed
                }
            } else {
                guard !expense.sharedWith.isEmpty else { continue }
                let splitAmount = expense.amount / Double(expense.sharedWith.count)
                for person in expense.sharedWith {
                    balances[person, default: 0] -= splitAmount
                }
            }
        }

        var creditors: [(name: String, amount: Double)] = []
        var debtors: [(name: String, amount: Double)] = []

        for (name, balance) in balances {
            if balance > 0.01 {
                creditors.append((name: name, amount: balance))
            } else if balance < -0.01 {
                debtors.append((name: name, amount: -balance))
            }
        }

        var results: [SettlementItem] = []
        var debtorIndex = 0
        var creditorIndex = 0

        while debtorIndex < debtors.count && creditorIndex < creditors.count {
            let amountToPay = min(debtors[debtorIndex].amount, creditors[creditorIndex].amount)

            results.append(SettlementItem(
                debtor: debtors[debtorIndex].name,
                creditor: creditors[creditorIndex].name,
                amount: amountToPay
            ))

            debtors[debtorIndex].amount -= amountToPay
            creditors[creditorIndex].amount -= amountToPay

            if debtors[debtorIndex].amount < 0.01 { debtorIndex += 1 }
            if creditors[creditorIndex].amount < 0.01 { creditorIndex += 1 }
        }

        return results
    }
}
