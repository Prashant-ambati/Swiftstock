import SwiftUI

struct ItemDetailView: View {
    let item: Item
    
    var body: some View {
        VStack(spacing: 20) {
            if let imageName = item.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .overlay(Text("No Image").foregroundColor(.gray))
            }
            Text(item.name).font(.largeTitle)
            Text(item.category.rawValue.capitalized).font(.title2)
            if let value = item.resaleValue {
                Text("Resale Value: $\(value, specifier: "%.2f")")
            }
            Text("Last Used: \(item.lastUsed, formatter: dateFormatter)")
            Spacer()
        }
        .padding()
        .navigationTitle(item.name)
    }
}

private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    return df
}()
