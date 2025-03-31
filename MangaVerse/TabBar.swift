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
            NavigationStack {
                MainPage()
            }
                .tabItem {
                    Image(systemName: "house")
                    Text("Main")
                }
            NavigationStack {
                MainPage()
            } // тут будет поиск
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            NavigationStack {
                MainPage()
            } // downloads
                .tabItem {
                    Image(systemName: "arrow.down")
                    Text("Downloads")
                }
            NavigationStack {
                MainPage()
            }// Notifications
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            NavigationStack {
                ProfileView(user: User())
            }
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
