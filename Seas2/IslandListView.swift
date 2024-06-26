//
//  IslandListView.swift
//  Seas2
//
//  Created by Brian Romero on 6/25/24.
//

import Foundation
import SwiftUI

struct IslandListView: View {
    var islands: [PirateIsland]

    var body: some View {
        List(islands) { island in
            VStack(alignment: .leading) {
                Text(island.islandName ?? "Unknown Island")
                    .font(.headline)
                Text(island.islandLocation ?? "Unknown Location")
                    .font(.subheadline)
            }
        }
        .navigationTitle("Islands Near You")
    }
}

struct IslandListView_Previews: PreviewProvider {
    static var previews: some View {
        let previewIsland = PirateIsland(context: PersistenceController.preview.container.viewContext)
        previewIsland.islandName = "Sample Island"
        previewIsland.islandLocation = "Sample Location"
        
        return IslandListView(islands: [previewIsland])
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
