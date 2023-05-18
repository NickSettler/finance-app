//
//  Account.model.swift
//  Finance App
//
//  Created by Никита Моисеев on 18.05.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Account : FirebaseIdentifiable {
    @DocumentID var id: String?
    var name: String
    
    enum CodingKeys : CodingKey {
        case id
        case name
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

var allAccounts: [Account] = [
    .init(id: "123", name: "Main Account"),
    .init(id: "124", name: "Company account"),
    .init(id: "125", name: "Company account"),
    .init(id: "126", name: "Company account"),
]
