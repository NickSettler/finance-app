//
//  CardRectKey.swift
//  Finance App
//
//  Created by Никита Моисеев on 18.05.2023.
//

import SwiftUI

struct CardRectKey : PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}
