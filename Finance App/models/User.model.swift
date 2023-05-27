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

struct UserData: FirebaseIdentifiable {
    @DocumentID var id: String?
    var first_name: String
    var last_name: String
    var balance: Double
    var full_name: String {
        get {
            return "\(self.first_name) \(self.last_name)"
        }
    }
    
    var collectionPath: String {
        get {
            guard let uid = self.id else {
                return ""
            }
            
            return "\(FirestoreCollection.USER_DATA.rawValue)/\(uid)"
        }
    }
    
    enum CodingKeys: CodingKey {
        case id
        case first_name
        case last_name
        case balance
    }
}
