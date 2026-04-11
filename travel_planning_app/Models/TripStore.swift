//
//  TripStore.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-04-10.
//

import Foundation
import CoreData

// TripStore is the main source for all trip data.
class TripStore: ObservableObject {
    @Published var trips: [Trip] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        load()
    }

    // Persist the current trips array to Core Data.
    func save() {
        let fetchRequest: NSFetchRequest<TripsData> = TripsData.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            let record = results.first ?? TripsData(context: context)
            record.tripsJSON = try JSONEncoder().encode(trips)
            try context.save()
        } catch {
            print("TripStore save error: \(error)")
        }
    }

    // Load the trips array from Core Data on launch.
    private func load() {
        let fetchRequest: NSFetchRequest<TripsData> = TripsData.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            if let data = results.first?.tripsJSON {
                trips = try JSONDecoder().decode([Trip].self, from: data)
            }
        } catch {
            print("TripStore load error: \(error)")
        }
    }
}
