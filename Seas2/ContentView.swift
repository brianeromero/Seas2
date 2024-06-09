//
//  ContentView.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
import Foundation
import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PirateIsland.timestamp, ascending: true)],
        animation: .default)
    private var pirateIslands: FetchedResults<PirateIsland>
    
    @State private var showAddIslandForm = false
    @State private var islandName = ""
    @State private var islandLocation = ""
    @State private var enteredBy = ""
    @State private var gymWebsite = "" // Change to String
    @State private var gymWebsiteURL: URL? // New state variable for URL

    var body: some View {
        NavigationView {
            List {
                ForEach(pirateIslands) { island in
                    NavigationLink(destination: IslandDetailView(island: island, selectedDestination: .constant(nil))) { // Provide a default value for selectedDestination
                        islandRowView(island: island)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AllIslandMapView()) {
                        Label("All Islands", systemImage: "map")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: {
                        showAddIslandForm = true
                    }) {
                        Label("Add Island", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddIslandForm) {
                AddIslandFormView(
                    islandName: $islandName,
                    islandLocation: $islandLocation,
                    enteredBy: $enteredBy,
                    gymWebsite: $gymWebsite,
                    gymWebsiteURL: $gymWebsiteURL // Pass URL binding
                )
            }

            .navigationTitle("Islands")
        }
    }

    private func islandRowView(island: PirateIsland) -> some View {
        VStack(alignment: .leading) {
            Text("Gym: \(island.islandName ?? "Unknown")")
            if let creationDate = island.creationDate {
                Text("Added: \(creationDate, formatter: dateFormatter)")
            } else {
                Text("Unknown Added Date")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { pirateIslands[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("Error deleting island: \(error.localizedDescription)")
            }
        }
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
#endif
