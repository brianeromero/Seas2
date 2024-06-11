//
//  AllIslandMapView.swift
//  Seas2
//
//  Created by Brian Romero on 6/6/24.
//

import Foundation
import SwiftUI
import CoreData
import CoreLocation

struct AllIslandMapView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: PirateIsland.entity(), sortDescriptors: [], animation: .default)
    private var pirateIslands: FetchedResults<PirateIsland>
    
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            if let userLocation = locationManager.userLocation {
                AllMapView(islands: Array(pirateIslands), userLocation: userLocation)
                    .navigationTitle("Island Map")
            } else {
                Text("Fetching user location...")
                    .navigationTitle("Island Map")
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}
