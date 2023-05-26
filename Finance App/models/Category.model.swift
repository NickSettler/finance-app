//
//  Category.model.swift
//  Finance App
//
//  Created by Никита Моисеев on 29.03.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Category : FirebaseIdentifiable {
    @DocumentID var id: String?
    var name: String
    var icon: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case icon
    }
    
    init(name: String, icon: String) {
        self.name = name
        self.icon = icon
    }
    
    init(id: String, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}

let unknownCategory: Category = .init(id: "UNKNOWN", name: "Unknown", icon: "questionmark")
