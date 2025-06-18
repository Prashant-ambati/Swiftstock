import SwiftUI

struct InventoryListView: View {
    @StateObject var viewModel = InventoryViewModel()
    @State private var showingSmartScan = false
    
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSmartScan = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingSmartScan) {
                SmartScanView(viewModel: viewModel)
            }
        }
    }
}
