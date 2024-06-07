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

class AppState: ObservableObject {
    @Published var showWelcomeScreen = true
    @Published var selectedDestination: Destination?
}


@main
struct Seas2App: App {
    let persistenceController = PersistenceController.shared
    
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
                    ContentView() // Remove selectedDestination parameter
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(appState) // Inject AppState as environment object
                }
            }
        }
    }
}
