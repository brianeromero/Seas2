import SwiftUI
import CoreLocation
import MapKit
import CoreData

struct CustomMapMarker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct EnterZipCodeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var enteredLocation: CustomMapMarker?
    @State private var pirateIslands: [CustomMapMarker] = []
    @State private var showMap = false
    @State private var zipCode = ""

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        VStack {
            TextField("Enter Zip Code", text: $zipCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Search") {
                fetchLocation(for: zipCode)
            }
            .padding()

            // Show the map if locations are available
            if showMap {
                Map(coordinateRegion: $region, annotationItems: [enteredLocation].compactMap { $0 } + pirateIslands) { location in
                    MapPin(coordinate: location.coordinate, tint: location.id == enteredLocation?.id ? .red : .blue)
                }
                .frame(height: 300)
                .padding()
            }
        }
        .navigationBarTitle("Enter Zip Code")
        .onAppear {
            updateRegion()
        }
    }

    private func fetchLocation(for address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }

            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                print("No location found")
                return
            }

            print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")

            let newMarker = CustomMapMarker(coordinate: location.coordinate)
            self.enteredLocation = newMarker
            self.showMap = true // Show map after fetching location
            self.fetchPirateIslandsNear(location.coordinate)
            self.updateRegion()
        }
    }

    private func fetchPirateIslandsNear(_ location: CLLocationCoordinate2D) {
        // Fetch pirate islands near the given location using CoreData
        // Modify this part to fetch pirate islands from CoreData
        // Here, I'm just adding dummy pirate islands for demonstration
        self.pirateIslands = [
            CustomMapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude + 0.01, longitude: location.longitude + 0.01)),
            CustomMapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude - 0.01, longitude: location.longitude - 0.01))
        ]
    }

    private func updateRegion() {
        if let location = enteredLocation {
            region.center = location.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        }
    }
}
