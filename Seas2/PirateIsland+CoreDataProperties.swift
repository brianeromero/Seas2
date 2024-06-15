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
    // This should return NSFetchRequest<PirateIsland>
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PirateIsland> {
        return NSFetchRequest<PirateIsland>(entityName: "PirateIsland")
    }

    // Function to fetch islands near the given location
    static func fetchIslandsNear(location: CLLocationCoordinate2D, within distance: CLLocationDistance, in context: NSManagedObjectContext) -> [PirateIsland] {
        // Create a fetch request for PirateIsland entities
        let request: NSFetchRequest<PirateIsland> = PirateIsland.fetchRequest()
        
        // Calculate the bounding box for the given location and distance
        let region = MKCoordinateRegion(center: location, latitudinalMeters: distance, longitudinalMeters: distance) // MKCoordinateRegion is from MapKit
        let minLatitude = region.center.latitude - region.span.latitudeDelta / 2.0
        let maxLatitude = region.center.latitude + region.span.latitudeDelta / 2.0
        let minLongitude = region.center.longitude - region.span.longitudeDelta / 2.0
        let maxLongitude = region.center.longitude + region.span.longitudeDelta / 2.0
        
        // Create predicates to filter islands within the bounding box
        let predicate = NSPredicate(format: "latitude BETWEEN {%@, %@} AND longitude BETWEEN {%@, %@}", argumentArray: [minLatitude, maxLatitude, minLongitude, maxLongitude])
        
        // Set the predicate to the fetch request
        request.predicate = predicate
        
        // Perform the fetch
        do {
            let islandsNearLocation = try context.fetch(request)
            return islandsNearLocation
        } catch {
            print("Error fetching islands: \(error.localizedDescription)")
            return []
        }
    }
    
    // Managed properties
    @NSManaged public var timestamp: Date?
    @NSManaged public var creationDate: Date?
    @NSManaged public var enteredBy: String?
    @NSManaged public var islandLocation: String?
    @NSManaged public var islandName: String?
    @NSManaged public var latitude: NSNumber?
    @NSManaged public var longitude: NSNumber? // Use NSNumber for Objective-C compatibility
    @NSManaged public var gymWebsite: URL?
}

extension PirateIsland: Identifiable {

}
