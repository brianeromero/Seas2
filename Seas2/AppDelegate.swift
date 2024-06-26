//
//  AppDelegate.swift
//  Seas2
//
//  Created by Brian Romero on 6/25/24.
//

import Foundation
import UIKit
import CoreData

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Register CustomUnarchiveTransformer
        ValueTransformer.setValueTransformer(CustomUnarchiveTransformer(), forName: NSValueTransformerName(rawValue: "CustomUnarchiveTransformer"))

        return true
    }

    // Other methods...
}
