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
}

enum Destination: String, CaseIterable, Identifiable, Hashable {
    case pirateIsland = "Pirate Island"
    case maryRead = "Mary Read"
    case chingShih = "Ching Shih"
    case forbiddenLagoon = "Forbidden Lagoon"
    case other = "UNCHARTED SEAS"

    var id: String { self.rawValue }
}
