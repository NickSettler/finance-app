//
//  TransactionService.swift
//  Finance App
//
//  Created by Nikita Moiseev on 11.04.2023.
//

import Foundation

struct TransactionService {
    static func getTransactions(for id: String) async -> Result<[Transaction], Error> {
        do {
            let query = FirebaseService.shared.database
                .collection(FirestoreCollection.USER_DATA.rawValue)
                .document(id)
                .collection(FirestoreCollection.TRANSACTIONS.rawValue)
            
            let data = try await FirebaseService.shared.getMany(of: Transaction.self, with: query).get()
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}
