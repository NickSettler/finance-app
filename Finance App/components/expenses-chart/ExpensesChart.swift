//
//  ExpensesChart.swift
//  Finance App
//
//  Created by Никита Моисеев on 11.04.2023.
//

import SwiftUI
import Charts

struct ExpensesChart: View {
    @StateObject var viewModel = ExpensesChartViewModel()
    
    @State private var isCollapsed: Bool = false
    
    var body: some View {
        VStack {
            Chart {
                ForEach(Array(zip(
                    viewModel.transactions,
                    viewModel.transactions.indices
                )), id: \.0) { trans, index in
                    LineMark(
                        x: .value("Time", trans.timestamp.dateValue() ..< trans.timestamp.dateValue().advanced(by: 1800)),
                        y: .value("Amount", trans.amount)
                    )
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .hour, count: 1)) { value in
                    if let date = value.as(Date.self) {
                        let hour = Calendar.current.component(.hour, from: date)
                        
                        if !isCollapsed {
                            AxisValueLabel {
                                VStack(alignment: .leading) {
                                    switch hour {
                                    case 0, 12:
                                        Text(date, format: .dateTime.hour())
                                    default:
                                        Text(date, format: .dateTime.hour(.defaultDigits(amPM: .omitted)))
                                    }
                                    if value.index == 0 || hour == 0 {
                                        Text(date, format: .dateTime.month().day())
                                    }
                                }
                            }
                        }
                        
                        if hour == 0 {
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                        } else {
                            AxisGridLine()
                            AxisTick()
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: isCollapsed ? 3 : 4)) { value in
                    if let amount = value.as(Double.self) {
                        if !isCollapsed {
                            AxisValueLabel {
                                Text(amount, format: .number)
                            }
                        }
                    }
                    
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                }
            }
            .frame(maxHeight: isCollapsed ? 48 : .infinity)
            .padding()
            .onTapGesture {
                withAnimation {
                    self.isCollapsed.toggle()
                }
            }
        }
        .onAppear {
            viewModel.handleAppear()
        }
    }
}

struct ExpensesChart_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesChart()
    }
}
