import SwiftUI
import CoreData

struct EditExistingIslandList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PirateIsland.entity(), sortDescriptors: []) var islands: FetchedResults<PirateIsland>
    
    @State private var searchQuery: String = ""
    @State private var showNoMatchAlert: Bool = false
    
    var filteredIslands: [PirateIsland] {
        if searchQuery.isEmpty {
            return Array(islands)
        } else {
            let lowercasedQuery = searchQuery.lowercased()
            let matchedIslands = islands.filter { island in
                (island.islandName?.lowercased().contains(lowercasedQuery) ?? false) ||
                (island.islandLocation?.lowercased().contains(lowercasedQuery) ?? false) ||
                (island.gymWebsite?.absoluteString.lowercased().contains(lowercasedQuery) ?? false) ||
                (island.latitude?.stringValue.contains(lowercasedQuery) ?? false) ||
                (island.longitude?.stringValue.contains(lowercasedQuery) ?? false)
            }
            DispatchQueue.main.async {
                showNoMatchAlert = matchedIslands.isEmpty && !searchQuery.isEmpty
            }
            return matchedIslands
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Search by: gym name, zip code, or address/location ")
                    .font(.headline)
                    .padding(.bottom, 4)
                    .foregroundColor(.gray)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search...", text: $searchQuery)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8.0)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: searchQuery) { newValue in
                            // Reset showNoMatchAlert when searchQuery changes
                            showNoMatchAlert = false
                        }
                }
                .padding(.bottom, 16)
                
                List {
                    ForEach(filteredIslands) { island in
                        NavigationLink(destination: EditExistingIsland(island: island)) {
                            Text(island.islandName ?? "Unnamed Island")
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Edit Existing Gyms")
                .alert(isPresented: $showNoMatchAlert) {
                    Alert(
                        title: Text("No Match Found"),
                        message: Text("No gyms match your search criteria."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .padding(.horizontal, -20) // Remove extra padding
            }
            .padding()
        }
    }
}

// EditExistingIslandList previews
struct EditExistingIslandList_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        // Example island for preview
        let island = PirateIsland(context: context)
        island.islandName = "Sample Island"
        
        return NavigationView {
            EditExistingIslandList()
                .environment(\.managedObjectContext, context)
        }
    }
}
