//
//  Transaction.model.swift
//  Finance App
//
//  Created by Никита Моисеев on 11.04.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Transaction : FirebaseIdentifiable {
    @DocumentID var id: String?
    var amount: Double
    var category: Category
    var name: String
    var timestamp: Timestamp
    
    enum CodingKeys: CodingKey {
        case id
        case amount
        case category
        case name
        case timestamp
    }
    
    init(amount: Double, category: Category, name: String, timestamp: Timestamp) {
        self.amount = amount
        self.category = category
        self.name = name
        self.timestamp = timestamp
    }
    
    init(id: String, amount: Double, category: Category, name: String, timestamp: Timestamp) {
        self.id = id
        self.amount = amount
        self.category = category
        self.name = name
        self.timestamp = timestamp
    }
}
