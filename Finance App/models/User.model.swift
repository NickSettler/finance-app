//
//  User.model.swift
//  Finance App
//
//  Created by Никита Моисеев on 18.03.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserData: Hashable, Codable {
    @DocumentID var id: String?
    var first_name: String
    var last_name: String
    var full_name: String {
        get {
            return "\(self.first_name) \(self.last_name)"
        }
    }
    
    enum CodingKeys: CodingKey {
        case id
        case first_name
        case last_name
    }
}
