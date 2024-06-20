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
            let islandsNearLocation = try context.fetch(request)
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
    @NSManaged public var daysOfWeek: AppDayOfWeek?
}

extension PirateIsland: Identifiable {}
