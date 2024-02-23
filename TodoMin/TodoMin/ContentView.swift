//
//  ContentView.swift
//  TodoMin
//
//  Created by Cevher Şirin on 3.02.2024.
//

import SwiftUI

struct ContentView: View {
    /// Active Tab
    @State private var activeTab: Tab = .home
    var body: some View {
        TabView(selection: $activeTab) {
            Home()
                .tag(Tab.home)
                .tabItem { Tab.home.tabContent }
            
            Charts()
                .tag(Tab.charts)
                .tabItem { Tab.charts.tabContent }
        }
        .tint(appTint)
    }
}

#Preview {
    ContentView()
}
