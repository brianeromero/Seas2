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
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var selectedProtocol: String = "http://"

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
                    Picker("Protocol", selection: $selectedProtocol) {
                        Text("http://").tag("http://")
                        Text("https://").tag("https://")
                        Text("ftp://").tag("ftp://")
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    TextField("Links", text: $gymWebsite, onEditingChanged: { _ in
                        DispatchQueue.main.async {
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
                        }
                    })
                    .keyboardType(.URL)
                }
                
                Section(header: Text("Entered By")) {
                    TextField("Your Name", text: $enteredBy)
                }
                
                Button("Save") {
                    if isSaveEnabled {
                        print("Save button tapped")
                        geocodeIslandLocation()
                    } else {
                        print("Save button disabled")
                        print("Error: Required fields are empty or URL is invalid")
                    }
                }
                .disabled(!isSaveEnabled)
            }
            .navigationTitle("Add Island")
            .navigationBarItems(leading: cancelButton, trailing: EmptyView())
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onReceive(Just(())) { _ in
            validateFields()
        }
    }

    private var cancelButton: some View {
        Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        }
    }

    private func updateIslandLocation() {
        islandLocation = "\(street), \(city), \(state) \(zip)"
    }
    
    private func validateFields() {
        DispatchQueue.main.async {
            let isValid = !islandName.isEmpty &&
                          !street.isEmpty &&
                          !city.isEmpty &&
                          !state.isEmpty &&
                          !zip.isEmpty &&
                          !enteredBy.isEmpty &&
                          (gymWebsite.isEmpty || gymWebsiteURL != nil)
            isSaveEnabled = isValid
        }
    }

    private func clearFields() {
        DispatchQueue.main.async {
            islandName = ""
            islandLocation = ""
            enteredBy = ""
            street = ""
            city = ""
            state = ""
            zip = ""
            gymWebsite = ""
            gymWebsiteURL = nil
        }
    }

    private func geocodeIslandLocation() {
        geocodeAddress(islandLocation) { result in
            DispatchQueue.main.async {
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
    }

    private func saveIsland(latitude: Double, longitude: Double) {
        DispatchQueue.main.async {
            let newIsland = PirateIsland(context: viewContext)
            newIsland.islandName = islandName
            newIsland.islandLocation = islandLocation
            newIsland.enteredBy = enteredBy
            newIsland.creationDate = Date()
            newIsland.timestamp = Date()
            newIsland.latitude = NSNumber(value: latitude)
            newIsland.longitude = NSNumber(value: longitude)
            newIsland.gymWebsite = gymWebsiteURL

            do {
                try viewContext.save()
                print("Debug - Successfully saved new island")
            } catch {
                print("Debug - Failed to save new island: \(error.localizedDescription)")
            }
        }
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

struct AddIslandFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddIslandFormView(islandName: .constant(""), islandLocation: .constant(""), enteredBy: .constant(""), gymWebsite: .constant(""), gymWebsiteURL: .constant(nil))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
