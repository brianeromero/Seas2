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
    
    init(islands: [PirateIsland]) {
        self.islands = islands
        
        // Calculate the initial region to fit all annotations
        if let minLat = islands.map({ $0.latitude as? Double ?? 0 }).min(),
           let maxLat = islands.map({ $0.latitude as? Double ?? 0 }).max(),
           let minLon = islands.map({ $0.longitude as? Double ?? 0 }).min(),
           let maxLon = islands.map({ $0.longitude as? Double ?? 0 }).max() {
            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
            let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.2, longitudeDelta: (maxLon - minLon) * 1.2)
            
            self._region = State(initialValue: MKCoordinateRegion(center: center, span: span))
        } else {
            // Default region if no islands are available
            self._region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            ))
        }
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: islands) { island in
            MapPin(coordinate: CLLocationCoordinate2D(latitude: island.latitude as? Double ?? 0, longitude: island.longitude as? Double ?? 0), tint: .blue)
        }
    }
}
