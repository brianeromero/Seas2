//  PirateIsland+CoreDataProperties.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//

import Foundation
import CoreData
import CoreLocation
import MapKit

extension PirateIsland {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PirateIsland> {
        return NSFetchRequest<PirateIsland>(entityName: "PirateIsland")
    }

    static func fetchIslandsNear(location: CLLocationCoordinate2D, within distance: CLLocationDistance, in context: NSManagedObjectContext) -> [PirateIsland] {
        let request: NSFetchRequest<PirateIsland> = PirateIsland.fetchRequest()
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: distance, longitudinalMeters: distance)
        let minLatitude = region.center.latitude - region.span.latitudeDelta / 2.0
        let maxLatitude = region.center.latitude + region.span.latitudeDelta / 2.0
        let minLongitude = region.center.longitude - region.span.longitudeDelta / 2.0
        let maxLongitude = region.center.longitude + region.span.longitudeDelta / 2.0
        
        let predicate = NSPredicate(format: "latitude BETWEEN {%@, %@} AND longitude BETWEEN {%@, %@}", argumentArray: [minLatitude, maxLatitude, minLongitude, maxLongitude])
        
        request.predicate = predicate
        
        do {
            print("Fetching islands with predicate: \(predicate)")
            let islandsNearLocation = try context.fetch(request)
            print("Found \(islandsNearLocation.count) islands near location")
            return islandsNearLocation
        } catch {
            print("Error fetching islands: \(error.localizedDescription)")
            return []
        }
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var creationDate: Date?
    @NSManaged public var enteredBy: String?
    @NSManaged public var islandLocation: String?
    @NSManaged public var islandName: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber?
    @NSManaged public var gymWebsite: URL?

    // Relationship to AppDayOfWeek
    @NSManaged public var daysOfWeek: NSSet?
}

// MARK: Generated accessors for appDayOfWeeks
extension PirateIsland {

    @objc(addAppDayOfWeeksObject:)
    @NSManaged public func addToAppDayOfWeeks(_ value: AppDayOfWeek)

    @objc(removeAppDayOfWeeksObject:)
    @NSManaged public func removeFromAppDayOfWeeks(_ value: AppDayOfWeek)

    @objc(addAppDayOfWeeks:)
    @NSManaged public func addToAppDayOfWeeks(_ values: NSSet)

    @objc(removeAppDayOfWeeks:)
    @NSManaged public func removeFromAppDayOfWeeks(_ values: NSSet)
}

extension PirateIsland: Identifiable {}
