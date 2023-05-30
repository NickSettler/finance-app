//
//  PieChartRows.swift
//  Finance App
//
//  Created by Nikita Moiseev on 28.05.2023.
//

import SwiftUI

struct PieChartRows: View {
    var colors: [Color]
    var names: [String]
    var values: [Double]
    @Binding var selectedIndex: Int?
    
    var body: some View {
        let total = values.reduce(0, +)
        
        VStack(spacing: 0) {
            ForEach(0..<self.values.count, id: \.self) { i in
                HStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(self.colors[i])
                        .frame(width: 20, height: 20)
                    
                    Text(self.names[i])
                        .font(.headline)
                        .foregroundColor(.TextColorPrimary)
                    
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i], format: .currency(code: "CZK"))
                            .font(.callout)
                            .foregroundColor(.TextColorPrimary)
                        
                        Text(String(format: "%.0f%%", self.values[i] / total * 100))
                            .font(.caption)
                            .foregroundColor(.TextColorSecondary)
                    }
                }
                .padding(.vertical, 8)
                .background(Color.ColorPrimary)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        if selectedIndex == i {
                            selectedIndex = nil
                        } else {
                            selectedIndex = i
                        }
                    }
                }
                .overlay {
                    if selectedIndex != nil && selectedIndex != i {
                        Rectangle()
                            .fill(Color.ColorPrimary)
                            .opacity(0.4)
                    }
                }
            }
        }
    }
}

struct PieChartRows_Previews: PreviewProvider {
    static var previews: some View {
        PieChartRows(
            colors: [Color.blue, Color.green, Color.orange],
            names: ["abc", "def", "hhh"],
            values: [1300, 500, 300],
            selectedIndex: .constant(1)
        )
    }
}
