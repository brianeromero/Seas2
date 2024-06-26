//
//  AddClassScheduleView.swift
//  Seas2
//
//  Created by Brian Romero on 6/21/24.
//

import SwiftUI

struct AddClassScheduleView: View {
    @ObservedObject var viewModel: AppDayOfWeekViewModel
    
    var body: some View {
        NavigationView {
            Form {
                daysOfWeekSection
                timePerDaySection
                giOrNoGiSection
                openToAllLevelsSection
                restrictionsSection
                saveButtonSection
            }
            .navigationBarTitle("Add Open Mat Times / Class Schedule", displayMode: .inline)
        }
    }
    
    private var daysOfWeekSection: some View {
        Section(header: Text("Days of Week")) {
            ForEach(viewModel.daysOfWeek, id: \.self) { day in
                Toggle(day.rawValue, isOn: viewModel.binding(for: day))
            }
        }
    }
    
    private var timePerDaySection: some View {
        Section(header: Text("Time per Day")) {
            TextField("Time", text: $viewModel.matTime)
        }
    }
    
    private var giOrNoGiSection: some View {
        Section(header: Text("Gi or NoGi")) {
            Toggle("Gi", isOn: $viewModel.gi.animation())
                .onChange(of: viewModel.gi) { newValue in
                    if newValue {
                        viewModel.noGi = false // Ensuring only one can be true
                    }
                }
            
            Toggle("NoGi", isOn: $viewModel.noGi.animation())
                .onChange(of: viewModel.noGi) { newValue in
                    if newValue {
                        viewModel.gi = false // Ensuring only one can be true
                    }
                }
        }
    }
    
    private var openToAllLevelsSection: some View {
        Section(header: Text("Open to All Levels")) {
            Toggle("Open to All Levels", isOn: $viewModel.goodForBeginners)
        }
    }
    
    private var restrictionsSection: some View {
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
    }
    
    private var saveButtonSection: some View {
        Section {
            Button("Save") {
                viewModel.saveDayOfWeek()
            }
            .disabled(!isFormValid)
        }
    }
    
    private var isFormValid: Bool {
        let isTimeValid = validateTime(viewModel.matTime)
        let isDescriptionValid = !viewModel.restrictions || !viewModel.restrictionDescription.isEmpty
        // Add more validation as needed
        
        return isTimeValid && isDescriptionValid
    }
    
    private func validateTime(_ time: String) -> Bool {
        let regex = #"^([01]?[0-9]|2[0-3]):[0-5][0-9]$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: time)
    }
}

struct AddClassScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddClassScheduleView(viewModel: AppDayOfWeekViewModel())
    }
}
