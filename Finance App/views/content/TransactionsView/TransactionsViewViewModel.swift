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
        .init(id: "124", amount: 12, category: unknownCategory, name: "Salary", timestamp: .init(date: .now.addingTimeInterval(TimeInterval(-60 * 60 * 24 * 7)))),
        .init(id: "123", amount: -100, category: unknownCategory, name: "Food", timestamp: .init(date: .now.addingTimeInterval(TimeInterval(-60 * 60 * 24 * 13))))
    ]
    
    @Published var isSortingDesc: Bool = true
    
    @Published var isFilterSheetPresent: Bool = false

    @Published var afterDate: Date?
    @Published var editingAfterDate: Date = .now
    @Published var beforeDate: Date?
    @Published var editingBeforeDate: Date = .now
    
    @Published var direction: Int = 0
    
    private var initialAfterDate: Date {
        guard let firstTransaction = self.transactions
            .sorted(by: \.timestamp.seconds, using: (<))
            .first else { return .now }
        
        return firstTransaction.timestamp.dateValue()
    }
    
    private var initialBeforeDate: Date = .now
    
    var canReset: Bool {
        let afterDateChanged = abs(initialAfterDate.timeIntervalSince(editingAfterDate)) > 60 * 60 * 24
        let beforeDateChanged = abs(initialBeforeDate.timeIntervalSince(editingBeforeDate)) > 60 * 60 * 24
        let directionChanged = direction != 0
        
        return afterDateChanged || beforeDateChanged || directionChanged
    }
    
    var filteredTransactions: [Transaction] {
        self.transactions
            .filter { transaction in
                let isAfterDateMatch = (afterDate ?? transaction.timestamp.dateValue()) <= transaction.timestamp.dateValue()
                let isBeforeDateMatch = (beforeDate ?? transaction.timestamp.dateValue()) >= transaction.timestamp.dateValue()
                
                let satisfyDirection = direction == 1 && transaction.amount > 0 || direction == -1 && transaction.amount < 0
                let checkDirection = direction != 0
                
                return isAfterDateMatch && isBeforeDateMatch && (!checkDirection || satisfyDirection)
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
        editingAfterDate = afterDate ?? initialAfterDate
        editingBeforeDate = beforeDate ?? initialBeforeDate
        
        isFilterSheetPresent = true
    }
    
    func applyFilters() {
        afterDate = editingAfterDate
        beforeDate = editingBeforeDate
        
        isFilterSheetPresent = false
    }
    
    func resetFilters() {
        editingAfterDate = initialAfterDate
        editingBeforeDate = initialBeforeDate
        direction = 0
        
        applyFilters()
    }
}
