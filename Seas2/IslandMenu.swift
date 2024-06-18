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

    @State private var showAlert = false
    @State private var alertMessage = ""

    let menuItems: [MenuItem] = [
        MenuItem(title: "Manage Gyms", subMenuItems: ["Add New Gym", "Update Existing"]),
        MenuItem(title: "Find Surrounding Gyms", subMenuItems: ["All Entered Locations", "Near Me (use current location)", "Enter Zip Code"]),
    ]

    var body: some View {
        NavigationView {
            ZStack {
                // Your existing content
                GIFView(name: "flashing2")
                    .frame(width: 500, height: 450)
                    .offset(x: 100, y: -150)

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
                                    NavigationLink(destination: destinationView(for: subMenuItem).padding(.leading, 2)) {
                                        if subMenuItem == "All Entered Locations" {
                                            Label(subMenuItem, systemImage: "map")
                                                .foregroundColor(.blue)
                                        } else {
                                            Text(subMenuItem)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 20)
                    }

                    // Link to ContentView
                    NavigationLink(destination: ContentView()) {
                        Text("ContentView")
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 2)
                    
                    NavigationLink(destination: FAQnDisclaimerMenuView()) {
                        Text("FAQ & Disclaimer Info")
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 2)
                }
                .padding(.horizontal, 20)
                .navigationBarTitle("Welcome to Island Locator", displayMode: .inline)
                .padding(.leading, -100)
            }
            .edgesIgnoringSafeArea(.all)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Location Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    @ViewBuilder
    private func destinationView(for menuItem: String) -> some View {
        switch menuItem {
        case "Add New Gym":
            AddNewIsland()
        case "Update Existing":
            EditExistingIslandList().onAppear {
                fetchIslandsNear(location: locationManager.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
            }
        case "All Entered Locations":
            AllEnteredLocations()
        case "Near Me (use current location)":
            ConsolidatedIslandMapView()
        case "Enter Zip Code":
            EnterZipCodeView()
        default:
            EmptyView()
        }
    }
    
    private func fetchIslandsNear(location: CLLocationCoordinate2D) {
        let distance: CLLocationDistance = 1000
        let islandsNearLocation = PirateIsland.fetchIslandsNear(location: location, within: distance, in: viewContext)
        print(islandsNearLocation)
    }
}

struct IslandMenu_Previews: PreviewProvider {
    static var previews: some View {
        IslandMenu()
    }
}
