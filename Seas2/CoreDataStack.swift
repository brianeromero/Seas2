//
//  CoreDataStack.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//

import Foundation
import SwiftUI
import CoreData
import Combine

extension NSManagedObjectContext {
    static var preview: NSManagedObjectContext {
        let container = NSPersistentContainer(name: "Seas2")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // Use in-memory store for previews
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load preview store: \(error)")
            }
        }
        
        return container.viewContext
    }
}

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()

    @Published var lastPirateIsland: PirateIsland?

    private init() { }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Seas2")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Failed to save context: \(nsError), \(nsError.userInfo)")
        }
    }


    // Fetching PirateIsland
    func fetchPirateIslands() -> [PirateIsland]? {
        let fetchRequest: NSFetchRequest<PirateIsland> = PirateIsland.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching pirate islands: \(error.localizedDescription)")
            return nil
        }
    }

    func fetchLastPirateIsland() -> PirateIsland? {
        let fetchRequest: NSFetchRequest<PirateIsland> = PirateIsland.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PirateIsland.creationDate, ascending: false)]
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching last pirate island: \(error.localizedDescription)")
            return nil
        }
    }

    // Handling Destination Selection
    func handleDestinationSelection(_ destinationSelection: Destination?) {
        guard let destination = destinationSelection else {
            print("Default case")
            return
        }

        switch destination {
        case .pirateIsland:
            print("Pirate Island")
        case .maryRead:
            print("Mary Read")
        case .chingShih:
            print("Ching Shih")
        case .forbiddenLagoon:
            print("Forbidden Lagoon")
        case .other:
            print("UNCHARTED SEAS")
        }
    }

    // Fetching AppDayOfWeek
    func fetchAppDayOfWeeks() -> [AppDayOfWeek]? {
        // Create fetch request for AppDayOfWeek entities
        let fetchRequest: NSFetchRequest<AppDayOfWeek> = AppDayOfWeek.fetchRequest()
        
        do {
            // Attempt to fetch AppDayOfWeek objects from Core Data context
            return try context.fetch(fetchRequest)
        } catch {
            // Print error message if fetch request fails
            print("Error fetching AppDayOfWeek: \(error.localizedDescription)")
            return nil
        }
    }


    // Fetching Specific AppDayOfWeek by ID
    func fetchAppDayOfWeek(byID id: NSManagedObjectID) -> AppDayOfWeek? {
        do {
            guard let object = try context.existingObject(with: id) as? AppDayOfWeek else {
                print("Object with ID \(id) does not exist or cannot be cast to AppDayOfWeek")
                return nil
            }
            return object
        } catch {
            print("Error fetching AppDayOfWeek by ID: \(error.localizedDescription)")
            return nil
        }
    }


    // Create a new AppDayOfWeek
    func createAppDayOfWeek(sunday: Bool, monday: Bool, tuesday: Bool, wednesday: Bool, thursday: Bool, friday: Bool, saturday: Bool, matTime: String?, restrictions: Bool, restrictionDescription: String?, op_sunday: Bool, op_monday: Bool, op_tuesday: Bool, op_wednesday: Bool, op_thursday: Bool, op_friday: Bool, op_saturday: Bool, gi: Bool, noGi: Bool) -> AppDayOfWeek {
        let newAppDayOfWeek = AppDayOfWeek(context: context)
        newAppDayOfWeek.sunday = sunday
        newAppDayOfWeek.monday = monday
        newAppDayOfWeek.tuesday = tuesday
        newAppDayOfWeek.wednesday = wednesday
        newAppDayOfWeek.thursday = thursday
        newAppDayOfWeek.friday = friday
        newAppDayOfWeek.saturday = saturday
        newAppDayOfWeek.matTime = matTime
        newAppDayOfWeek.restrictions = restrictions
        newAppDayOfWeek.restrictionDescription = restrictionDescription
        newAppDayOfWeek.op_sunday = op_sunday
        newAppDayOfWeek.op_monday = op_monday
        newAppDayOfWeek.op_tuesday = op_tuesday
        newAppDayOfWeek.op_wednesday = op_wednesday
        newAppDayOfWeek.op_thursday = op_thursday
        newAppDayOfWeek.op_friday = op_friday
        newAppDayOfWeek.op_saturday = op_saturday
        newAppDayOfWeek.gi = gi
        newAppDayOfWeek.noGi = noGi
        newAppDayOfWeek.goodForBeginners = noGi
        newAppDayOfWeek.openMat = noGi

        saveContext()
        return newAppDayOfWeek
    }

    // Update an existing AppDayOfWeek
    func updateAppDayOfWeek(appDayOfWeek: AppDayOfWeek, sunday: Bool, monday: Bool, tuesday: Bool, wednesday: Bool, thursday: Bool, friday: Bool, saturday: Bool, matTime: String?, restrictions: Bool, restrictionDescription: String?, op_sunday: Bool, op_monday: Bool, op_tuesday: Bool, op_wednesday: Bool, op_thursday: Bool, op_friday: Bool, op_saturday: Bool, gi: Bool, noGi: Bool) {
        appDayOfWeek.sunday = sunday
        appDayOfWeek.monday = monday
        appDayOfWeek.tuesday = tuesday
        appDayOfWeek.wednesday = wednesday
        appDayOfWeek.thursday = thursday
        appDayOfWeek.friday = friday
        appDayOfWeek.saturday = saturday
        appDayOfWeek.matTime = matTime
        appDayOfWeek.restrictions = restrictions
        appDayOfWeek.restrictionDescription = restrictionDescription
        appDayOfWeek.op_sunday = op_sunday
        appDayOfWeek.op_monday = op_monday
        appDayOfWeek.op_tuesday = op_tuesday
        appDayOfWeek.op_wednesday = op_wednesday
        appDayOfWeek.op_thursday = op_thursday
        appDayOfWeek.op_friday = op_friday
        appDayOfWeek.op_saturday = op_saturday
        appDayOfWeek.gi = gi
        appDayOfWeek.noGi = noGi
        appDayOfWeek.openMat = noGi
        appDayOfWeek.goodForBeginners = noGi

        saveContext()
    }

    // Delete an AppDayOfWeek
    func deleteAppDayOfWeek(appDayOfWeek: AppDayOfWeek) {
        context.delete(appDayOfWeek)
        saveContext()
    }
}

enum Destination: String, CaseIterable, Identifiable, Hashable {
    case pirateIsland = "Pirate Island"
    case maryRead = "Mary Read"
    case chingShih = "Ching Shih"
    case forbiddenLagoon = "Forbidden Lagoon"
    case other = "UNCHARTED SEAS"

    var id: String { self.rawValue }
}
