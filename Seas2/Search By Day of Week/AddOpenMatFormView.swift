//  AddOpenMatFormView.swift
//  Seas2
//
//  Created by Brian Romero on 6/21/24.
//

import SwiftUI

struct AddOpenMatFormView: View {
    @ObservedObject var viewModel: AppDayOfWeekViewModel
    
    // Computed property to determine if the Save button should be enabled
    private var isSaveEnabled: Bool {
        return viewModel.isFormValid // Assuming isFormValid is a property in your viewModel
    }

    var body: some View {
        NavigationView {
            Form {
                // Days of Week Section
                Section(header: Text("Days of Week")) {
                    ForEach(viewModel.daysOfWeek, id: \.self) { day in
                        Toggle(day.rawValue, isOn: viewModel.binding(for: day))
                    }
                }
                
                // Time per Day Section
                Section(header: Text("Time per Day")) {
                    TextField("Enter Time (e.g., 7:00 PM)", text: $viewModel.matTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.asciiCapable) // Allows only ASCII characters
                        .onChange(of: viewModel.matTime, perform: { newValue in
                            viewModel.validateTime()
                        })
                }

                // Gi or NoGi Section
                giOrNoGiSection
                
                // Open to All Levels Section
                Section(header: Text("Open to All Levels")) {
                    Toggle("Open to All Levels", isOn: $viewModel.goodForBeginners)
                }
                
                // Restrictions Section
                Section(header: Text("Restrictions")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("e.g. White Gis Only")
                            .foregroundColor(.secondary)
                        Text("Must Wear Rashguard underneath...")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                    
                    Toggle("Any Restrictions?", isOn: $viewModel.restrictions.animation())
                    
                    if viewModel.restrictions {
                        TextField("Description", text: $viewModel.restrictionDescription)
                    }
                }
                
                // Save Button Section
                Button("Save") {
                    viewModel.saveDayOfWeek() // Call saveDayOfWeek directly
                }
                .disabled(!isSaveEnabled) // Ensure button is enabled when isSaveEnabled is true
            }
            .navigationBarTitle("Add Open Mat Times / Class Schedule", displayMode: .inline)
        }
    }
    
    private var giOrNoGiSection: some View {
        Section(header: Text("Gi or NoGi")) {
            Toggle("Gi", isOn: $viewModel.gi.animation())
            Toggle("NoGi", isOn: $viewModel.noGi.animation())
        }
    }
}

struct AddOpenMatFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddOpenMatFormView(viewModel: AppDayOfWeekViewModel())
    }
}
