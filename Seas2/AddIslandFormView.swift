//
//  AddIslandFormView.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//

import Foundation
import SwiftUI
import CoreData
import Combine

struct AddIslandFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var islandName: String
    @Binding var islandLocation: String
    @Binding var enteredBy: String
    
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zip = ""
    
    @State private var isSaveEnabled = false
    
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
                
                Section(header: Text("Entered By")) {
                    TextField("Your Name", text: $enteredBy)
                }
                
                Button("Save") {
                    if isSaveEnabled {
                        saveIsland()
                        clearFields()
                        presentationMode.wrappedValue.dismiss()
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
    }
    
    private func saveIsland() {
        let newIsland = PirateIsland(context: viewContext)
        newIsland.islandName = islandName
        newIsland.islandLocation = islandLocation
        newIsland.enteredBy = enteredBy
        newIsland.creationDate = Date() // Set the creationDate to the current date
        newIsland.timestamp = Date()
        
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
        AddIslandFormView(islandName: .constant(""), islandLocation: .constant(""), enteredBy: .constant(""))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
