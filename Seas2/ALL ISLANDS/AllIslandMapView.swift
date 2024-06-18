//
//  AllIslandMapView.swift
//  Seas2
//
//  Created by Brian Romero on 6/6/24.
//
import SwiftUI
import CoreData
import CoreLocation
import MapKit

struct RadiusPicker: View {
    @Binding var selectedRadius: Double
    
    var body: some View {
        VStack {
            Text("Select Radius: \(String(format: "%.1f", selectedRadius)) miles")
            Slider(value: $selectedRadius, in: 1...50, step: 1)
                .padding(.horizontal)
        }
    }
}

struct ConsolidatedIslandMapView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PirateIsland.entity(), sortDescriptors: [], animation: .default)
    private var pirateIslands: FetchedResults<PirateIsland>
    
    @StateObject private var locationManager = LocationManager()
    @State private var selectedRadius: Double = 5.0
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var pirateMarkers: [CustomMapMarker] = []

    var body: some View {
        NavigationView {
            VStack {
                if let userLocation = locationManager.userLocation {
                    Map(coordinateRegion: $region, annotationItems: pirateMarkers) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            VStack {
                                Text(location.title)
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .shadow(radius: 3)
                                Image(systemName: location.title == "You are Here" ? "arrowshape.down.fill" : "mappin.circle.fill")
                                    .foregroundColor(location.title == "You are Here" ? .red : .blue)
                            }
                        }
                    }
                    .frame(height: 300)
                    .padding()
                    
                    // Add radius picker here
                    RadiusPicker(selectedRadius: $selectedRadius)
                        .padding()

                } else {
                    Text("Fetching user location...")
                        .navigationTitle("Island Map")
                }
            }
            .navigationTitle("Island Map")
            .onAppear {
                if let userLocation = locationManager.userLocation {
                    updateRegion(userLocation, radius: selectedRadius)
                    fetchPirateIslandsNear(userLocation, within: selectedRadius * 1609.34) // Convert miles to meters
                    // Add current location to markers
                    let currentLocationMarker = CustomMapMarker(coordinate: userLocation.coordinate, title: "You are Here")
                    pirateMarkers.append(currentLocationMarker)
                } else {
                    locationManager.requestLocation()
                }
            }
            .onChange(of: locationManager.userLocation) { newUserLocation in
                if let newUserLocation = newUserLocation {
                    updateRegion(newUserLocation, radius: selectedRadius)
                    fetchPirateIslandsNear(newUserLocation, within: selectedRadius * 1609.34)
                    // Update current location marker
                    let currentLocationMarker = CustomMapMarker(coordinate: newUserLocation.coordinate, title: "You are Here")
                    pirateMarkers.append(currentLocationMarker)
                }
            }
            .onChange(of: selectedRadius) { newRadius in
                if let userLocation = locationManager.userLocation {
                    updateRegion(userLocation, radius: newRadius)
                    fetchPirateIslandsNear(userLocation, within: newRadius * 1609.34)
                }
            }
        }
    }

    private func fetchPirateIslandsNear(_ location: CLLocation, within distance: CLLocationDistance) {
        // Fetch pirate islands near the user's location
        let results = pirateIslands.compactMap { island -> CustomMapMarker? in
            guard let latitude = island.latitude?.doubleValue,
                  let longitude = island.longitude?.doubleValue,
                  let title = island.islandName else {
                return nil
            }
            let islandLocation = CLLocation(latitude: latitude, longitude: longitude)
            let distanceInMeters = location.distance(from: islandLocation)
            // Check if the island is within the selected radius
            if distanceInMeters <= distance {
                return CustomMapMarker(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: title)
            } else {
                return nil
            }
        }
        self.pirateMarkers = results
        
        // Add current location marker
        if let userLocation = locationManager.userLocation {
            let currentLocationMarker = CustomMapMarker(coordinate: userLocation.coordinate, title: "You are Here")
            pirateMarkers.append(currentLocationMarker)
        }
    }

    private func updateRegion(_ userLocation: CLLocation, radius: Double) {
        // Calculate the span based on radius
        let span = MKCoordinateSpan(latitudeDelta: radius / 69.0, longitudeDelta: radius / 69.0)
        // Update the map region
        region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
    }
}
