//
//  Persistence.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
import SwiftUI
import CoreData
import Combine
import CoreLocation
import Foundation

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
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
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Seas2")
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
    }
}
