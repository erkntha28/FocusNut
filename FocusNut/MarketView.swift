import SwiftUI
import SwiftData

struct MarketView: View {
    @Environment(\.modelContext) private var ctx
    @Query private var profileQuery: [PlayerProfile]
    @Query private var items: [InventoryItem]

    private var profile: PlayerProfile {
        if let p = profileQuery.first { return p }
        else { let n = PlayerProfile(); ctx.insert(n); return n }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("🌰 \(profile.nuts) nuts").font(.title3.bold()).padding(.top, 8)
                List {
                    Section("Garden Items") {
                        ForEach(items) { item in
                            HStack(spacing: 12) {
                                Image(imageName(for: item.type)).resizable().scaledToFit().frame(width: 36, height: 36)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name).font(.headline)
                                    Text("Requires Lv.\(item.minLevel)").font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()

                                if profile.level < item.minLevel {
                                    Text("Locked").foregroundStyle(.gray)
                                } else if item.owned {
                                    Button(item.equipped ? "Equipped" : "Equip") { equip(item) }
                                        .buttonStyle(.bordered).tint(item.equipped ? .green : .nutGreen)
                                } else {
                                    Button("Buy \(item.price)🌰") { buy(item) }
                                        .buttonStyle(.borderedProminent).tint(.nutGreen)
                                        .disabled(profile.nuts < item.price)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Market")
            .background(Color("nutCream"))
            .onAppear { seedIfNeeded() }
        }
    }

    private func buy(_ item: InventoryItem) {
        guard profile.level >= item.minLevel, !item.owned, profile.nuts >= item.price else { return }
        profile.nuts -= item.price
        item.owned = true
        try? ctx.save()
        Haptics.light()
    }

    private func equip(_ item: InventoryItem) {
        items.filter { $0.type == item.type }.forEach { $0.equipped = false }
        item.equipped = true
        try? ctx.save()
        Haptics.success()
    }

    private func seedIfNeeded() {
        if items.isEmpty {
            [
                InventoryItem(name: "Bird Nest",       price: 20, type: "nest",     minLevel: 2),
                InventoryItem(name: "Hazelnut Basket", price: 30, type: "basket",   minLevel: 3),
                InventoryItem(name: "Watering Can",    price: 25, type: "watering", minLevel: 4),
                InventoryItem(name: "Garden Lamp",     price: 40, type: "lamp",     minLevel: 5)
            ].forEach { ctx.insert($0) }
            try? ctx.save()
        }
    }

    private func imageName(for type: String) -> String {
        switch type {
        case "nest": return "nest"
        case "basket": return "basket"
        case "watering": return "watering"
        case "lamp": return "lamp"
        default: return "nest"
        }
    }
}
