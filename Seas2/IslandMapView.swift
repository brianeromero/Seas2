//
//  IslandMapView.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
import Foundation
import SwiftUI
import CoreData
import Combine

struct IslandMapView: View {
    let island: PirateIsland
    @State private var mapURL: URL?
    @State private var geocodingError: String?

    var body: some View {
        VStack(alignment: .leading) {
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
        .navigationTitle("Island Map")
        .onAppear {
            self.geocodeAddress(island.islandLocation ?? "") { result in
                switch result {
                case .success(let (latitude, longitude)):
                    self.mapURL = URL(string: "https://maps.apple.com/?ll=\(latitude),\(longitude)")
                case .failure(let error):
                    self.geocodingError = error.localizedDescription
                }
            }
        }
    }

    private func geocodeAddress(_ address: String, completion: @escaping (Result<(Double, Double), Error>) -> Void) {
        // Implement your geocoding logic here
    }
}
