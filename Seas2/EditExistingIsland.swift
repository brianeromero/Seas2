//
//  EditExistingIsland.swift
//  Seas2
//
//  Created by Brian Romero on 6/7/24.
//
import SwiftUI
import CoreData

struct EditExistingIsland: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var island: PirateIsland
    
    var body: some View {
        AddIslandFormView(
            islandName: Binding<String>(
                get: { island.islandName ?? "" },
                set: { island.islandName = $0 }
            ),
            islandLocation: Binding<String>(
                get: { island.islandLocation ?? "" },
                set: { island.islandLocation = $0 }
            ),
            enteredBy: Binding<String>(
                get: { island.enteredBy ?? "" },
                set: { island.enteredBy = $0 }
            ),
            gymWebsite: Binding<String>(
                get: { island.gymWebsite?.absoluteString ?? "" },
                set: { newValue in
                    if let url = URL(string: newValue) {
                        island.gymWebsite = url
                    }
                }
            ),
            gymWebsiteURL: Binding<URL?>(
                get: { island.gymWebsite },
                set: { newValue in
                    island.gymWebsite = newValue
                }
            )
        )
    }
}

// EditExistingIsland_Previews definition
struct EditExistingIsland_Previews: PreviewProvider {
    static var previews: some View {
        // Fetch your island data
        let context = PersistenceController.preview.container.viewContext
        
        // Fetch islands from CoreData
        if let fetchedIslands = try? context.fetch(PirateIsland.fetchRequest()) {
            if let island = fetchedIslands.first as? PirateIsland {
                // Use the fetched island
                return AnyView(
                    NavigationView {
                        EditExistingIsland(island: island)
                            .environment(\.managedObjectContext, context)
                    }
                )
            }
        }
        
        // Display a message if no islands are available
        return AnyView(
            Text("No island data available")
        )
    }
}
