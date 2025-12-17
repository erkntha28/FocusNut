import SwiftUI
import SwiftData

struct HarvestView: View {
    @Query(sort: \FocusSession.startedAt, order: .reverse) private var sessions: [FocusSession]

    var totalMinutes: Int { sessions.reduce(0) { $0 + $1.durationSec } / 60 }
    var totalNuts: Int { sessions.reduce(0) { $0 + $1.nutsEarned } }

    var body: some View {
        NavigationStack {
            List {
                Section("Summary") {
                    HStack { Text("Total Focus"); Spacer(); Text("\(totalMinutes) min").foregroundStyle(.secondary) }
                    HStack { Text("Total Nuts");  Spacer(); Text("\(totalNuts) 🌰").foregroundStyle(.secondary) }
                    HStack { Text("Sessions");    Spacer(); Text("\(sessions.count)").foregroundStyle(.secondary) }
                }
                Section("Recent") {
                    ForEach(sessions.prefix(10)) { s in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(s.startedAt.formatted(date: .abbreviated, time: .shortened)).font(.subheadline)
                            Text("⏱ \(s.durationSec/60) min • +\(s.nutsEarned) 🌰 • +\(s.xpEarned) XP • #\(s.tag ?? "-")")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Harvest")
            .background(Color("nutCream"))
        }
    }
}
