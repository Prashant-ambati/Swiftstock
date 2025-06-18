import Foundation

enum Category: String, CaseIterable, Identifiable {
    case clothing, electronics, gadgets, furniture, other
    var id: String { self.rawValue }
}
