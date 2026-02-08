//
//  AddTripView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-08.
//

import SwiftUI

struct AddTripView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var budget = ""
    
    var body: some View {
        NavigationStack {
            Form {
                
                
                TextField("Destination", text: $destination)
                
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                
                TextField("Expected Budget (per person)", text: $budget)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add a Trip")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Not integrated, just UI for now
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddTripView()
}
