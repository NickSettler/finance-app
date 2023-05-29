//
//  Color.swift
//  Finance App
//
//  Created by Никита Моисеев on 26.05.2023.
//

import Foundation
import SwiftUI

extension Color {
    static var theme: Color  {
        return Color("theme")
    }
    
    static var BackgroundColor: Color  {
        return Color("BackgroundColor")
    }
    
    static var BackgroundColorList: Color  {
        return Color("BackgroundColorList")
    }
    
    static var ColorPrimary: Color  {
        return Color("ColorPrimary")
    }
    
    static var Accent: Color  {
        return Color("AccentColor")
    }
    
    static var TextColorPrimary: Color  {
        return Color("TextColorPrimary")
    }
    
    static var TextColorSecondary: Color  {
        return Color("TextColorSecondary")
    }
    
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            opacity: alpha
        )
    }
    
    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        
        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
    
    func toHex() -> UInt? {
        let components = self.components()
        
        let r = Int(components.r * 255) << 16
        let g = Int(components.g * 255) << 8
        let b = Int(components.b * 255)
        
        return UInt(r + g + b)
    }
}
