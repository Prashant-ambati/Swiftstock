import SwiftUI

struct InventoryListView: View {
    @StateObject var viewModel = InventoryViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.items) { item in
                NavigationLink(destination: ItemDetailView(item: item)) {
                    VStack(alignment: .leading) {
                        Text(item.name).font(.headline)
                        Text(item.category.rawValue.capitalized).font(.subheadline).foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("My Inventory")
        }
    }
}
