import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            // Arka plan açık/koyu moda göre
            (colorScheme == .dark ? Color.black : Color.white)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Fındık Ağacım")
                            .font(.largeTitle.bold())
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Text("Odaklanarak ağacını büyüt! Her oturumda doğanın gücü seninle.")
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
                            .font(.body)
                        
                        Image(systemName: "tree.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                            .foregroundColor(colorScheme == .dark ? .green.opacity(0.7) : .green)
                            .padding(.vertical, 30)
                        
                        // "Start Growing" butonu
                        Button(action: {
                            print("Start Growing tapped!")
                        }) {
                            Text("Start Growing")
                                .font(.headline.bold())
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05))
                                )
                        }
                        .padding(.horizontal, 20)
                        .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .padding()
                }
                
                Spacer()
                
                // Şeffaf alt sekme çubuğu
                HStack {
                    TabButton(icon: "leaf.fill", label: "Odak", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    
                    Spacer()
                    
                    TabButton(icon: "clock.fill", label: "Geçmiş", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    
                    Spacer()
                    
                    TabButton(icon: "gearshape.fill", label: "Ayarlar", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                }
                .padding()
                .background(.ultraThinMaterial) // şeffaf efekt
                .cornerRadius(25)
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
            }
        }
    }
}

// Alt çubuk butonları
struct TabButton: View {
    var icon: String
    var label: String
    var isSelected: Bool
    var action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(label)
                    .font(.caption)
            }
            .foregroundColor(isSelected
                             ? (colorScheme == .dark ? .white : .black)
                             : (colorScheme == .dark ? .white.opacity(0.6) : .black.opacity(0.6)))
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.clear)
        }
    }
}

#Preview {
    ContentView()
}
