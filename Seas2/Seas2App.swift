//
//  Seas2App.swift
//  Seas2
//
//  Created by Brian Romero on 6/5/24.
//

import Foundation
import SwiftUI
import CoreData
import Combine

@main
struct Seas2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // Link to your AppDelegate

    private let persistenceController = PersistenceController.shared
    @StateObject var appState = AppState() // Use @StateObject for AppState

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.showWelcomeScreen {
                    PirateIslandView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                appState.showWelcomeScreen = false
                            }
                        }
                } else {
                    IslandMenu() // Use IslandMenu as the main view
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(appState) // Inject AppState as environment object
                        .onAppear {
                            let sceneLoader = SceneLoader()
                            sceneLoader.loadScene()
                        }
                }
            }
            .onAppear {
                // Perform any UIKit-related setup here if necessary
                // For example:
                // UIApplication.shared.applicationIconBadgeNumber = 0
            }
        }
    }
}
