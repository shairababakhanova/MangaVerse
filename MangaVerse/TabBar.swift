//
//  TabBar.swift
//  MangaVerse
//
//  Created by Бабаханова Шаира on 28.03.2025.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            MainPage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Main")
                }
            MainPage() // тут будет поиск
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            MainPage() // downloads
                .tabItem {
                    Image(systemName: "arrow.down")
                    Text("Downloads")
                }
            MainPage() // Notifications
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            ProfileView(user: User())
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }.accentColor(.blue)
    }
}

#Preview {
    TabBar()
}
