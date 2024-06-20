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
        MenuItem(title: "Search For Gyms/ Open Mats By", subMenuItems: ["Day of Week", "All Entered Locations", "Near Me (use current location)", "Enter Zip Code"]),
        MenuItem(title: "Manage Gyms", subMenuItems: ["Add New Gym", "Update Existing\n(including mat times and classes)"]),
    ]

    var body: some View {
        NavigationView {
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
                                NavigationLink(destination: destinationView(for: subMenuItem)) {
                                    if subMenuItem == "Day of Week" {
                                        HStack {
                                            Image("calendar Image")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 30, height: 30)
                                                .padding(.trailing, -10) // Adjust padding as needed

                                            Text(subMenuItem)
                                                .foregroundColor(.blue)
                                        }
                                    } else {
                                        Label(subMenuItem, systemImage: icon(for: subMenuItem))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }

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
            .navigationBarTitle("Welcome to Mat_Finder", displayMode: .inline)
            .padding(.leading, -100)
        }
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Location Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    @ViewBuilder
    private func destinationView(for menuItem: String) -> some View {
        switch menuItem {
        case "Add New Gym":
            AddNewIsland()
        case "Update Existing\n(including mat times and classes)":
            EditExistingIslandList()
                .onAppear {
                    // Perform actions needed on view appear
                    do {
                        try fetchIslandsNear(location: locationManager.userLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                    } catch {
                        print("Error fetching islands: \(error)")
                        showAlert = true
                        alertMessage = error.localizedDescription
                    }
                }
        case "All Entered Locations":
            AllEnteredLocations()
        case "Near Me (use current location)":
            ConsolidatedIslandMapView()
        case "Enter Zip Code":
            EnterZipCodeView()
        case "Day of Week":
            DaysOfWeekView()
        default:
            EmptyView()
        }
    }

    private func fetchIslandsNear(location: CLLocationCoordinate2D) throws -> [PirateIsland] {
        let distance: CLLocationDistance = 1000
        return try PirateIsland.fetchIslandsNear(location: location, within: distance, in: viewContext)
    }

    private func icon(for menuItem: String) -> String {
        switch menuItem {
        case "All Entered Locations":
            return "map"
        case "Near Me (use current location)":
            return "mappin.square.fill"
        default:
            return "questionmark.square.fill"
        }
    }
}

struct IslandMenu_Previews: PreviewProvider {
    static var previews: some View {
        IslandMenu()
    }
}
