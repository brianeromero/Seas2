//
//  AppDayOfWeekViewModel.swift
//  Seas2
//
//  Created by Brian Romero on 6/20/24.
//

import Foundation
import CoreData
import SwiftUI

import Foundation
import CoreData
import SwiftUI

class AppDayOfWeekViewModel: ObservableObject {
    @Published var daysOfWeek: [AppDayOfWeek.DayOfWeek] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    @Published var matTime: String = ""
    @Published var restrictions: Bool = false
    @Published var restrictionDescription: String = ""
    @Published var selectedGiNoGi: Bool = true // true for Gi, false for NoGi
    @Published var openMat: Bool = true // true for Open Mat, false for Class
    @Published var goodForBeginners: Bool = true // true if open for beginners

    var isFormValid: Bool {
        !matTime.isEmpty
    }

    func binding(for day: AppDayOfWeek.DayOfWeek) -> Binding<Bool> {
        Binding(
            get: { return self.getValue(for: day) },
            set: { newValue in self.setValue(newValue, for: day) }
        )
    }

    private func getValue(for day: AppDayOfWeek.DayOfWeek) -> Bool {
        guard let currentDayOfWeek = fetchCurrentDayOfWeek() else {
            return false // Handle default case when current day of week is nil
        }

        switch day {
        case .sunday: return currentDayOfWeek.sunday
        case .monday: return currentDayOfWeek.monday
        case .tuesday: return currentDayOfWeek.tuesday
        case .wednesday: return currentDayOfWeek.wednesday
        case .thursday: return currentDayOfWeek.thursday
        case .friday: return currentDayOfWeek.friday
        case .saturday: return currentDayOfWeek.saturday
        }
    }

    private func setValue(_ value: Bool, for day: AppDayOfWeek.DayOfWeek) {
        guard let currentDayOfWeek = fetchCurrentDayOfWeek() else {
            print("Error: Current day of week is nil.")
            return
        }

        switch day {
        case .sunday: currentDayOfWeek.sunday = value
        case .monday: currentDayOfWeek.monday = value
        case .tuesday: currentDayOfWeek.tuesday = value
        case .wednesday: currentDayOfWeek.wednesday = value
        case .thursday: currentDayOfWeek.thursday = value
        case .friday: currentDayOfWeek.friday = value
        case .saturday: currentDayOfWeek.saturday = value
        }
    }

    private func fetchCurrentDayOfWeek() -> AppDayOfWeek? {
        // Assuming you have a way to fetch the current instance of AppDayOfWeek
        // This could be done based on some identifier or another criterion
        // Replace this with your actual Core Data fetch logic
        
        // Example:
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<AppDayOfWeek> = AppDayOfWeek.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first // Assuming there's only one instance
        } catch {
            print("Error fetching current day of week: \(error.localizedDescription)")
            return nil
        }
    }

    func saveDayOfWeek() {
        guard let currentDayOfWeek = fetchCurrentDayOfWeek() else {
            print("Error: Current day of week is nil.")
            return
        }
        
        currentDayOfWeek.matTime = matTime
        currentDayOfWeek.restrictions = restrictions
        currentDayOfWeek.restrictionDescription = restrictions ? restrictionDescription : nil
        currentDayOfWeek.gi = selectedGiNoGi
        currentDayOfWeek.noGi = !selectedGiNoGi
        currentDayOfWeek.openMat = openMat
        currentDayOfWeek.goodForBeginners = goodForBeginners
        
        do {
            let context = CoreDataStack.shared.context
            try context.save()
            print("Day of week saved successfully.")
        } catch {
            print("Failed to save day of week: \(error.localizedDescription)")
        }
    }
}
