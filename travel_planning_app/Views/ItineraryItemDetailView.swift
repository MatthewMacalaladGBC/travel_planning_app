//
//  ItineraryItemDetailView.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-04-10.
//

import SwiftUI

struct ItineraryItemDetailView: View {
    @Binding var item: ItineraryItem

    var body: some View {
        Form {
            Section("Activity") {
                LabeledContent("Title", value: item.title)
                LabeledContent("Date", value: item.date.formatted(date: .long, time: .omitted))
                LabeledContent("Time", value: item.timeText)

                if let location = item.location, !location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    LabeledContent("Location", value: location)
                }

                if let cost = item.cost {
                    LabeledContent("Cost", value: String(format: "$%.2f", cost))
                }
            }

            if item.hasNotes {
                Section("Notes") {
                    Text(item.notes)
                }
            }

            Section("Members") {
                if item.members.isEmpty {
                    Text("None")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(item.members) { member in
                        Text(member.name)
                    }
                }
            }
        }
        .navigationTitle(item.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Edit") {
                    EditItineraryItemView(item: $item)
                }
            }
        }
    }
}
