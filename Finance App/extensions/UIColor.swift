//
//  UIColor.swift
//  Finance App
//
//  Created by Никита Моисеев on 28.05.2023.
//

import SwiftUI

extension UIColor {
    static func interpolateColor(from fromColor: UIColor, to toColor: UIColor, percentage: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let interpolatedRed = fromRed + (toRed - fromRed) * percentage
        let interpolatedGreen = fromGreen + (toGreen - fromGreen) * percentage
        let interpolatedBlue = fromBlue + (toBlue - fromBlue) * percentage
        let interpolatedAlpha = fromAlpha + (toAlpha - fromAlpha) * percentage
        
        return UIColor(red: interpolatedRed, green: interpolatedGreen, blue: interpolatedBlue, alpha: interpolatedAlpha)
    }
}
