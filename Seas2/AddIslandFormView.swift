//
//  AddIslandFormView.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
import SwiftUI
import CoreData
import Combine
import CoreLocation
import Foundation

struct AddIslandFormView: View {
    @Binding var islandName: String
    @Binding var islandLocation: String
    @Binding var enteredBy: String
    @Binding var gymWebsite: String
    @Binding var gymWebsiteURL: URL?

    @State private var street: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zip: String = ""
    
    @State private var isSaveEnabled: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Island Details")) {
                    TextField("Island Name", text: $islandName)
                    TextField("Street", text: $street)
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("Zip", text: $zip)
                }
                .onChange(of: street) { _ in updateIslandLocation() }
                .onChange(of: city) { _ in updateIslandLocation() }
                .onChange(of: state) { _ in updateIslandLocation() }
                .onChange(of: zip) { _ in updateIslandLocation() }
                
                Section(header: Text("Instagram link/Facebook/Website(if applicable)")) {
                    TextField("Links", text: Binding<String>(
                        get: { gymWebsite },
                        set: { newValue in
                            gymWebsite = newValue
                            gymWebsiteURL = URL(string: newValue)
                        }
                    ))
                    .keyboardType(.URL)
                }
                
                Section(header: Text("Entered By")) {
                    TextField("Your Name", text: $enteredBy)
                }
                
                Button("Save") {
                    if isSaveEnabled {
                        geocodeIslandLocation()
                    } else {
                        print("Error: Required fields are empty")
                    }
                }
                .disabled(!isSaveEnabled)
            }
            .navigationTitle("Add Island")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onReceive(Just(())) { _ in
            validateFields()
        }
    }

    private func updateIslandLocation() {
        islandLocation = "\(street), \(city), \(state) \(zip)"
    }
    
    private func validateFields() {
        let isValid = !islandName.isEmpty &&
                      !street.isEmpty &&
                      !city.isEmpty &&
                      !state.isEmpty &&
                      !zip.isEmpty &&
                      !enteredBy.isEmpty
        isSaveEnabled = isValid
    }

    private func clearFields() {
        islandName = ""
        islandLocation = ""
        enteredBy = ""
        street = ""
        city = ""
        state = ""
        zip = ""
        gymWebsite = "" // Reset to empty string
        gymWebsiteURL = nil // Reset to nil
    }
    
    private func geocodeIslandLocation() {
        geocodeAddress(islandLocation) { result in
            switch result {
            case .success(let (latitude, longitude)):
                saveIsland(latitude: latitude, longitude: longitude)
                clearFields()
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Geocoding failed: \(error.localizedDescription)")
            }
        }
    }

    private func saveIsland(latitude: Double, longitude: Double) {
        let newIsland = PirateIsland(context: viewContext)
        newIsland.islandName = islandName
        newIsland.islandLocation = islandLocation
        newIsland.enteredBy = enteredBy
        newIsland.creationDate = Date() // Set the creationDate to the current date
        newIsland.timestamp = Date()
        
        // Convert Double to NSNumber for latitude and longitude
        newIsland.latitude = NSNumber(value: latitude)
        newIsland.longitude = NSNumber(value: longitude)
        
        newIsland.gymWebsite = gymWebsiteURL // Assign gymWebsiteURL
        
        do {
            try viewContext.save()
            print("Debug - Successfully saved new island")
        } catch {
            print("Debug - Failed to save new island: \(error.localizedDescription)")
        }
    }
}

struct AddIslandFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddIslandFormView(islandName: .constant(""), islandLocation: .constant(""), enteredBy: .constant(""), gymWebsite: .constant(""), gymWebsiteURL: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
