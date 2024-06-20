//
//  DayOfWeekFormView.swift
//  Seas2
//
//  Created by Brian Romero on 6/20/24.
//

import Foundation
import SwiftUI

struct DaysOfWeekFormView: View {
    @ObservedObject var viewModel: AppDayOfWeekViewModel
    
    var body: some View {
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
            
            Section(header: Text("Class or Open MatClass")) {
                Picker("Select one", selection: $viewModel.openMat) {
                    Text("Class").tag(true)
                    Text("Open Mat").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Open for Beginners")) {
                Toggle("Open for Beginners", isOn: $viewModel.goodForBeginners)
            }
            
            Section(header: Text("Restriction")) {
                Toggle("Restriction", isOn: $viewModel.restrictions.animation())
                
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
        .navigationTitle("Day of Week Form")
    }
}

struct DaysOfWeekFormView_Previews: PreviewProvider {
    static var previews: some View {
        DaysOfWeekFormView(viewModel: AppDayOfWeekViewModel())
    }
}
