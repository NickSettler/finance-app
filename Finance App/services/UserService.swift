//
//  UserService.swift
//  Finance App
//
//  Created by Никита Моисеев on 25.03.2023.
//

import Foundation
import Firebase

struct UserService {
    static func getAuthHistory(by id: String) async -> Result<[AuthHistoryItem], Error> {
        do {
            let query = FirebaseService.shared.database
                .collection(FirestoreCollection.USER_DATA.rawValue)
                .document(id)
                .collection(FirestoreCollection.AUTH_HISTORY.rawValue)
            
            let data = try await FirebaseService.shared.getMany(of: AuthHistoryItem.self, with: query).get()
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    static func addAuthHistory(by id: String) async throws -> Result<Void, Error> {
        let doc = FirebaseService.shared.database
            .collection(FirestoreCollection.USER_DATA.rawValue)
            .document(id)
            .collection(FirestoreCollection.AUTH_HISTORY.rawValue)
            .document()
        
        do {
            try await doc.setData([
                AuthHistoryItem.CodingKeys.timestamp.stringValue: Timestamp(date: Date()),
            ])
        } catch {
            return .failure(error)
        }
        
        return .success(())
    }
}
