//
//  AllMapView.swift
//  Seas2
//
//  Created by Brian Romero on 6/6/24.
//

import Foundation
import SwiftUI
import MapKit

struct AllMapView: View {
    @State private var region: MKCoordinateRegion
    let islands: [PirateIsland]
    let userLocation: CLLocationCoordinate2D

    init(islands: [PirateIsland], userLocation: CLLocationCoordinate2D) {
        self.islands = islands
        self.userLocation = userLocation // Initialize userLocation first
        
        let initialRegion = MKCoordinateRegion(
            center: userLocation,
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        self._region = State(initialValue: initialRegion)
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: islands) { island in
            MapMarker(coordinate: CLLocationCoordinate2D(
                latitude: island.latitude?.doubleValue ?? 0,
                longitude: island.longitude?.doubleValue ?? 0
            ), tint: .blue)
        }
        .onAppear {
            // Update the region asynchronously
            DispatchQueue.main.async {
                updateRegion()
            }
        }
    }
    
    private func updateRegion() {
        // Update the region to center on the user's current location
        region.center = userLocation
    }
}
