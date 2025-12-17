import Foundation

enum Rewards {
    static func growthXP(forSeconds s: Int) -> Int { max(0, Int(Double(s)/60 * 10)) }
    static func nuts(forSeconds s: Int) -> Int { max(0, Int(Double(s)/60 * 2)) }

    static func level(forXP xp: Int) -> Int {
        var lvl = 1
        while xp >= lvl * lvl * 100 { lvl += 1 }
        return lvl
    }

    // bonus: tam 25/50/75 dk → %50 XP boost
    static func bonusMultiplier(forSeconds s: Int) -> Double {
        let m = s/60
        return [25,50,75].contains(m) ? 1.5 : 1.0
    }
}
