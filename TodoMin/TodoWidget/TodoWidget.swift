//
//  TodoWidget.swift
//  TodoWidget
//
//  Created by Cevher Şirin on 4.02.2024.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TodoWidgetEntryView : View {
    var entry: Provider.Entry
    /// Query that will fetch only three active todo at a time
    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo]
    var body: some View {
        VStack {
            ForEach(activeList) { todo in
                HStack(spacing: 10) {
                    /// Intent Action Button
                    Button(intent: ToggleButton(id: todo.taskID)) {
                        Image(systemName: "circle")
                    }
                    .font(.callout)
                    .tint(todo.priority.color.gradient)
                    .buttonBorderShape(.circle)
                    
                    Text(todo.task)
                        .font(.footnote)
                        .lineLimit(2)
                    Spacer(minLength: 0)
                }
                .transition(.push(from: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if activeList.isEmpty {
                Text("No Tasks 🎉")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { !$0.isCompleted }
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
}

struct TodoWidget: Widget {
    let kind: String = "Todo List"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            /// Setting up SwiftData Container
                .modelContainer(for: Todo.self)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Tasks")
        .description("This is a Todo List")
    }
}

#Preview(as: .systemSmall) {
    TodoWidget()
} timeline: {
    SimpleEntry(date: .now)
}

/// Button Intent Which Will Update the todo status
struct ToggleButton: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's Todo State")
    
    @Parameter(title: "Todo ID")
    var id: String
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        /// Updating Todo Status
        let context = try ModelContext(.init(for: Todo.self))
        /// Retreiving Respective Todo
        let descriptor = FetchDescriptor(predicate: #Predicate<Todo> { $0.taskID == id })
        if let todo = try context.fetch(descriptor).first {
            todo.isCompleted = true
            todo.lastUpdated = .now
            /// Saving Context
            try context.save()
        }
        return .result()
    }
}
