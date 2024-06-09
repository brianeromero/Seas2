import SwiftUI
import CoreData
import Combine
import CoreLocation
import Foundation
import MapKit

struct IslandMap: View {
    let islands: [PirateIsland]
    @State private var region: MKCoordinateRegion

    init(islands: [PirateIsland]) {
        self.islands = islands

        // Calculate the center and span of the map
        var centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        var minLat: Double?
        var maxLat: Double?
        var minLon: Double?
        var maxLon: Double?

        for island in islands {
            if let latitude = island.latitude?.doubleValue, let longitude = island.longitude?.doubleValue {
                if minLat == nil || maxLat == nil || minLon == nil || maxLon == nil {
                    minLat = latitude
                    maxLat = latitude
                    minLon = longitude
                    maxLon = longitude
                } else {
                    minLat = min(minLat!, latitude)
                    maxLat = max(maxLat!, latitude)
                    minLon = min(minLon!, longitude)
                    maxLon = max(maxLon!, longitude)
                }
            }
        }

        // Calculate the center coordinates
        if let minLat = minLat, let maxLat = maxLat, let minLon = minLon, let maxLon = maxLon {
            centerCoordinate = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        }

        let span = MKCoordinateSpan(latitudeDelta: (maxLat ?? 0) - (minLat ?? 0), longitudeDelta: (maxLon ?? 0) - (minLon ?? 0))
        _region = State(initialValue: MKCoordinateRegion(center: centerCoordinate, span: span))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: islands.compactMap { island -> Marker? in
            // Check if latitude and longitude are not nil
            guard let latitude = island.latitude?.doubleValue, let longitude = island.longitude?.doubleValue else {
                return nil
            }
            return Marker(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }) { marker in
            MapAnnotation(coordinate: marker.coordinate) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
            }
        }
        .navigationTitle("Island Map")
    }
}

// Define Marker conforming to Identifiable protocol
struct Marker: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
