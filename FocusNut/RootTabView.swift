import SwiftUI

struct RootTabView: View {
    init() {
        // UITabBar'ı tamamen şeffaf yap
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }

    var body: some View {
        TabView {
            TreeView()
                .tabItem { Label("Tree", systemImage: "leaf.fill") }
            GardenView()
                .tabItem { Label("Garden", systemImage: "tree.fill") }
            MarketView()
                .tabItem { Label("Market", systemImage: "basket.fill") }
            HarvestView()
                .tabItem {
                    Label("Harvest", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
        .tint(.nutGreen)
        // TabView arkasını da şeffaf bırakmak için .background(.clear)
        .background(Color.clear)
    }
}

