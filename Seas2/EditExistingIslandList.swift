import SwiftUI
import CoreData

struct EditExistingIslandList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PirateIsland.entity(), sortDescriptors: []) var islands: FetchedResults<PirateIsland>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(islands) { island in
                    NavigationLink(destination: EditExistingIsland(island: island)) { // Navigate to EditExistingIsland
                        Text(island.islandName ?? "Unnamed Island")
                    }
                }
            }
            .navigationTitle("Edit Existing Gyms")
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
