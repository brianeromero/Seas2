//
//  AddOpenMatFormView.swift
//  Seas2
//
//  Created by Brian Romero on 6/21/24.
//



import SwiftUI

struct AddOpenMatFormView: View {
    @ObservedObject var viewModel: AppDayOfWeekViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Days of Week")) {
                    ForEach(viewModel.daysOfWeek, id: \.self) { day in
                        Toggle(day.rawValue, isOn: viewModel.binding(for: day))
                    }
                }
                
                Section(header: Text("Time per Day")) {
                    TextField("Time", text: $viewModel.matTime)
                }
                
                Section(header: Text("Gi or NoGi")) {
                    Picker("Select one", selection: $viewModel.selectedGiNoGi) {
                        Text("Gi").tag(true)
                        Text("NoGi").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
        
                Section(header: Text("Open to All Levels")) {
                    Toggle("Open to All Levels", isOn: $viewModel.goodForBeginners)
                }
                
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
                
                Section {
                    Button("Save") {
                        viewModel.saveDayOfWeek()
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .navigationBarTitle("Add Open Mat Times / Class Schedule", displayMode: .inline)
        }
    }
}

struct AddOpenMatFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddOpenMatFormView(viewModel: AppDayOfWeekViewModel())
    }
}
