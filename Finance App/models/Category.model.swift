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
    
    enum CodingKeys: CodingKey {
        case id
        case name
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
