import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [FamilyrecipeboxItem] = []
    @Published var isProUnlocked: Bool = false

    /// Free tier allows up to this many saved items. Kept well above seed
    /// count so a fresh install never opens straight into the paywall.
    static let freeItemLimit = 20

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let dir = support.appendingPathComponent("Familyrecipebox", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("items.json")
        load()
    }

    var canAddMore: Bool {
        isProUnlocked || items.count < Store.freeItemLimit
    }

    func add(title: String, detail: String, date: Date = Date()) {
        guard canAddMore else { return }
        items.insert(FamilyrecipeboxItem(title: title, detail: detail, date: date), at: 0)
        save()
    }

    func update(_ item: FamilyrecipeboxItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: FamilyrecipeboxItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func seedIfNeeded() -> [FamilyrecipeboxItem] {
        [
            FamilyrecipeboxItem(title: "Recipe One", detail: "Sample entry"),
            FamilyrecipeboxItem(title: "Recipe Two", detail: "Sample entry"),
            FamilyrecipeboxItem(title: "Recipe Three", detail: "Sample entry"),
        ]
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([FamilyrecipeboxItem].self, from: data) else {
            items = seedIfNeeded()
            save()
            return
        }
        items = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
