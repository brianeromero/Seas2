//
//  AllIslandMapView.swift
//  Seas2
//
//  Created by Brian Romero on 6/6/24.
//

import Foundation
import SwiftUI
import CoreData

struct AllIslandMapView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: PirateIsland.entity(), sortDescriptors: [], animation: .default)
    private var pirateIslands: FetchedResults<PirateIsland>
    
    var body: some View {
        NavigationView {
            AllMapView(islands: Array(pirateIslands)) // Convert FetchedResults to Array
                .navigationTitle("Island Map")
        }
    }
}
