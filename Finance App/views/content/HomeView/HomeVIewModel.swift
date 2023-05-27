//
//  HomeVIew2Model.swift
//  Finance App
//
//  Created by Никита Моисеев on 26.05.2023.
//

import Foundation
import FirebaseAuth

@MainActor class HomeViewModel : ObservableObject {
    @Published var recentTransactions: [Transaction] = []
    @Published var categories: [Category] = []
    
    @Published var showAddTransactionSheet: Bool = false
    
    private(set) var currentUser: User?
    
    var recentSpent: Double {
        get {
            self.recentTransactions.reduce(0) { sum, transaction in
                sum.advanced(by: transaction.amount)
            }
        }
    }
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func fetchTransactions() {
        Task {
            do {
                guard let uid = self.currentUser?.uid else { return }
                
                self.recentTransactions = try await TransactionService.getTransactions(for: uid).get()
                self.recentTransactions = Array(self.recentTransactions[..<min(self.recentTransactions.count, 10)])
                    .sorted(by: \.timestamp.seconds, using: (>))
            } catch {
                print(error)
            }
        }
    }
    
    func createTransaction(_ transaction: Transaction) {
        Task {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            _ = await transaction.post(
                to: "\(FirestoreCollection.USER_DATA.rawValue)/\(uid)/\(FirestoreCollection.TRANSACTIONS.rawValue)"
            )
            
            self.fetchTransactions()
        }
    }
}
