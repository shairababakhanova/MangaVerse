import SwiftUI

struct TabBar: View {
    @State private var showSearchModal: Bool = false
    @State private var selectedTab: Int = 0
    

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MainPage()
            }
            .tabItem {
                Image(systemName: "house")
                Text("Main")
            }
            .tag(0)

            Text("")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)

            // Вкладка "Downloads"
            NavigationStack {
                Text("Downloads View Coming Soon")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .tabItem {
                Image(systemName: "arrow.down")
                Text("Downloads")
            }
            .tag(2)

            // Вкладка "Notifications"
            NavigationStack {
                Text("Notifications View Coming Soon")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            .tabItem {
                Image(systemName: "bell")
                Text("Notifications")
            }
            .tag(3)

            // Вкладка "Profile"
            NavigationStack {
                ProfileView(user: User())
            }
            .tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            .tag(4)
        }
        .tint(.blue)
        .onChange(of: selectedTab) { newTab in
            if newTab == 1 {
                showSearchModal = true
                selectedTab = 0
            }
        }
        .sheet(isPresented: $showSearchModal) {
            SearchModalView(isPresented: $showSearchModal)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}



#Preview {
    TabBar()
}
