//
//  AuthHistoryItem.model.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AuthHistoryItem : Hashable, Codable {
    @DocumentID var id: String?
    var timestamp: Date
    
    init(id: String, timestamp: Timestamp) {
        self.id = id
        self.timestamp = timestamp.dateValue()
    }
    
    enum CodingKeys: CodingKey {
        case id
        case timestamp
    }
}
