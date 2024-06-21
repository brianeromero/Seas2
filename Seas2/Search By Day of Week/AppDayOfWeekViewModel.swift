//
//  AppDayOfWeekViewModel.swift
//  Seas2
//
//  Created by Brian Romero on 6/20/24.
//

import Foundation
import CoreData
import SwiftUI

class AppDayOfWeekViewModel: ObservableObject {
    @Published var daysOfWeek: [AppDayOfWeek.DayOfWeek] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    @Published var selectedDays: [Bool] // Array to store selected days

    @Published var matTime: String = "" {
        didSet {
            validateTime()
        }
    }
    
    @Published var restrictions: Bool = false
    @Published var restrictionDescription: String = ""
    @Published var selectedGiNoGi: Bool = true // true for Gi, false for NoGi
    @Published var openMat: Bool = false // true for Open Mat, false for Class
    @Published var goodForBeginners: Bool = false // true if open for beginners

    init() {
        // Initialize selectedDays array with false for each day after daysOfWeek is initialized
        self.selectedDays = []
        self.selectedDays = Array(repeating: false, count: daysOfWeek.count)
    }

    var isFormValid: Bool {
        !matTime.isEmpty
    }

    func toggleDayOfWeek(at index: Int) {
        guard index >= 0 && index < daysOfWeek.count else { return }
        selectedDays[index].toggle()
        saveDayOfWeek()
    }

    func isSelected(day: AppDayOfWeek.DayOfWeek) -> Bool {
        guard let index = daysOfWeek.firstIndex(of: day) else { return false }
        return selectedDays[index]
    }

    func binding(for day: AppDayOfWeek.DayOfWeek) -> Binding<Bool> {
        let index = daysOfWeek.firstIndex(of: day) ?? 0
        return Binding(
            get: { self.selectedDays[index] },
            set: { newValue in
                self.selectedDays[index] = newValue
                self.saveDayOfWeek()
            }
        )
    }

    func fetchCurrentDayOfWeek() -> AppDayOfWeek? {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<AppDayOfWeek> = AppDayOfWeek.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first // Assuming there's only one instance
        } catch {
            Logger.log("Error fetching current day of week: \(error.localizedDescription)", view: "AppDayOfWeekViewModel")
            return nil
        }
    }

    func saveDayOfWeek() {
        guard let currentDayOfWeek = fetchCurrentDayOfWeek() else {
            Logger.log("Error: Current day of week is nil.", view: "AppDayOfWeekViewModel")
            return
        }
        
        currentDayOfWeek.matTime = matTime
        currentDayOfWeek.restrictions = restrictions
        currentDayOfWeek.restrictionDescription = restrictions ? restrictionDescription : ""
        currentDayOfWeek.gi = selectedGiNoGi
        currentDayOfWeek.noGi = !selectedGiNoGi
        currentDayOfWeek.openMat = openMat
        currentDayOfWeek.goodForBeginners = goodForBeginners
        
        do {
            let context = CoreDataStack.shared.context
            try context.save()
            Logger.log("Day of week saved successfully.", view: "AppDayOfWeekViewModel")
        } catch {
            Logger.log("Failed to save day of week: \(error.localizedDescription)", view: "AppDayOfWeekViewModel")
        }
    }

    private func validateTime() {
        // Example validation (HH:mm format)
        let regex = #"^([01]?[0-9]|2[0-3]):[0-5][0-9]$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: matTime) {
            // Invalid time format
            matTime = "" // Reset to empty string or handle error state
            Logger.log("Invalid time format entered.", view: "AppDayOfWeekViewModel")
        }
    }
}
