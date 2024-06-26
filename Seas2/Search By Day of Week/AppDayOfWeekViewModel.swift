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
    @Published var daysOfWeek: [AppDayOfWeek.DayOfWeek]
    @Published private(set) var selectedDays: [Bool]
    @Published var matTime: String = ""
    @Published var restrictions: Bool = false
    @Published var restrictionDescription: String = ""
    @Published var goodForBeginners: Bool = false
    @Published var gi: Bool = false
    @Published var noGi: Bool = false

    private let coreDataStack: CoreDataStack

    init() {
        self.selectedDays = Array(repeating: false, count: 7) // Assuming 7 days in a week
        self.coreDataStack = CoreDataStack.shared // Initialize coreDataStack
        self.daysOfWeek = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]

        self.fetchCurrentDayOfWeek()
    }

    var isFormValid: Bool {
        // Ensure matTime is not empty
        if matTime.isEmpty {
            return false
        }

        // Ensure restriction description is not empty if restrictions are enabled
        if restrictions && restrictionDescription.isEmpty {
            return false
        }

        return true
    }
    
    lazy var fetchDayOfWeek: AppDayOfWeek? = {
        let context = coreDataStack.context
        let fetchRequest: NSFetchRequest<AppDayOfWeek> = AppDayOfWeek.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            return results.first // Assuming there's only one instance
        } catch {
            Logger.log("Error fetching current day of week: \(error.localizedDescription)", view: "AppDayOfWeekViewModel")
            return nil
        }
    }()


    func fetchCurrentDayOfWeek() {
        guard let currentDayOfWeek = fetchDayOfWeek else {
            // If fetchDayOfWeek returns nil, create a new instance
            let newDayOfWeek = AppDayOfWeek(context: coreDataStack.context)
            newDayOfWeek.matTime = "" // Set default values as needed
            newDayOfWeek.restrictions = false
            newDayOfWeek.restrictionDescription = ""
            newDayOfWeek.goodForBeginners = false
            newDayOfWeek.gi = false
            newDayOfWeek.noGi = false
            
            // Set initial values for selected days
            for (index, day) in daysOfWeek.enumerated() {
                switch day {
                case .sunday:
                    newDayOfWeek.sunday = false
                case .monday:
                    newDayOfWeek.monday = false
                case .tuesday:
                    newDayOfWeek.tuesday = false
                case .wednesday:
                    newDayOfWeek.wednesday = false
                case .thursday:
                    newDayOfWeek.thursday = false
                case .friday:
                    newDayOfWeek.friday = false
                case .saturday:
                    newDayOfWeek.saturday = false
                }
                selectedDays[index] = false
            }
            
            self.saveNewDayOfWeek(newDayOfWeek) // Save the newly created instance
            return
        }

        // If an existing entity is fetched, update properties and selected days
        matTime = currentDayOfWeek.matTime ?? ""
        restrictions = currentDayOfWeek.restrictions
        restrictionDescription = currentDayOfWeek.restrictionDescription ?? ""
        goodForBeginners = currentDayOfWeek.goodForBeginners
        gi = currentDayOfWeek.gi
        noGi = currentDayOfWeek.noGi

        // Update selected days based on fetched data
        for (index, day) in daysOfWeek.enumerated() {
            switch day {
            case .sunday:
                selectedDays[index] = currentDayOfWeek.sunday
            case .monday:
                selectedDays[index] = currentDayOfWeek.monday
            case .tuesday:
                selectedDays[index] = currentDayOfWeek.tuesday
            case .wednesday:
                selectedDays[index] = currentDayOfWeek.wednesday
            case .thursday:
                selectedDays[index] = currentDayOfWeek.thursday
            case .friday:
                selectedDays[index] = currentDayOfWeek.friday
            case .saturday:
                selectedDays[index] = currentDayOfWeek.saturday
            }
        }
        
        // Debug statement
        print("Current day of week fetched successfully.")
    }

    func saveDayOfWeek() {
        guard let currentDayOfWeek = fetchDayOfWeek else {
            Logger.log("Error: Current day of week is nil.", view: "AppDayOfWeekViewModel")
            return
        }

        currentDayOfWeek.matTime = matTime
        currentDayOfWeek.restrictions = restrictions
        currentDayOfWeek.restrictionDescription = restrictions ? restrictionDescription : ""
        currentDayOfWeek.goodForBeginners = goodForBeginners
        currentDayOfWeek.gi = gi
        currentDayOfWeek.noGi = noGi

        // Update individual days of the week based on selectedDays
        for (index, day) in daysOfWeek.enumerated() {
            switch day {
            case .sunday:
                currentDayOfWeek.sunday = selectedDays[index]
            case .monday:
                currentDayOfWeek.monday = selectedDays[index]
            case .tuesday:
                currentDayOfWeek.tuesday = selectedDays[index]
            case .wednesday:
                currentDayOfWeek.wednesday = selectedDays[index]
            case .thursday:
                currentDayOfWeek.thursday = selectedDays[index]
            case .friday:
                currentDayOfWeek.friday = selectedDays[index]
            case .saturday:
                currentDayOfWeek.saturday = selectedDays[index]
            }
        }

        do {
            try currentDayOfWeek.managedObjectContext?.save()
            Logger.log("Day of week saved successfully.", view: "AppDayOfWeekViewModel")
            
            // Debug statement
            print("Day of week saved successfully.")
        } catch {
            Logger.log("Failed to save day of week: \(error.localizedDescription)", view: "AppDayOfWeekViewModel")
        }
    }

    func validateTime() {
        let regex = #"^([01]?[0-9]|2[0-3]):[0-5][0-9]$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: matTime) {
            matTime = ""
            Logger.log("Invalid time format entered.", view: "AppDayOfWeekViewModel")
            
            // Debug statement
            print("Invalid time format entered.")
        }
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

    private func saveNewDayOfWeek(_ newDayOfWeek: AppDayOfWeek) {
        do {
            try newDayOfWeek.managedObjectContext?.save()
            Logger.log("New day of week entity saved successfully.", view: "AppDayOfWeekViewModel")
            
            // Debug statement
            print("New day of week entity saved successfully.")
        } catch {
            Logger.log("Failed to save new day of week entity: \(error.localizedDescription)", view: "AppDayOfWeekViewModel")
        }
    }
}
