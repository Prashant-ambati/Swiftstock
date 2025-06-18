import Foundation

struct Item: Identifiable {
    let id: UUID
    var name: String
    var category: Category
    var imageName: String?
    var lastUsed: Date
    var createdAt: Date
    var resaleValue: Double?
}
