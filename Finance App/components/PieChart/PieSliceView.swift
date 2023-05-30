//
//  PieSliceView.swift
//  Finance App
//
//  Created by Nikita Moiseev on 28.05.2023.
//

import SwiftUI

struct PieSliceView: View {
    var pieSliceData: PieSliceData
    var size: CGFloat
    var scaled: Bool
    
    var midRadians: Double {
        return Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2.0
    }
    
    var body: some View {
        VStack {
            ZStack {
                Path { path in
                    let center = CGPoint(x: size * 0.5, y: size * 0.5)
                    
                    path.move(to: center)
                    
                    path.addArc(
                        center: center,
                        radius: size * 0.5,
                        startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
                        endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
                        clockwise: false)
                    
                }
                .fill(pieSliceData.color)
                .scaleEffect(scaled ? 1 : 0.95)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct PieSliceView_Previews: PreviewProvider {
    static var previews: some View {
        PieSliceView(
            pieSliceData: .init(
                startAngle: Angle(degrees: 0.0),
                endAngle: Angle(degrees: 220.0),
                text: "65%",
                color: Color.black),
            size: 300,
            scaled: false
        )
    }
}
