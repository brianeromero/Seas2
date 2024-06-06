//
//  IslandDetailView.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
//
//  IslandDetailView.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//

import SwiftUI
import CoreData

struct IslandDetailView: View {
    var island: PirateIsland

    var body: some View {
        IslandDetailContent(island: island)
    }
}

struct IslandDetailContent: View {
    let island: PirateIsland
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Gym: \(island.islandName ?? "Unknown")")
            Text("Location: \(island.islandLocation ?? "Unknown")")
            Text("Entered By: \(island.enteredBy ?? "Unknown")")
            
            if let creationDate = island.creationDate {
                Text("Added Date: \(formattedDate(creationDate) ?? "Unknown")")
            } else {
                Text("Added Date: Unknown")
            }
            
            Text("Timestamp: \(formattedDate(island.timestamp) ?? "Unknown")")
            
            NavigationLink(destination: IslandMapView(islands: [island])) {
                Text("Show on Map")
                    .foregroundColor(.blue)
                    .underline()
            }
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
}
