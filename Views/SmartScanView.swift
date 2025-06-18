import SwiftUI
import PhotosUI

struct SmartScanView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: InventoryViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var image: UIImage? = nil
    @State private var classification: Category? = nil
    @State private var itemName: String = ""
    @State private var isSaving = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(Text("Tap to select photo").foregroundColor(.gray))
                        .onTapGesture { showPhotoPicker() }
                }
                if let classification = classification {
                    Text("Detected: \(classification.rawValue.capitalized)")
                        .font(.headline)
                }
                TextField("Item Name", text: $itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button("Classify Image") {
                    classifyImage()
                }.disabled(image == nil)
                Button("Add to Inventory") {
                    saveItem()
                }
                .disabled(itemName.isEmpty || image == nil)
                .padding()
                Spacer()
            }
            .navigationTitle("Smart Scan")
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { presentationMode.wrappedValue.dismiss() } } }
            .photosPicker(isPresented: $showingPhotoPicker, selection: $selectedItem)
            .onChange(of: selectedItem) { newItem in
                loadImage(from: newItem)
            }
        }
    }
    
    @State private var showingPhotoPicker = false
    private func showPhotoPicker() { showingPhotoPicker = true }
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let uiImage = UIImage(data: data) {
                    self.image = uiImage
                }
            default: break
            }
        }
    }
    private func classifyImage() {
        guard let image = image, let data = image.jpegData(compressionQuality: 0.8) else { return }
        // Placeholder: Use ImageClassifier
        self.classification = ImageClassifier().classify(imageData: data)
        if let category = classification {
            self.itemName = category.rawValue.capitalized
        }
    }
    private func saveItem() {
        guard let image = image else { return }
        let newItem = Item(
            id: UUID(),
            name: itemName,
            category: classification ?? .other,
            imageName: nil, // Image storage not implemented yet
            lastUsed: Date(),
            createdAt: Date(),
            resaleValue: nil
        )
        viewModel.addItem(newItem)
        presentationMode.wrappedValue.dismiss()
    }
} 