//
//  IslandDetailView.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
import SwiftUI
import CoreData
import Combine
import CoreLocation
import Foundation


// Define IslandDestination enum
enum IslandDestination: String, CaseIterable {
    case firstDestination = "Schedule"
    case secondDestination = "Website"
}

// IslandDetailView definition
struct IslandDetailView: View {
    var island: PirateIsland
    @StateObject var coreDataStack = CoreDataStack.shared
    @Binding var selectedDestination: IslandDestination?
    @State private var showMapView = false

    var body: some View {
        IslandDetailContent(island: island, selectedDestination: $selectedDestination)
    }
}

// IslandDetailContent definition
// IslandDetailContent definition
struct IslandDetailContent: View {
    let island: PirateIsland
    @StateObject var coreDataStack = CoreDataStack.shared
    @Binding var selectedDestination: IslandDestination?
    @State private var showMapView = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(island.islandName ?? "Unknown")")
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 10)

            if let location = island.islandLocation {
                Button(action: {
                    showMapView = true
                }) {
                    Text(location)
                        .foregroundColor(.blue)
                        .font(.system(size: 16, weight: .light))
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 10)
                }
                .sheet(isPresented: $showMapView) {
                    IslandMapView(islands: [island])
                }
            } else {
                Text("Location: Unknown")
                    .font(.system(size: 16, weight: .light))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 10)
            }

            Text("Entered By: \(island.enteredBy ?? "Unknown")")
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Added Date: \(formattedDate(island.creationDate) ?? "Unknown")")
                .frame(maxWidth: .infinity, alignment: .leading)

            // Navigation Links
            ForEach(IslandDestination.allCases, id: \.self) { destination in
                if destination == .secondDestination {
                    Button(action: {
                        if let url = island.gymWebsite {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Go to \(destination.rawValue)")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.blue)
                    }
                } else if destination == .firstDestination {
                    // Navigate to AdditionalGymInfo when "Go to Schedule" is tapped
                    NavigationLink(destination: AdditionalGymInfo(islandName: island.islandName ?? "")) {
                        Text("Go to \(destination.rawValue)")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Island Detail")
    }


    private func formattedDate(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }

    private func destinationView(for destination: IslandDestination) -> some View {
        switch destination {
        case .firstDestination:
            return AnyView(Text("Destination View for \(destination.rawValue)"))
                .font(.system(size: 16, weight: .light))

        case .secondDestination:
            return AnyView(EmptyView())
                .font(.system(size: 16, weight: .light))
        }
    }
}

// IslandDetailView_Previews definition
struct IslandDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Fetch your island data
        let context = PersistenceController.preview.container.viewContext
        
        // Fetch islands from CoreData
        if let fetchedIslands = try? context.fetch(PirateIsland.fetchRequest()) {
            if let island = fetchedIslands.first {
                // Use the fetched island
                return AnyView(
                    NavigationView {
                        IslandDetailView(island: island, selectedDestination: Binding<IslandDestination?>.constant(nil)) // Provide a default value for selectedDestination
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
