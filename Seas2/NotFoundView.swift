//
//  NotFoundView.swift
//  Seas2
//
//  Created by Brian Romero on 6/9/24.
//

import Foundation
import SwiftUI

struct NotFoundView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()

            Text("404")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("Page Not Found")
                .font(.title)
                .padding(.top, 10)
            
            Text("Sorry, the page you are looking for does not exist.")
                .font(.body)
                .padding(.top, 5)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
        .navigationTitle("404")
    }
}

struct NotFoundView_Previews: PreviewProvider {
    static var previews: some View {
        NotFoundView()
    }
}
