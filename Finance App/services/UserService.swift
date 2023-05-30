//
//  UserService.swift
//  Finance App
//
//  Created by Nikita Moiseev on 25.03.2023.
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
    
    static func getUserData(by id: String) async -> Result<UserData, Error> {
        let query = FirebaseService.shared.database
            .collection(FirestoreCollection.USER_DATA.rawValue)
        
        do {
            let data = try await FirebaseService.shared.getOne(of: UserData.self, with: query, by: id).get()
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    static func updateBalance(by id: String, _ balance: Double) async throws -> Result<Void, Error> {
        let query = FirebaseService.shared.database
            .collection(FirestoreCollection.USER_DATA.rawValue)
        
        do {
            let transactions = try await TransactionService.getTransactions(for: id).get()
            
            let newBalance = transactions.reduce(balance) { balance, transaction in
                balance.advanced(by: transaction.amount * -1)
            }
            
            var data = try await FirebaseService.shared.getOne(of: UserData.self, with: query, by: id).get()
            data.balance = newBalance
            
            _ = await data.put(to: FirestoreCollection.USER_DATA.rawValue)

            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
