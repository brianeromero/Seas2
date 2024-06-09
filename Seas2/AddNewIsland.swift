//
//  AddNewIsland.swift
//  Seas2
//
//  Created by Brian Romero on 6/7/24.
//


import SwiftUI
import CoreData
import Combine
import CoreLocation
import Foundation

struct AddNewIsland: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var islandName = ""
    @State private var islandLocation = ""
    @State private var enteredBy = ""
    @State private var gymWebsite: URL?
    
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zip = ""
    
    @State private var isSaveEnabled = false
    
    @Environment(\.presentationMode) private var presentationMode
    
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
                        get: { gymWebsite?.absoluteString ?? "" },
                        set: { newValue in
                            if let url = URL(string: newValue) {
                                gymWebsite = url
                            }
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
            .navigationBarTitle(
                "Add Island",
                displayMode: .inline
            )
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onReceive(Just(())) { _ in
            validateFields()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20) // Add top padding
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

    private func geocodeIslandLocation() {
        // Implement geocoding logic
    }
}

struct AddNewIsland_Previews: PreviewProvider {
    static var previews: some View {
        AddNewIsland()
    }
}
