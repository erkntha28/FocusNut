import SwiftUI
import SwiftData

struct GardenView: View {
    @Environment(\.modelContext) private var ctx
    @Query private var profileQuery: [PlayerProfile]
    @Query(filter: #Predicate<InventoryItem> { $0.equipped == true }) private var equipped: [InventoryItem]

    @State private var birdX: CGFloat = -140
    @State private var birdOpacity: Double = 0
    @State private var squirrelX: CGFloat = -120
    @State private var wave: CGFloat = 0 // yaprak dalgası

    private var profile: PlayerProfile {
        if let p = profileQuery.first { return p }
        else { let n = PlayerProfile(); ctx.insert(n); return n }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Gökyüzü – gün döngüsü
                LinearGradient(gradient: Gradient(colors: skyColors(for: profile.dayCycleHour)),
                               startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                // Arka plan tepeleri
                Image("bg_hills").resizable().scaledToFill()
                    .opacity(0.45).ignoresSafeArea()

                // Kuş animasyonu
                Text("🦋")
                    .font(.system(size: 34))
                    .opacity(birdOpacity)
                    .offset(x: birdX, y: -140)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) {
                            birdX = 140; birdOpacity = 1
                        }
                    }

                // Sincap (seviye 6+ kilidi)
                if profile.level >= 6 {
                    Image("squirrel").resizable().scaledToFit().frame(width: 90)
                        .offset(x: squirrelX, y: 40)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                                squirrelX = 120
                            }
                        }
                        .onTapGesture {
                            NatureSoundManager.shared.playFX("squirrel_tap.mp3")
                            Haptics.light()
                        }
                }

                VStack(spacing: 16) {
                    Text("My Living Garden").font(.title.bold()).foregroundStyle(.white)

                    // Donatılar
                    if equipped.isEmpty {
                        Text("🌱 Empty but full of potential!")
                            .foregroundStyle(.white.opacity(0.9))
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(equipped) { item in
                                GardenItemCard(item: item)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer()

                    // Saat kaydırıcısı (önizleme)
                    HStack {
                        Image(systemName: "sun.max.fill").foregroundStyle(.yellow)
                        Slider(value: Binding(
                            get: { profile.dayCycleHour },
                            set: {
                                profile.dayCycleHour = $0
                                try? ctx.save()
                                NatureSoundManager.shared.playAmbient(for: $0)
                            }
                        ), in: 0...23, step: 1)
                        Image(systemName: "moon.fill").foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("Garden")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { startDayCycle() }
        }
    }

    private func startDayCycle() {
        // Her 12 saniyede 1 saat ilerlet (önizleme/demo)
        Timer.scheduledTimer(withTimeInterval: 12, repeats: true) { _ in
            profile.dayCycleHour = (profile.dayCycleHour + 1).truncatingRemainder(dividingBy: 24)
            try? ctx.save()
        }
        NatureSoundManager.shared.playAmbient(for: profile.dayCycleHour)
    }

    private func skyColors(for hour: Double) -> [Color] {
        switch hour {
        case 6..<10:  return [.blue.opacity(0.6), .nutLeaf]
        case 10..<17: return [.blue, .nutCream]
        case 17..<20: return [.orange, .nutBrown.opacity(0.6)]
        default:      return [.black, .nutBrown.opacity(0.8)]
        }
    }
}

struct GardenItemCard: View {
    @Environment(\.modelContext) private var ctx
    var item: InventoryItem

    var body: some View {
        VStack(spacing: 8) {
            Image(uiImage: UIImage(named: imageName(for: item.type)) ?? UIImage())
                .resizable().scaledToFit().frame(height: 60)
                .onTapGesture {
                    if item.type == "watering" { NatureSoundManager.shared.waterFX() }
                    if item.type == "lamp" { Haptics.light() }
                }
            Text(item.name).font(.headline).foregroundStyle(.white)
            Text(subtitle(for: item.type)).font(.caption).foregroundStyle(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 16))
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
    private func subtitle(for type: String) -> String {
        switch type {
        case "nest": return "Birds feel at home"
        case "basket": return "Collect more nuts"
        case "watering": return "Keep it fresh"
        case "lamp": return "Warm nights"
        default: return "Decoration"
        }
    }
}
