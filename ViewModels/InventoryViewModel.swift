import Foundation
import CoreData

class InventoryViewModel: ObservableObject {
    @Published var items: [Item] = []
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
        fetchItems()
    }
    
    func fetchItems() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Item")
        do {
            let results = try context.fetch(request)
            self.items = results.compactMap { obj in
                guard let id = obj.value(forKey: "id") as? UUID,
                      let name = obj.value(forKey: "name") as? String,
                      let categoryRaw = obj.value(forKey: "category") as? String,
                      let category = Category(rawValue: categoryRaw),
                      let lastUsed = obj.value(forKey: "lastUsed") as? Date,
                      let createdAt = obj.value(forKey: "createdAt") as? Date else { return nil }
                let imageName = obj.value(forKey: "imageName") as? String
                let resaleValue = obj.value(forKey: "resaleValue") as? Double
                return Item(id: id, name: name, category: category, imageName: imageName, lastUsed: lastUsed, createdAt: createdAt, resaleValue: resaleValue)
            }
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
    
    func addItem(_ item: Item) {
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!
        let obj = NSManagedObject(entity: entity, insertInto: context)
        obj.setValue(item.id, forKey: "id")
        obj.setValue(item.name, forKey: "name")
        obj.setValue(item.category.rawValue, forKey: "category")
        obj.setValue(item.imageName, forKey: "imageName")
        obj.setValue(item.lastUsed, forKey: "lastUsed")
        obj.setValue(item.createdAt, forKey: "createdAt")
        obj.setValue(item.resaleValue, forKey: "resaleValue")
        save()
        fetchItems()
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
