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
    @State private var gymWebsite: String = ""
    @State private var gymWebsiteURL: URL?

    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zip = ""
    
    @State private var isSaveEnabled = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedProtocol = "http://"

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
                    Picker("Protocol", selection: $selectedProtocol) {
                        Text("http://").tag("http://")
                        Text("https://").tag("https://")
                        Text("ftp://").tag("ftp://")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    TextField("Links", text: $gymWebsite, onEditingChanged: { _ in
                        if !gymWebsite.isEmpty {
                            let strippedURL = stripProtocol(from: gymWebsite)
                            let fullURLString = selectedProtocol + strippedURL

                            if validateURL(fullURLString) {
                                gymWebsiteURL = URL(string: fullURLString)
                            } else {
                                showAlert = true
                                alertMessage = "Invalid link entry"
                                gymWebsite = ""
                                gymWebsiteURL = nil
                            }
                        } else {
                            gymWebsiteURL = nil
                        }
                        validateFields()
                    })
                    .keyboardType(.URL)
                }
                
                Section(header: Text("Entered By")) {
                    TextField("Your Name", text: $enteredBy)
                }
                
                Button("Save") {
                    if isSaveEnabled {
                        geocodeIslandLocation()
                    } else {
                        print("Error: Required fields are empty or URL is invalid")
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
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
                      !enteredBy.isEmpty &&
                      (gymWebsite.isEmpty || gymWebsiteURL != nil)
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
        // Implement geocoding logic
    }

    private func validateURL(_ urlString: String) -> Bool {
        let urlPattern = #"^(https?:\/\/)?(www\.)?(facebook\.com|instagram\.com|[\w\-]+\.[\w\-]+)(\/[\w\-\.]*)*\/?$"#
        return NSPredicate(format: "SELF MATCHES %@", urlPattern).evaluate(with: urlString)
    }

    private func stripProtocol(from urlString: String) -> String {
        var strippedString = urlString
        if let range = strippedString.range(of: "://") {
            strippedString = String(strippedString[range.upperBound...])
        }
        return strippedString
    }
}

struct AddNewIsland_Previews: PreviewProvider {
    static var previews: some View {
        AddNewIsland()
    }
}
