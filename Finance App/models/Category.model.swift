//
//  Category.model.swift
//  Finance App
//
//  Created by Никита Моисеев on 29.03.2023.
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
    .init(hex: 0xa83330),
    .init(hex: 0x12b431),
    .init(hex: 0x25a361),
    .init(hex: 0x332db9),
    .init(hex: 0xac258e),
    .init(hex: 0x26a437),
    .init(hex: 0x5abb0e),
    .init(hex: 0x8b9c22),
    .init(hex: 0x2a8c9c),
    .init(hex: 0xa77019),
    .init(hex: 0x269e8d),
    .init(hex: 0x3a239b),
    .init(hex: 0xb8ae1e),
    .init(hex: 0xb23922),
    .init(hex: 0x25a065),
    .init(hex: 0xba7632),
    .init(hex: 0x1ab2ae),
    .init(hex: 0xa2b30a),
    .init(hex: 0xaf2d0e),
    .init(hex: 0x4fb321),
    .init(hex: 0x34ad46),
    .init(hex: 0xb6582b),
    .init(hex: 0x1559bb),
    .init(hex: 0x64bd2d),
    .init(hex: 0x12a90d),
    .init(hex: 0x1c997f),
    .init(hex: 0xbb8622),
    .init(hex: 0x0a93b0),
    .init(hex: 0x36bdab),
    .init(hex: 0xb72d76),
    .init(hex: 0x2523a3),
    .init(hex: 0x2ca61d),
    .init(hex: 0x2579af),
    .init(hex: 0x9a0f8d),
    .init(hex: 0x20a81b),
    .init(hex: 0x112c99),
    .init(hex: 0x869a1f),
    .init(hex: 0xb3651b),
    .init(hex: 0x1575a1),
    .init(hex: 0x1e99ae),
    .init(hex: 0xb91274),
    .init(hex: 0xb94535),
    .init(hex: 0x7eb22f),
    .init(hex: 0x8d0aa9),
    .init(hex: 0x3d9a22),
    .init(hex: 0xa8912a),
    .init(hex: 0xb01781),
    .init(hex: 0x2024b1),
    .init(hex: 0xb48213),
    .init(hex: 0x3c25a8),
]
