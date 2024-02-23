//
//  TodoRowView.swift
//  TodoMin
//
//  Created by Cevher Şirin on 3.02.2024.
//

import SwiftUI
import WidgetKit

struct TodoRowView: View {
    @Bindable var todo: Todo
    @State var shouldReloadWidget: Bool
    /// View Properties
    @FocusState private var isActive: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var phase
    var body: some View {
        HStack() {
            if !isActive && !todo.task.isEmpty {
                Button(action: {
                    todo.isCompleted.toggle()
                    todo.lastUpdated = .now
                    WidgetCenter.shared.reloadAllTimelines()
                }, label: {
                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.isCompleted ? .gray : .accentColor)
                        .contentTransition(.symbolEffect(.replace))
                })
            }
            
            Spacer(minLength: 8)
            
            TextField("Enter the task", text: $todo.task)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .gray : Color(uiColor: .activeTodoText))
                .focused($isActive)
                .background(
                        ZStack{
                        Color.white
                            if todo.task.count == 0 {
                                HStack {
                                    Text("Enter the task")
                                    .font(.headline)
                                        .foregroundColor(.gray)
                                    Spacer()
                              }
                             .frame(maxWidth: .infinity)
                            }
                        }
                    )
            
            Spacer(minLength: 8)
            
            if !isActive && !todo.task.isEmpty {
                /// Priority Menu Button (For Updating)
                Menu {
                    ForEach(Priorty.allCases, id: \.rawValue) { priority in
                        Button(action: { todo.priority = priority }, label: {
                            HStack {
                                Text(priority.rawValue)
                                
                                if todo.priority == priority  { Image(systemName: "checkmark") }
                            }
                        })
                    }
                } label: {
                    Image(systemName: "circle.fill")
                        .font(.title2)
                        .padding(3)
                        .contentShape(.rect)
                        .foregroundStyle(todo.priority.color.gradient)
                }
            }
        }
        .frame(height: 40)
        .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
        .animation(.snappy, value: isActive)
        .onAppear{
            isActive = todo.task.isEmpty
        }
        /// Swipe to Delete
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("", systemImage: "trash") {
                context.delete(todo)
                WidgetCenter.shared.reloadAllTimelines()
            }
            .tint(.red)
        }
        .onSubmit(of: .text) {
            if todo.task.isEmpty {
                /// Deleting Empty Todo
                context.delete(todo)
            }
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && todo.task.isEmpty {
                context.delete(todo)
            }
            if newValue == .inactive && shouldReloadWidget {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .task {
            todo.isCompleted = todo.isCompleted
        }
    }
}

#Preview {
    ContentView()
}
