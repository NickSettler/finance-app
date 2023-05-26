//
//  HomeVIew2Model.swift
//  Finance App
//
//  Created by Никита Моисеев on 26.05.2023.
//

import Foundation
import FirebaseAuth

@MainActor class HomeViewModel : ObservableObject {
    @Published var recentTransactions: [Transaction] = [
        .init(id: "123", name: "Food", amount: -123, timestamp: .init(date: .now.addingTimeInterval(TimeInterval(60 * 60 * 24 * 3)))),
        .init(id: "124", name: "Salary", amount: -623, timestamp: .init(date: .now.addingTimeInterval(TimeInterval(60 * 60 * 24 * 4)))),
        .init(id: "125", name: "Kebab", amount: 423, timestamp: .init(date: .now.addingTimeInterval(TimeInterval(60 * 60 * 24 * 6))))
    ]
    @Published var categories: [Category] = []
    
    private(set) var currentUser: User?
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func fetchTransactions() {
        Task {
            do {
                guard let uid = self.currentUser?.uid else { return }
                
                self.recentTransactions = try await TransactionService.getTransactions(for: uid).get()
                self.recentTransactions = Array(self.recentTransactions[...min(self.recentTransactions.count, 10)])
            } catch {
                print(error)
            }
        }
    }
}
