//
//  Colors.swift
//  Finance App
//
//  Created by Nikita Moiseev on 28.05.2023.
//

import SwiftUI
import Foundation

func generateColors(from fromColor: UIColor, to toColor: UIColor, steps: Int) -> [Color] {
    if steps == 0 {
        return []
    }
    
    var colors = [Color]()
    
    for i in 0..<steps {
        let t = CGFloat(i) / CGFloat(steps)
        let intermediateColor = UIColor.interpolateColor(from: fromColor, to: toColor, percentage: t)
        let swiftUIColor = Color(intermediateColor)
        colors.append(swiftUIColor)
    }
    
    return colors
}
