//
//  IslandMenu.swift
//  Seas2
//
//  Created by Brian Romero on 6/7/24.
import SwiftUI
import CoreData
import CoreLocation
import MapKit

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let subMenuItems: [String]?
}

struct IslandMenu: View {
    @StateObject private var locationManager = LocationManager()
    @Environment(\.managedObjectContext) private var viewContext

    @State private var navigateToEdit: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    let menuItems: [MenuItem] = [
        MenuItem(title: "Manage Gyms", subMenuItems: ["Add New Gym", "Update Existing"]),
        MenuItem(title: "Find Surrounding Gyms", subMenuItems: ["Near Me (use current location)", "Enter Zip Code"]),
    ]

    var body: some View {
        NavigationView {
            ZStack {
                // Display GIF as background
                GIFView(name: "flashing")

                VStack(alignment: .leading, spacing: 20) {
                    Text("Main Menu")
                        .font(.title)
                        .bold()
                        .padding(.top, 10)

                    ForEach(menuItems) { menuItem in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(menuItem.title)
                                .font(.headline)
                                .padding(.bottom, 20)

                            if let subMenuItems = menuItem.subMenuItems {
                                ForEach(subMenuItems, id: \.self) { subMenuItem in
                                    if subMenuItem == "Add New Gym" {
                                        NavigationLink(destination: AddNewIsland()) {
                                            Text(subMenuItem)
                                                .foregroundColor(.blue)
                                        }
                                        .padding(.leading, 2)
                                    } else if subMenuItem == "Update Existing" {
                                        NavigationLink(destination: EditExistingIslandList()) {
                                            Text(subMenuItem)
                                                .foregroundColor(.blue)
                                        }
                                        .padding(.leading, 2)
                                        .onTapGesture {
                                            fetchIslandsNear(location: locationManager.userLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                                        }
                                    } else if subMenuItem == "Near Me (use current location)" {
                                        NavigationLink(destination: AllIslandMapView()) {
                                            Text(subMenuItem)
                                                .foregroundColor(.blue)
                                        }
                                        .padding(.leading, 2)
                                    } else {
                                        Button(action: {
                                            print("Selected: \(subMenuItem)")
                                        }) {
                                            Text(subMenuItem)
                                                .foregroundColor(.blue)
                                        }
                                        .padding(.leading, 2)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal, 20)
                .navigationBarTitle("Welcome to Island Locator", displayMode: .inline)
                .padding(.leading, -100)
            }
            .edgesIgnoringSafeArea(.all) // Make sure GIF fills the screen
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Location Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func fetchIslandsNear(location: CLLocationCoordinate2D) {
        // Fetch islands near the given location using Core Data fetch request
        // Example:
        // You need to replace this with your actual fetch request to get islands near the location
        // For demonstration, I'm returning an empty array here
        let islandsNearLocation = fetchIslandsNear(location: location)
        print(islandsNearLocation)
    }
}

struct IslandMenu_Previews: PreviewProvider {
    static var previews: some View {
        IslandMenu()
    }
}
