//
//  Transaction.model.swift
//  Finance App
//
//  Created by Nikita Moiseev on 11.04.2023.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Transaction : FirebaseIdentifiable {
    @DocumentID var id: String?
    var amount: Double
    var category: DocumentReference
    var name: String
    var timestamp: Timestamp
    var notes: String?
    
    enum CodingKeys: CodingKey {
        case id
        case amount
        case category
        case name
        case timestamp
        case notes
    }
    
    init(amount: Double, category: DocumentReference, name: String, timestamp: Timestamp) {
        self.amount = amount
        self.category = category
        self.name = name
        self.timestamp = timestamp
    }
    
    init(id: String, amount: Double, category: DocumentReference, name: String, timestamp: Timestamp, notes: String?) {
        self.id = id
        self.amount = amount
        self.category = category
        self.name = name
        self.timestamp = timestamp
        self.notes = notes
    }
    
    init(amount: Double, category: Category, name: String, timestamp: Timestamp) {
        self.amount = amount
        self.category = FirebaseService.shared.database
            .collection(FirestoreCollection.CATEGORIES.rawValue)
            .document(category.id ?? "UNKNOWN")
        self.name = name
        self.timestamp = timestamp
    }
    
    init(id: String, amount: Double, category: Category, name: String, timestamp: Timestamp, notes: String?) {
        self.id = id
        self.amount = amount
        self.category = FirebaseService.shared.database
            .collection(FirestoreCollection.CATEGORIES.rawValue)
            .document(category.id ?? "UNKNOWN")
        self.name = name
        self.timestamp = timestamp
        self.notes = notes
    }
}
