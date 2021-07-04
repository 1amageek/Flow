
import SwiftUI

struct AppSidebarNavigation: View {

    enum NavigationItem {
        case menu
    }

    @EnvironmentObject private var model: Model
    @State private var selection: NavigationItem? = .menu
    @State private var presentingRewards = false
    
    var sidebar: some View {
        List(selection: $selection) {
            NavigationLink(destination: ProductMenu(), tag: NavigationItem.menu, selection: $selection) {
                Label("Menu", systemImage: "list.bullet")
            }
            .tag(NavigationItem.menu)
        }
        .overlay(Pocket(presentingRewards: $presentingRewards), alignment: .bottom)
        .listStyle(SidebarListStyle())
    }
    
    var body: some View {
        NavigationView {
            sidebar
            
            Text("Select a category")
                .foregroundColor(.secondary)
            
            Text("Select a smoothie")
                .foregroundColor(.secondary)
        }
    }
    
    struct Pocket: View {
        @Binding var presentingRewards: Bool
        
        @EnvironmentObject private var model: Model
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Divider()
                Button(action: { presentingRewards = true }) {
                    Label("Rewards", systemImage: "seal")
                        .padding(6)
                        .contentShape(Rectangle())
                }
                .accessibility(label: Text("Rewards"))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .buttonStyle(PlainButtonStyle())
            }
//            .sheet(isPresented: $presentingRewards) {
//                #if os(iOS)
//                RewardsView()
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            Button(action: { presentingRewards = false }) {
//                                Text("Done")
//                            }
//                        }
//                    }
//                    .environmentObject(model)
//                #else
//                VStack(spacing: 0) {
//                    RewardsView()
//                    Divider()
//                    HStack {
//                        Spacer()
//                        Button(action: { presentingRewards = false }) {
//                            Text("Done")
//                        }
//                        .keyboardShortcut(.defaultAction)
//                    }
//                    .padding()
//                    .background(VisualEffectBlur())
//                }
//                .frame(minWidth: 400, maxWidth: 600, minHeight: 400, maxHeight: 600)
//                .environmentObject(model)
//                #endif
//            }
        }
    }
}

struct AppSidebarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation()
            .environmentObject(Model())
    }
}

struct AppSidebarNavigation_Pocket_Previews: PreviewProvider {
    static var previews: some View {
        AppSidebarNavigation.Pocket(presentingRewards: .constant(false))
            .environmentObject(Model())
            .frame(width: 300)
    }
}
