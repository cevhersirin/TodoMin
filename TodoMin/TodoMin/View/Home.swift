//
//  Home.swift
//  TodoMin
//
//  Created by Cevher Şirin on 3.02.2024.
//

import SwiftUI
import SwiftData


struct Home: View {
    /// Actiive Todo's
    @Query(filter: #Predicate<Todo> { !$0.isCompleted }, sort: [SortDescriptor(\Todo.lastUpdated, order: .reverse)], animation: .snappy) private var activeList: [Todo]
    /// Model Context
    @Environment(\.modelContext) private var context
    /// Detect Color Scheme
    @Environment(\.colorScheme) var colorScheme
    
    var rowBackgroundColor: Color {
        return colorScheme == .dark ? .white : .white
    }
    
    var rowShadowColor: Color {
        return colorScheme == .dark ? .clear : Color(uiColor: .lightGray)
    }
    
    @State private var showAll: Bool = false
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                List {
                    Section(activeSectionTitle) {
                        ForEach(activeList) {
                            TodoRowView(todo: $0, shouldReloadWidget: $0 == activeList.first)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 10)
                                        .background(.clear)
                                        .foregroundColor(rowBackgroundColor)
                                        .padding(
                                            EdgeInsets(
                                                top: 2,
                                                leading: 10,
                                                bottom: 5,
                                                trailing: 10
                                            )
                                        )
                                        .shadow(color: rowShadowColor.opacity(0.3),
                                                radius: 10, x: 0, y: 1)
                                )
                                .listRowSeparator(.hidden)
                        }
                    }
                    
                    /// Completed List
                    CompletedTodoList(showAll: $showAll)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .background(.clear)
                                .foregroundColor(rowBackgroundColor)
                                .padding(
                                    EdgeInsets(
                                        top: 2,
                                        leading: 10,
                                        bottom: 5,
                                        trailing: 10
                                    )
                                )
                                .shadow(color: rowShadowColor.opacity(0.3),
                                        radius: 10, x: 0, y: 1)
                        )
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                .navigationTitle("Todo List")
                Button(action: {
                    /// Creating an Empty Todo Task
                    let todo = Todo(task: "", priority: .normal)
                    /// Saving item into context
                    context.insert(todo)
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .renderingMode(.template)
                        .foregroundColor(appTint)
                        .fontWeight(.light)
                        .font(.system(size: 50))
                        .shadow(radius: 4, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 2)
                                .padding(4)
                                .opacity(0.5)
                        )
                })
                .padding()
                
            }
            .background(backgroundColor)
        }
    }
    
    var activeSectionTitle: String {
        let count = activeList.count
        return count == 0 ? "Active" : "Active (\(count))"
    }
}

#Preview {
    ContentView()
}
