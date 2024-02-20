//
//  Charts.swift
//  TodoMin
//
//  Created by Cevher Şirin on 20.02.2024.
//

import SwiftUI
import Charts

struct Charts: View {
    
    private var status: [ChartData] = [
        .init(name: "done", count: 2),
        .init(name: "undone", count: 9)
    ]
    
    private var priority: [ChartData] = [
        .init(name: "normal", count: 2),
        .init(name: "medium", count: 4),
        .init(name: "heigh", count: 5)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 20) {
                    Section {
                        ChartView(data: status, isStatus: true)
                        Spacer()
                        BarChartView(data: status, isStatus: true)
                    } header: {
                        Text("Task Status")
                            .font(.title2.bold())
                            .foregroundStyle(.gray)
                            .hSpacing(.leading)
                    }
                    Section {
                        ChartView(data: priority, isStatus: false)
                        Spacer()
                        BarChartView(data: priority, isStatus: false)
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
}

#Preview {
    Charts()
}
