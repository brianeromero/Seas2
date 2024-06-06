//
//  IslandMapView.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
import SwiftUI
import MapKit
import CoreData

struct IslandMapView: View {
    let islands: [PirateIsland]
    @State private var mapURL: URL?
    @State private var geocodingError: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            // Display island details and map
            ForEach(islands) { island in
                VStack(alignment: .leading) {
                    // Island details
                    Text("Gym: \(island.islandName ?? "Unknown")")
                    Text("Location: \(island.islandLocation ?? "Unknown")")
                    Text("Entered By: \(island.enteredBy ?? "Unknown")")
                    Text("Added Date: \(island.creationDate?.formatted() ?? "Unknown")")
                    Text("Timestamp: \(island.timestamp?.formatted() ?? "Unknown")")
                    
                    if let mapURL = mapURL {
                        Link("Open in Maps", destination: mapURL)
                    } else if let geocodingError = geocodingError {
                        Text("Geocoding failed: \(geocodingError)").foregroundColor(.red)
                    } else {
                        Text("Loading map link...")
                    }
                }
                .padding()
                
                IslandMap(islands: [island]) // Pass the current island as a single-element array
                    .frame(height: 300) // Adjust the height as needed
                    .onAppear {
                        geocodeAddress(island.islandLocation ?? "")
                    }
            }
        }
        .padding()
        .navigationTitle("Island Details")
    }

    private func geocodeAddress(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                self.geocodingError = error.localizedDescription
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                let coordinate = location.coordinate
                DispatchQueue.main.async {
                    self.mapURL = URL(string: "https://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)")
                }
            }
        }
    }
}
