import SwiftUI

@main
struct SwiftStockApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            InventoryListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
