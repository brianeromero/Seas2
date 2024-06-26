//
//  AppState.swift
//  Seas2
//
//  Created by Brian Romero on 6/25/24.
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var showWelcomeScreen = true
    @Published var selectedDestination: Destination?
}
