//  AppDayOfWeek+CoreDataProperties.swift
//  Seas2
//
//  Created by Brian Romero on 6/20/24.
//

import Foundation
import CoreData

extension AppDayOfWeek {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppDayOfWeek> {
        return NSFetchRequest<AppDayOfWeek>(entityName: "AppDayOfWeek")
    }
    
    // Include @NSManaged properties and relationships
    @NSManaged var sunday: Bool
    @NSManaged var monday: Bool
    @NSManaged var tuesday: Bool
    @NSManaged var wednesday: Bool
    @NSManaged var thursday: Bool
    @NSManaged var friday: Bool
    @NSManaged var saturday: Bool
    @NSManaged var matTime: String?
    @NSManaged var restrictions: Bool
    @NSManaged var restrictionDescription: String?
    @NSManaged var op_sunday: Bool
    @NSManaged var op_monday: Bool
    @NSManaged var op_tuesday: Bool
    @NSManaged var op_wednesday: Bool
    @NSManaged var op_thursday: Bool
    @NSManaged var op_friday: Bool
    @NSManaged var op_saturday: Bool
    @NSManaged var gi: Bool
    @NSManaged var noGi: Bool
    @NSManaged var goodForBeginners: Bool
    @NSManaged var openMat: Bool
    
    // Transformable attribute for selected days
    @NSManaged var daysSelected: [String]?
    
    // Relationship to PirateIsland
    @NSManaged var pirateIsland: PirateIsland?
}

// Separate extension for DayOfWeek enum
extension AppDayOfWeek {
    enum DayOfWeek: String, CaseIterable {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
    }
}

// Debugging
extension AppDayOfWeek {
    func printDetails() {
        print("Day of Week Details:")
        print("- Sunday: \(sunday)")
        print("- Monday: \(monday)")
        print("- Tuesday: \(tuesday)")
        print("- Wednesday: \(wednesday)")
        print("- Thursday: \(thursday)")
        print("- Friday: \(friday)")
        print("- Saturday: \(saturday)")
        print("- Mat Time: \(matTime ?? "Not set")")
        print("- Restrictions: \(restrictions)")
        print("- Restriction Description: \(restrictionDescription ?? "None")")
        print("- Open on Sunday: \(op_sunday)")
        print("- Open on Monday: \(op_monday)")
        print("- Open on Tuesday: \(op_tuesday)")
        print("- Open on Wednesday: \(op_wednesday)")
        print("- Open on Thursday: \(op_thursday)")
        print("- Open on Friday: \(op_friday)")
        print("- Open on Saturday: \(op_saturday)")
        print("- Gi: \(gi)")
        print("- No Gi: \(noGi)")
        print("- Good for Beginners: \(goodForBeginners)")
        print("- Open Mat: \(openMat)")
        if let selectedDays = daysSelected {
            print("- Days Selected: \(selectedDays)")
        } else {
            print("- Days Selected: None")
        }
        if let island = pirateIsland {
            print("- Pirate Island: \(island.islandName ?? "Unknown")")
        } else {
            print("- Pirate Island: None")
        }
    }
}
