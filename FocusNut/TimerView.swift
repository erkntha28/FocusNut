import SwiftUI
import Combine
import SwiftData

struct TimerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var ctx
    @Environment(\.colorScheme) private var colorScheme
    @Query private var profileQuery: [PlayerProfile]

    let targetSeconds: Int
    let tag: String
    @State private var remaining: Int
    @State private var timer: AnyCancellable?

    init(targetSeconds: Int, tag: String) {
        self.targetSeconds = targetSeconds
        self.tag = tag
        _remaining = State(initialValue: targetSeconds)
    }

    private var profile: PlayerProfile {
        if let p = profileQuery.first { return p }
        else { let n = PlayerProfile(); ctx.insert(n); return n }
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Focus Time").font(.title.bold())
            Text(timeString(remaining))
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .monospacedDigit()

            HStack(spacing: 24) {
                Button("Start") { startTimer() }
                Button("Pause") { timer?.cancel(); Haptics.light() }
                Button("Finish") { finish() }
            }
            .buttonStyle(.borderedProminent).tint(.nutGreen)
            Spacer()
        }
        .padding()
        .background(Color("nutCream"))
        .foregroundColor(colorScheme == .dark ? .white : .black)
        .onAppear { NatureSoundManager.shared.playAmbient(for: profile.dayCycleHour) }
        .onDisappear { NatureSoundManager.shared.stopAmbient() }
    }

    private func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in tick() }
        Haptics.light()
    }

    private func tick() {
        if remaining > 0 { remaining -= 1 } else { finish() }
    }

    private func finish() {
        timer?.cancel()
        let focusedSec = targetSeconds - remaining
        let mult = Rewards.bonusMultiplier(forSeconds: focusedSec)
        let xp = Int(Double(Rewards.growthXP(forSeconds: focusedSec)) * mult)
        let nuts = Int(Double(Rewards.nuts(forSeconds: focusedSec)) * mult)

        profile.xp += xp
        profile.nuts += nuts
        profile.level = Rewards.level(forXP: profile.xp)
        ctx.insert(FocusSession(startedAt: .now.addingTimeInterval(-Double(focusedSec)),
                                endedAt: .now, durationSec: focusedSec,
                                xpEarned: xp, nutsEarned: nuts, tag: tag))
        try? ctx.save()

        NatureSoundManager.shared.focusEndFX()
        Haptics.success()
        dismiss()
    }

    private func timeString(_ s: Int) -> String {
        String(format: "%02d:%02d", s/60, s%60)
    }
}
