//
//  PersistenceController.swift
//  travel_planning_app
//
//  Created by Matthew Macalalad on 2026-04-10.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // In-memory store used for SwiftUI Previews
    static let preview = PersistenceController(inMemory: true)

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TravelPlanner")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load store: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
