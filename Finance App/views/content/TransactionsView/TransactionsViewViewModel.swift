//
//  TransactionsViewViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 24.05.2023.
//

import Foundation
import FirebaseAuth

@MainActor class TransactionsViewViewModel : ObservableObject {
    private(set) var currentUser: User?
    
    @Published var transactions: [Transaction] = [
//        .init(id: "124", name: "Salary", amount: 12, timestamp: .init(date: .now.addingTimeInterval(TimeInterval(-60 * 60 * 24 * 7)))),
//        .init(id: "123", name: "Food", amount: -100, timestamp: .init(date: .now.addingTimeInterval(TimeInterval(-60 * 60 * 24 * 13))))
    ]
    
    @Published var isSortingDesc: Bool = false
    
    @Published var isFilterSheetPresent: Bool = false
    
    @Published var afterDate: Date?
    @Published var editingAfterDate: Date = .now
    @Published var beforeDate: Date?
    @Published var editingBeforeDate: Date = .now
    
    var filteredTransactions: [Transaction] {
        self.transactions
            .filter { transaction in
                let isAfterDateMatch = (afterDate ?? transaction.timestamp.dateValue()) <= transaction.timestamp.dateValue()
                let isBeforeDateMatch = (beforeDate ?? transaction.timestamp.dateValue()) >= transaction.timestamp.dateValue()
                
                return isAfterDateMatch && isBeforeDateMatch
            }
            .sorted(by: \.timestamp.seconds, using: isSortingDesc ? (>) : (<))
    }
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func fetchTransactions() {
        Task {
            guard let uid = self.currentUser?.uid else { return }
            
            do {
                self.transactions = try await TransactionService.getTransactions(for: uid).get()
            } catch {
                print(error)
            }
        }
    }
    
    func displayFilters() {
        editingAfterDate = afterDate ?? .now
        editingBeforeDate = beforeDate ?? .now
        
        isFilterSheetPresent = true
    }
    
    func applyFilters() {
        afterDate = editingAfterDate
        beforeDate = editingBeforeDate
        
        isFilterSheetPresent = false
    }
}
