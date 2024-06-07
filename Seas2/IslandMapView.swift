//  IslandMapView.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
import SwiftUI
import CoreData
import Combine
import CoreLocation
import Foundation
import MapKit // Add this import

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
                        geocodeAddress(island.islandLocation ?? "", islandName: island.islandName ?? "")
                    }
            }
        }
        .padding()
        .navigationTitle("Island Details")
    }

    private func geocodeAddress(_ address: String, islandName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                self.geocodingError = error.localizedDescription
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                let coordinate = location.coordinate
                DispatchQueue.main.async {
                    // Adjust zoom level and span for the map
                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Adjust these values for desired zoom
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                    mapItem.name = islandName // Set island name as the name in Maps
                    mapURL = mapItem.url // Set the map URL
                }
            }
        }
    }
}



import SwiftUI
import CoreData

struct IslandMapView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        // Fetch pirateIslands using a FetchRequest
        let fetchRequest: NSFetchRequest<PirateIsland> = PirateIsland.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \PirateIsland.timestamp, ascending: true)]
        
        // Wrap the FetchRequest in a FetchResults
        let fetchedPirateIslands = FetchRequest(fetchRequest: fetchRequest)
        
        // Convert fetched results to an array
        let pirateIslandsArray = fetchedPirateIslands.wrappedValue.map { $0 }
        
        return IslandMapView(islands: pirateIslandsArray)
            .environment(\.managedObjectContext, context)
    }
}
