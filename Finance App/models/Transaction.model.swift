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
    var category: DocumentReference?
    var name: String?
    var timestamp: Timestamp
    
    enum CodingKeys: CodingKey {
        case id
        case amount
        case category
        case name
        case timestamp
    }
    
    init(id: String, amount: Double, timestamp: Timestamp) {
        self.id = id
        self.amount = amount
        self.timestamp = timestamp
    }
}
