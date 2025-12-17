import SwiftUI
import SwiftData

struct TreeView: View {
    @Environment(\.modelContext) private var ctx
    @Environment(\.colorScheme) private var colorScheme
    @Query private var profileQuery: [PlayerProfile]
    @State private var minutes = 25
    @State private var showTimer = false
    @State private var tag = "Work"

    private var profile: PlayerProfile {
        if let p = profileQuery.first { return p }
        else { let n = PlayerProfile(); ctx.insert(n); return n }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Your Hazel Tree")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.nutGreen.opacity(0.7), .nutLeaf.opacity(0.5)], startPoint: .top, endPoint: .bottom))
                        .frame(width: 180, height: 180)
                        .shadow(radius: 10)
                    Text(treeEmoji(for: profile.level))
                        .font(.system(size: 64))
                        .foregroundStyle(.primary)
                }

                Picker("Tag", selection: $tag) {
                    Text("Work").tag("Work")
                    Text("Study").tag("Study")
                    Text("Code").tag("Code")
                    Text("Read").tag("Read")
                }
                .pickerStyle(.segmented)

                Stepper("Focus: \(minutes) min", value: $minutes, in: 5...120, step: 5)
                    .labelsHidden()

                Button {
                    showTimer = true
                } label: {
                    Text("Start Growing 🌰")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("nutGreen"))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .cornerRadius(16)
                }

                Text("Level \(profile.level) • \(profile.xp) XP • \(profile.nuts) 🌰")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            // Dinamik sistem arka planı: açıkta beyaz/kremsi, koyuda siyah/çok koyu gri
            .background(Color(.systemBackground))
            .sheet(isPresented: $showTimer) {
                TimerView(targetSeconds: minutes * 60, tag: tag)
            }
        }
    }

    private func treeEmoji(for level: Int) -> String {
        switch level {
        case 1..<3:  return "🌱"
        case 3..<6:  return "🌿"
        case 6..<10: return "🌳"
        default:     return "🌲"
        }
    }
}
