//  Persistence.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//

import SwiftUI
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "Seas2") // Match with `Seas2.xcdatamodeld`
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Error loading persistent store: \(error.localizedDescription)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        print("Initialized PersistenceController")
    }

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        for _ in 0..<10 {
            let newIsland = PirateIsland(context: viewContext)
            newIsland.timestamp = Date()
            newIsland.islandName = "Sample Island"
            newIsland.islandLocation = "Sample Location"
            newIsland.enteredBy = "Sample Pirate"
            newIsland.creationDate = Date()
            newIsland.latitude = 0.0
            newIsland.longitude = 0.0

            // Add sample AppDayOfWeek data
            let newDayOfWeek = AppDayOfWeek(context: viewContext)
            newDayOfWeek.sunday = true
            newDayOfWeek.monday = false
            newDayOfWeek.tuesday = true
            newDayOfWeek.wednesday = false
            newDayOfWeek.thursday = true
            newDayOfWeek.friday = false
            newDayOfWeek.saturday = true
            newDayOfWeek.matTime = "2 hours"
            newDayOfWeek.restrictions = true
            newDayOfWeek.restrictionDescription = "No restrictions"
            newDayOfWeek.op_sunday = true
            newDayOfWeek.op_monday = false
            newDayOfWeek.op_tuesday = true
            newDayOfWeek.op_wednesday = false
            newDayOfWeek.op_thursday = true
            newDayOfWeek.op_friday = false
            newDayOfWeek.op_saturday = true
            newDayOfWeek.gi = true
            newDayOfWeek.noGi = false
            newDayOfWeek.goodForBeginners = true
            newDayOfWeek.openMat = false
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error saving preview context: \(nsError.localizedDescription)")
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        print("Initialized preview PersistenceController")
        return controller
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Seas2") // Match with `Seas2.xcdatamodeld`
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Error loading persistent store: \(error.localizedDescription)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        if inMemory {
            print("Initialized in-memory PersistenceController")
        } else {
            print("Initialized PersistenceController")
        }
    }
}
