//
//  BudgetView.swift
//  travel_planning_app
//
//  Created by Sara Yohannes on 2026-03-31.
//

import SwiftUI

struct BudgetView: View {
    @Binding var trip: Trip
    @State private var showingAddExpense = false

    var totalSpent: Double {
        trip.expenses.reduce(0) { $0 + $1.amount }
    }

    var remainingBalance: Double {
        trip.budget - totalSpent
    }

    var settlementLines: [String] {
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
            Text("Total Budget: \(formattedAmount(trip.budget))")
            Text("Total Spent: \(formattedAmount(totalSpent))")
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
                                Text(trip.expenses[index].title)
                                    .font(.headline)

                                Text("Paid by: \(trip.expenses[index].paidBy)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text("Split with: \(trip.expenses[index].sharedWith.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text(formattedAmount(trip.expenses[index].amount))
                                    .font(.subheadline)
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
            Text("Remaining: \(formattedAmount(remainingBalance))")
        }
    }

    private var settleUpSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Settle Up")

            if settlementLines.isEmpty {
                Text("No balances to settle")
                    .foregroundColor(.gray)
            } else {
                ForEach(settlementLines, id: \.self) { line in
                    Text(line)
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

    private func calculateSettlements() -> [String] {
        var balances: [String: Double] = [:]

        for member in trip.members {
            balances[member.name] = 0
        }

        for expense in trip.expenses {
            guard !expense.sharedWith.isEmpty else { continue }

            let splitAmount = expense.amount / Double(expense.sharedWith.count)
            balances[expense.paidBy, default: 0] += expense.amount

            for person in expense.sharedWith {
                balances[person, default: 0] -= splitAmount
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

        var results: [String] = []
        var debtorIndex = 0
        var creditorIndex = 0

        while debtorIndex < debtors.count && creditorIndex < creditors.count {
            let amountToPay = min(debtors[debtorIndex].amount, creditors[creditorIndex].amount)

            results.append(
                "\(debtors[debtorIndex].name) owes \(creditors[creditorIndex].name) \(formattedAmount(amountToPay))"
            )

            debtors[debtorIndex].amount -= amountToPay
            creditors[creditorIndex].amount -= amountToPay

            if debtors[debtorIndex].amount < 0.01 {
                debtorIndex += 1
            }

            if creditors[creditorIndex].amount < 0.01 {
                creditorIndex += 1
            }
        }

        return results
    }
}
