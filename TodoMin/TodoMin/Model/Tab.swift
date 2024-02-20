//
//  Tab.swift
//  TodoMin
//
//  Created by Cevher Şirin on 20.02.2024.
//

import SwiftUI

enum Tab: String {
    case home = "Home"
    case charts = "Charts"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .home:
            Image(systemName: "house")
            Text(self.rawValue)
        case .charts:
            Image(systemName: "chart.bar.xaxis")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)
        }
    }
}
