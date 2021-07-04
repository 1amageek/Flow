
import SwiftUI

// MARK: - AppTabNavigation

struct AppTabNavigation: View {
    @State private var selection: Tab = .menu

    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                ProductMenu()
            }
            .tabItem {
                Label("Menu", systemImage: "list.bullet")
                    .accessibility(label: Text("Menu"))
            }
            .tag(Tab.menu)

        }
    }
}

// MARK: - Tab

extension AppTabNavigation {
    enum Tab {
        case menu
        case favorites
        case rewards
        case recipes
    }
}

// MARK: - Previews

struct AppTabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppTabNavigation()
    }
}
