//
//  SwiftUIView.swift
//  TodoMin
//
//  Created by Cevher Şirin on 3.02.2024.
//

import SwiftUI
import SwiftData

@Model
class Todo {
    private(set) var taskID: String = UUID().uuidString
    var task: String
    var isCompleted: Bool = false
    var priority: Priorty = Priorty.normal
    var lastUpdated: Date = Date.now
    
    init( task: String, priority: Priorty) {
        self.task = task
        self.priority = priority
    }
}


/// Priorty Status
enum Priorty: String, Codable, CaseIterable {
    case normal = "Normal"
    case medium = "Medium"
    case heigh = "Height"
    
    /// Priority Color
    var color: Color {
        switch self {
        case .normal:
            return normalPriorityColor
        case .medium:
            return mediumPriorityColor
        case .heigh:
            return heighPriorityColor
        }
    }
}
