//
//  IslandMenu.swift
//  Seas2
//
//  Created by Brian Romero on 6/7/24.
//

import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let subMenuItems: [String]?
}

struct IslandMenu: View {
    let menuItems: [MenuItem] = [
        MenuItem(title: "Add New Gym", subMenuItems: ["Add", "Update"]),
        MenuItem(title: "Find Surrounding Gyms", subMenuItems: ["Near Me (use current location)", "Enter Zip Code"]),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Main Menu")
                .font(.title)
                .bold()
            
            
            ForEach(menuItems) { menuItem in
                VStack(alignment: .leading, spacing: 10) { // Align all menu items to the leading edge
                    Text(menuItem.title)
                        .font(.headline)
                        .padding(.bottom, 0)
                    
                    if let subMenuItems = menuItem.subMenuItems {
                        ForEach(subMenuItems, id: \.self) { subMenuItem in
                            Button(action: {
                                // Handle submenu item action
                                print("Selected: \(subMenuItem)")
                            }) {
                                Text(subMenuItem)
                                    .foregroundColor(.blue)
                            }
                            .padding(.leading, 2)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20) // Add horizontal padding for content
        .navigationBarTitle(
            "Welcome to Island Locator", // Just provide the string directly
            displayMode: .inline
        )
        .padding(.leading, -100) // Adjust leading padding to move content to the left
    }
}

struct IslandMenu_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IslandMenu()
        }
    }
}
