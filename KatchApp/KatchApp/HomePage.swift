//
//  HomePage.swift
//  KatchApp
//
//  Created by Andres Acuna on 8/12/24.
//
import SwiftUI

struct HomePage: View {
    @Binding var isLoggedIn: Bool
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EventListView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            GroupsView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Groups")
                }
                .tag(1)
            
            ProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(2)
        }
    }
}
