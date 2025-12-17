import SwiftUI
import SwiftData

@main
struct FocusNutApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: [FocusSession.self, InventoryItem.self, PlayerProfile.self])
    }
}
