//
//  travel_planning_appApp.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-02-07.
//

import SwiftUI

@main
struct travel_planning_appApp: App {
    @StateObject private var tripStore: TripStore

    init() {
        let context = PersistenceController.shared.container.viewContext
        _tripStore = StateObject(wrappedValue: TripStore(context: context))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LaunchView()
            }
            .environmentObject(tripStore)
        }
    }
}
