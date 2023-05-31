//
//  Category.model.swift
//  Finance App
//
//  Created by Nikita Moiseev on 29.03.2023.
//

import SwiftUI
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Category : FirebaseIdentifiable {
    @DocumentID var id: String?
    var name: String
    var icon: String
    var color: Int
    var colorObject: Color {
        get {
            return Color.init(hex: UInt(self.color))
        }
        set {
            self.color = Int(newValue.toHex() ?? 0)
        }
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case icon
        case color
    }
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
        self.color = 0x000000
    }
    
    init(id: String, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = 0x000000
    }
    
    init(id: String, name: String, icon: String, color: Int) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
    }
}

let unknownCategory: Category = .init(id: "UNKNOWN", name: "Unknown", icon: "questionmark")

let categoryColors: [Color] = [
    // Pastel Red
    .init(hex: 0xFF7878),
    .init(hex: 0xE97777),
    .init(hex: 0xFF8787),
    .init(hex: 0xFF9F9F),
    .init(hex: 0xF7A4A4),
    
    // Pastel Orange
    .init(hex: 0xFAAB78),
    .init(hex: 0xECA869),
    .init(hex: 0xDFA67B),
    .init(hex: 0xF4B183),
    .init(hex: 0xFFDCA9),
    
    // Pastel Yellow
    .init(hex: 0xFFD966),
    .init(hex: 0xF2D388),
    .init(hex: 0xE4D192),
    .init(hex: 0xFFDEB4),
    .init(hex: 0xFFF89A),
    
    // Pastel Teal
    .init(hex: 0x54BAB9),
    .init(hex: 0xA7D2CB),
    .init(hex: 0x86C8BC),
    .init(hex: 0x9ED2C6),
    .init(hex: 0xC4DFDF),
    
    // Pastel Blue
    .init(hex: 0x7286D3),
    .init(hex: 0x8EA7E9),
    .init(hex: 0x6096B4),
    .init(hex: 0x93BFCF),
    .init(hex: 0xB8E8FC),
    
    // Pastel Purple
    .init(hex: 0xEA8FEA),
    .init(hex: 0xFFAACF),
    .init(hex: 0xD9ACF5),
    .init(hex: 0xFFCEFE),
    .init(hex: 0xBA94D1),
]
