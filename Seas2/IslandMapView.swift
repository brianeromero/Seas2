//  IslandMapView.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
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
import MapKit

struct IslandMapView: View {
    let islands: [PirateIsland]

    @State private var selectedIsland: PirateIsland?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ForEach(islands, id: \.self) { island in
                    VStack(alignment: .leading) {
                        // Island details
                        Text("Gym: \(island.islandName ?? "Unknown")")
                        Text("Location: \(island.islandLocation ?? "Unknown")")
                        // Other island details...

                        // Handle map here
                        if let latitude = island.latitude?.doubleValue, let longitude = island.longitude?.doubleValue {
                            IslandMapViewMap(
                                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                islandName: island.islandName ?? "",
                                islandLocation: island.islandLocation ?? "",
                                onTap: {
                                    selectedIsland = island
                                    openInMaps(island: island)
                                }
                            )
                            .frame(height: 300)
                            .padding()

                            Button("Open in Maps") {
                                selectedIsland = island
                                openInMaps(island: island)
                            }
                            .padding(.top, 5)
                            .foregroundColor(.blue)
                        } else {
                            Text("Island location not available")
                        }
                    }
                    .padding()
                }
            }
            .padding()
            .navigationTitle("Island Details")
        }
    }

    private func openInMaps(island: PirateIsland) {
        if let latitude = island.latitude?.doubleValue, let longitude = island.longitude?.doubleValue {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let baseUrl = "http://maps.apple.com/?"
            let locationString = "\(latitude),\(longitude)"
            let nameAndLocation = "\(island.islandName ?? ""), \(island.islandLocation ?? "")"
            let encodedLocation = locationString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedNameAndLocation = nameAndLocation.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let finalUrlString = baseUrl + "q=\(encodedNameAndLocation)&ll=\(encodedLocation)"
            if let url = URL(string: finalUrlString) {
                UIApplication.shared.open(url)
            }
        }
    }
}

struct IslandMapView_Previews: PreviewProvider {
    static var previews: some View {
        IslandMapView(islands: [])
    }
}

struct IslandMapViewMap: View {
    var coordinate: CLLocationCoordinate2D
    var islandName: String
    var islandLocation: String
    var onTap: () -> Void // Closure to handle tap

    var body: some View {
        Map(
            coordinateRegion: .constant(MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )),
            annotationItems: [CustomMarker(coordinate: coordinate)]
        ) { marker in
            MapAnnotation(coordinate: marker.coordinate) {
                VStack {
                    Text(islandName)
                        .font(.headline)
                        .foregroundColor(.black)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(5)
                        .padding(5)
                    Text(islandLocation)
                        .font(.footnote)
                        .foregroundColor(.black)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(5)
                        .padding(5)
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            onTap() // Call onTap closure when tapped
                        }
                }
            }
        }
        .navigationTitle(islandName)
    }
}

// Define CustomMarker conforming to Identifiable protocol
struct CustomMarker: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
