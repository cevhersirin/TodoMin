//
//  Charts.swift
//  TodoMin
//
//  Created by Cevher Şirin on 20.02.2024.
//

import SwiftUI
import Charts
import SwiftData

struct Charts: View {
    /// All Todo's
    @Query private var allTodoList: [Todo]
    /// Actiive Todo's
    @Query(filter: #Predicate<Todo> { !$0.isCompleted }, sort: [SortDescriptor(\Todo.lastUpdated, order: .reverse)], animation: .snappy) private var activeList: [Todo]
    /// Actiive Todo's
    @Query(filter: #Predicate<Todo> { $0.isCompleted }, sort: [SortDescriptor(\Todo.lastUpdated, order: .reverse)], animation: .snappy) private var inActiveList: [Todo]
    /// Model Context
    @Environment(\.modelContext) private var context
    
    private var activeListCount: Int {
        return activeList.count
    }
    
    private var inActiveListCount: Int {
        return inActiveList.count
    }
    
    private var normalCount: Int {
        let normalList = allTodoList.filter( { $0.priority == .normal } )
        return normalList.count
    }
    
    private var mediumCount: Int {
        let mediumList = allTodoList.filter( { $0.priority == .medium } )
        return mediumList.count
    }
    
    private var heightCount: Int {
        let heighList = allTodoList.filter( { $0.priority == .heigh } )
        return heighList.count
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 20) {
                    Section {
                        ChartView(data: createActiveListChartData(), isStatus: true)
                        Spacer()
                        BarChartView(data: createActiveListChartData(), isStatus: true)
                    } header: {
                        Text("Task Status")
                            .font(.title2.bold())
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                    }
                    Section {
                        ChartView(data: createPriorityChartData(), isStatus: false)
                        Spacer()
                        BarChartView(data: createPriorityChartData(), isStatus: false)
                        Spacer()
                    } header: {
                        Text("Task Priorities")
                            .font(.title2.bold())
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                    }
                }
                .padding(15)
            }
            .background(.gray.opacity(0.15))
            .navigationTitle("Charts")
        }
    }
    
    @ViewBuilder
    func ChartView(data: [ChartData], isStatus: Bool) -> some View {
        /// Chart View
        Chart {
            ForEach(data, id: \.name) { item in
                SectorMark(angle: .value("adet", item.count), innerRadius: .ratio(0.65), angularInset: 2.0)
                    .foregroundStyle(by: .value("Type", item.name))
                    .cornerRadius(10.0)
                    .annotation(position: .overlay) {
                        Text("\(item.count)")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
            }
        }
        .chartLegend(position: .bottom, alignment: .center)
        /// Foreground Colors
        .chartForegroundStyleScale(range: isStatus ? [Color.green.gradient, Color.red.gradient] : [normalPriorityColor.gradient,
                                                                                                    mediumPriorityColor.gradient,
                                                                                                    heighPriorityColor.gradient])
        .chartBackground { proxy in
            Text("📊")
                .font(.system(size: 40))
        }
        .frame(width: 200, height: 200)
    }
    
    @ViewBuilder
    func BarChartView(data: [ChartData], isStatus: Bool) -> some View {
        Chart{
            
            ForEach(data, id: \.id) { item in
                BarMark(
                    x: .value("Name", item.count),
                    y: .value("Storage", item.type),
                    stacking: .center)
                .annotation(position: .overlay) {
                    Text("\(item.count)")
                        .font(.footnote.bold())
                        .foregroundStyle(.white)
                }
                .foregroundStyle(by: .value("Name", item.name))
                .cornerRadius(8)
            }
            
        }
        .chartForegroundStyleScale(range: isStatus ? [Color.green.gradient, Color.red.gradient] : [normalPriorityColor.gradient,
                                                                                                    mediumPriorityColor.gradient,
                                                                                                    heighPriorityColor.gradient])
        .padding(.horizontal)
        .frame(height: 60)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
    
    func createActiveListChartData() -> [ChartData] {
        var status: [ChartData] = [
            .init(name: "done", count: inActiveListCount),
            .init(name: "undone", count: activeListCount)
        ]
        return status
    }
    
    func createPriorityChartData() -> [ChartData] {
        var priority: [ChartData] = [
            .init(name: "normal", count: normalCount),
            .init(name: "medium", count: mediumCount),
            .init(name: "heigh", count: heightCount)
        ]
        return priority
    }
}

#Preview {
    Charts()
}
