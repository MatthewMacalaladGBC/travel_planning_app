//
//  TripIdentityPickerView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-04-10.
//

import SwiftUI

struct TripIdentityPickerView: View {
    @Environment(\.dismiss) private var dismiss
    let trip: Trip
    // Called when the user confirms a selection (member name or a non-member / outsider)
    let onSelect: (String) -> Void

    @State private var selected: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(trip.members) { member in
                        Button {
                            selected = member.name
                        } label: {
                            HStack {
                                Text(member.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selected == member.name {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                } header: {
                    Text("I am a trip member")
                }

                Section {
                    Button {
                        selected = TripIdentity.outsider
                    } label: {
                        HStack {
                            Text("Just viewing (not a member)")
                                .foregroundColor(.primary)
                            Spacer()
                            if selected == TripIdentity.outsider {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                } header: {
                    Text("Or")
                }
            }
            .navigationTitle("Who are you?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Confirm") {
                        onSelect(selected)
                        dismiss()
                    }
                    .disabled(selected.isEmpty)
                }
            }
        }
    }
}
