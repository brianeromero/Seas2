// AllEnteredLocations.swift
// Seas2
//
// Created by Brian Romero on 6/17/24.

import SwiftUI
import CoreData
import CoreLocation
import MapKit

struct AllEnteredLocations: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: PirateIsland.entity(),
        sortDescriptors: []
    ) private var pirateIslands: FetchedResults<PirateIsland>
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    @State private var pirateMarkers: [CustomMapMarker] = []

    var body: some View {
        NavigationView {
            VStack {
                if !pirateMarkers.isEmpty {
                    Map(coordinateRegion: $region, annotationItems: pirateMarkers) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            VStack {
                                Text(location.title)
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .shadow(radius: 3)
                                CustomMarkerView()
                            }
                        }
                    }
                    .onAppear {
                        updateRegion()
                    }
                    .onChange(of: pirateMarkers, perform: { _ in
                        updateRegion()
                    })
                } else {
                    Text("No Open Mats found.")
                        .padding()
                }
            }
            .navigationTitle("All Open Mats Map")
            .onAppear {
                fetchPirateIslands()
            }
        }
    }

    private func fetchPirateIslands() {
        let results = pirateIslands.compactMap { island -> CustomMapMarker? in
            guard let latitude = island.latitude?.doubleValue,
                  let longitude = island.longitude?.doubleValue,
                  let title = island.islandName else {
                return nil
            }
            return CustomMapMarker(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), title: title)
        }
        self.pirateMarkers = results
    }

    private func updateRegion() {
        let coordinates = pirateMarkers.map { $0.coordinate }
        let mapRect = coordinates.map { MKMapPoint($0) }
                                 .reduce(MKMapRect.null) { $0.union(MKMapRect(origin: $1, size: MKMapRect.null.size)) }
        
        if mapRect.isNull {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        } else {
            region = MKCoordinateRegion(mapRect)
        }
    }
}

struct AllEnteredLocations_Previews: PreviewProvider {
    static var previews: some View {
        AllEnteredLocations().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
