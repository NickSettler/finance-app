//
//  PieChart.swift
//  Finance App
//
//  Created by Nikita Moiseev on 28.05.2023.
//

import SwiftUI

struct PieChartView: View {
    public let values: [Double]
    public var colors: [Color]
    public var names: [String]?
    public var size: CGFloat
    
    @State var selectedIndex: Int?
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            
            tempSlices.append(
                PieSliceData(
                    startAngle: Angle(degrees: endDeg),
                    endAngle: Angle(degrees: endDeg + degrees),
                    text: String(format: "%.0f%%", value * 100 / sum),
                    color: self.colors[i]
                )
            )
            endDeg += degrees
        }
        return tempSlices
    }
    
    var body: some View {
        if values.count != colors.count || values.count != names?.count {
            Text("Wrong data")
        } else {
            VStack {
                ZStack {
                    ForEach(0..<self.values.count, id: \.self) { i in
                        PieSliceView(
                            pieSliceData: self.slices[i],
                            size: size,
                            scaled: selectedIndex == i
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                if selectedIndex == i {
                                    selectedIndex = nil
                                } else {
                                    selectedIndex = i
                                }
                            }
                        }
                    }
                    .frame(width: size, height: size)
                    
                    Circle()
                        .fill(Color.ColorPrimary)
                        .frame(width: size * 0.8, height: size * 0.8)
                    
                    VStack {
                        if let index = selectedIndex, let index = index >= self.values.count ? nil : index {
                            Text(names?[index] ?? "")
                                .font(.body)
                                .foregroundColor(.TextColorSecondary)
                            Text(values[index], format: .currency(code: "CZK"))
                                .font(.headline)
                                .foregroundColor(.TextColorPrimary)
                        } else {
                            Text("Total")
                                .font(.body)
                                .foregroundColor(.TextColorSecondary)
                            Text(values.reduce(0, +), format: .currency(code: "CZK"))
                                .font(.headline)
                                .foregroundColor(.TextColorPrimary)
                        }
                    }
                }
                
                PieChartRows(
                    colors: colors,
                    names: names ?? values.indices.map{ String($0) },
                    values: values,
                    selectedIndex: .init(get: {
                        guard let index = self.selectedIndex else { return nil }
                        
                        return index >= self.values.count ? nil : index
                    }, set: { index in
                        self.selectedIndex = index
                    })
                )
            }
            .foregroundColor(Color.TextColorPrimary)
        }
    }
}

struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(
            values: [1300, 500, 300],
            colors: [Color.blue, Color.green, Color.orange],
            names: ["abc", "def", "hhh"],
            size: 200
        )
    }
}
