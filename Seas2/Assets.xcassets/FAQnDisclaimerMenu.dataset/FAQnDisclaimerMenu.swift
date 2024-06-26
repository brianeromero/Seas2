//
//  FAQnDisclaimerMenuView.swift
//  Seas2
//
//  Created by Brian Romero on 6/18/24.
//

import SwiftUI

class FAQnDisclaimerMenu: ObservableObject {
    enum MenuItem {
        case whoWeAre
        case disclaimer
        case faq
    }
    
    @Published var selectedItem: MenuItem? = nil
    
    var contentView: some View {
        switch selectedItem {
        case .whoWeAre:
            return AnyView(WhoWeAreView())
        case .disclaimer:
            return AnyView(DisclaimerView())
        case .faq:
            return AnyView(FAQView())
        case .none:
            return AnyView(EmptyView())
        }
    }
}

struct FAQnDisclaimerMenuView: View {
    @ObservedObject var menu = FAQnDisclaimerMenu()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    NavigationLink(
                        destination: WhoWeAreView(),
                        tag: .whoWeAre,
                        selection: $menu.selectedItem
                    ) {
                        HStack {
                            Image("MF_little")                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                            Text("Who We Are")
                        }
                    }
                    
                    NavigationLink(
                        destination: DisclaimerView(),
                        tag: .disclaimer,
                        selection: $menu.selectedItem
                    ) {
                        HStack {
                            Image("disclaimer_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                            Text("Disclaimer")
                        }
                    }
                    
                    NavigationLink(
                        destination: FAQView(),
                        tag: .faq,
                        selection: $menu.selectedItem
                    ) {
                        HStack {
                            Image("MF_little_trans")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                            Text("FAQ")
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                Spacer()
                
                menu.contentView
                    .padding(.horizontal)
            }
            .navigationTitle("FAQ and Disclaimer")
        }
    }
}

struct FAQnDisclaimerMenuView_Previews: PreviewProvider {
    static var previews: some View {
        FAQnDisclaimerMenuView()
    }
}
