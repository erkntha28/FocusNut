import Foundation
import SwiftData

@Model
final class FocusSession {
    @Attribute(.unique) var id: UUID
    var startedAt: Date
    var endedAt: Date?
    var durationSec: Int
    var xpEarned: Int
    var nutsEarned: Int
    var tag: String?

    init(startedAt: Date = .now, endedAt: Date? = nil, durationSec: Int = 0, xpEarned: Int = 0, nutsEarned: Int = 0, tag: String? = nil) {
        self.id = UUID()
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.durationSec = durationSec
        self.xpEarned = xpEarned
        self.nutsEarned = nutsEarned
        self.tag = tag
    }
}

@Model
final class InventoryItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var price: Int
    var type: String   // "nest","basket","watering","lamp"
    var owned: Bool
    var equipped: Bool
    var minLevel: Int  // kilit seviyesi

    init(name: String, price: Int, type: String, minLevel: Int, owned: Bool = false, equipped: Bool = false) {
        self.id = UUID()
        self.name = name
        self.price = price
        self.type = type
        self.minLevel = minLevel
        self.owned = owned
        self.equipped = equipped
    }
}

@Model
final class PlayerProfile {
    @Attribute(.unique) var id: UUID
    var xp: Int
    var nuts: Int
    var level: Int
    var dayCycleHour: Double // görsel gün döngüsü

    init(xp: Int = 0, nuts: Int = 0, level: Int = 1, dayCycleHour: Double = Double(Calendar.current.component(.hour, from: .now))) {
        self.id = UUID()
        self.xp = xp
        self.nuts = nuts
        self.level = level
        self.dayCycleHour = dayCycleHour
    }
}
