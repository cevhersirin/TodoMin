//
//  TodoMinApp.swift
//  TodoMin
//
//  Created by Cevher Şirin on 3.02.2024.
//

import SwiftUI

@main
struct TodoMinApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Todo.self)
    }
}
