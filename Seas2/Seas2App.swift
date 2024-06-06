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
    
    @State private var selectedDestination: Destination?
    @State private var showWelcomeScreen = true

    
    var body: some Scene {
        WindowGroup {
            Group {
                if showWelcomeScreen {
                    PirateIslandView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                showWelcomeScreen = false
                            }
                        }
                } else {
                    ContentView(selectedDestination: $selectedDestination)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
        }
    }
}
