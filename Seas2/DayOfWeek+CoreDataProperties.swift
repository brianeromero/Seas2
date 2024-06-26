//
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

    @NSManaged public var sunday: Bool
    @NSManaged public var monday: Bool
    @NSManaged public var tuesday: Bool
    @NSManaged public var wednesday: Bool
    @NSManaged public var thursday: Bool
    @NSManaged public var friday: Bool
    @NSManaged public var saturday: Bool
    @NSManaged public var matTime: String?
    @NSManaged public var restrictions: Bool
    @NSManaged public var restrictionDescription: String?
    @NSManaged public var op_sunday: Bool
    @NSManaged public var op_monday: Bool
    @NSManaged public var op_tuesday: Bool
    @NSManaged public var op_wednesday: Bool
    @NSManaged public var op_thursday: Bool
    @NSManaged public var op_friday: Bool
    @NSManaged public var op_saturday: Bool
    @NSManaged public var gi: Bool
    @NSManaged public var noGi: Bool
    @NSManaged public var goodForBeginners: Bool
    @NSManaged public var openMat: Bool

    
    public enum DayOfWeek: String, CaseIterable {
        case sunday = "Sunday"
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
    }
}

extension AppDayOfWeek: Identifiable {}
