//
//  PirateIsland+CoreDataProperties.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//
//


import Foundation
import SwiftUI
import CoreData
import Combine

extension PirateIsland {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PirateIsland> {
        return NSFetchRequest<PirateIsland>(entityName: "PirateIsland")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var creationDate: Date?
    @NSManaged public var enteredBy: String?
    @NSManaged public var islandLocation: String?
    @NSManaged public var islandName: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var gymWebsite: URL?
}

extension PirateIsland : Identifiable {

}
