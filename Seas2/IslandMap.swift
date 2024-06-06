import SwiftUI
import MapKit

// Define Marker conforming to Identifiable protocol
struct Marker: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct IslandMap: View {
    let islands: [PirateIsland]
    @State private var region: MKCoordinateRegion

    init(islands: [PirateIsland]) {
        self.islands = islands
        
        var minLat = 90.0
        var maxLat = -90.0
        var minLon = 180.0
        var maxLon = -180.0

        for island in islands {
            minLat = min(minLat, island.latitude)
            maxLat = max(maxLat, island.latitude)
            minLon = min(minLon, island.longitude)
            maxLon = max(maxLon, island.longitude)
        }

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: maxLat - minLat, longitudeDelta: maxLon - minLon)

        _region = State(initialValue: MKCoordinateRegion(center: center, span: span))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: islands) { island in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: island.latitude, longitude: island.longitude)) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
            }
        }
        .navigationTitle("Island Map")
    }
}
